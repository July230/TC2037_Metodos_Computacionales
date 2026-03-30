/*
Ian Julián Estrada Castro - A01352823
Actividad Integradora 3 - Programación paralela

Utilizando hilos en C/C++ y CUDA, escribe las versiones de un programa que calcule la suma de 
todos los números primos menores a 5,000,000 (cinco millones)

Este archivo corresponde a la solución hecha en cuda (con hilos)

g++ primos_cuda.cpp -o app -pthread
*/

#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <ctime>
#include <cmath>
#include <chrono>
#include <cuda_runtime.h>

using namespace std;
using namespace std::chrono;

#define SIZE 5000000 // 5e6
#define THREADS 512
#define BLOCKS 	min(32, ((SIZE / THREADS) + 1))
#define N 10

// Generar un arreglo con los numeros del 1 al 5000000 (cinco millones)
// Complejidad O(n)
// n es el numero de localidades
void generarNumeros(int *arreglo){
    for(int i = 0; i < SIZE; i++){
        arreglo[i] = i + 1;
    }
}

// Función para determinar si un número es primo o no
// Complejidad O(sqrt(n))
// Donde n es la cantidad de elementos en el arreglo
// Función para determinar si un número es primo o no (en CUDA)

__device__ bool esPrimo(int numero){
    if(numero < 2){
        return false;
    } 
    for(int i = 2; i <= sqrtf((float)numero); i++){
        if(numero % i == 0){
            return false;
        }
    }
    return true;
}

// Función para determinar si un número es primo o no (en CPU)
bool esPrimoHost(int numero){
    if(numero < 2){
        return false;
    } 
    for(int i = 2; i <= sqrt((float)numero); i++){
        if(numero % i == 0){
            return false;
        }
    }
    return true;
}


// Función que suma los números primos 
// Complejidad O(n)
// Donde n es la cantidad de elementos en el arreglo
// Para CUDA, adaptamos a kernel
__global__ void sumarPrimos(int* arreglo, long long* resultadoParciales, int tamanio){
    __shared__ long long cache[THREADS];
    int index = threadIdx.x + (blockIdx.x * blockDim.x);
    int cacheIndex = threadIdx.x;
    unsigned long long int acum = 0;

    // Cada hilo procesa elementos del arreglo
    while(index < tamanio){ 
        if(esPrimo(arreglo[index])){
            acum += arreglo[index];
        }
        index += blockDim.x * gridDim.x;
    }

    cache[cacheIndex] = acum;

    __syncthreads();

    // Reducción de memoria compartida
    int i = blockDim.x / 2;
    while (i > 0) {
        if (cacheIndex < i) {
            cache[cacheIndex] += cache[cacheIndex + i];
        }
        __syncthreads();
        i /= 2;
    }

    if (cacheIndex == 0) {
        resultadoParciales[blockIdx.x] = cache[cacheIndex];
    }
}

// Función para contar los números primos hasta SIZE
// Complejidad O(n)
// Donde n es la cantidad de elementos en el arreglo
long long contarPrimos(int *arreglo){
    long long contador = 0;
    for(int i = 0; i < SIZE; i++){
        if(esPrimoHost(arreglo[i])){
            contador++;
        }
    }
    return contador;
}


int main(){

    // Es necesario crear un arreglo local y otro que ira en device (GPU)
    int* h_arreglo = new int[SIZE];
    int* d_arreglo;
    long long cantidad;
    long long h_resultado;
    long long* h_resultadosParciales = new long long[BLOCKS];
    long long* d_resultadosParciales;
    high_resolution_clock::time_point start, end;
    double timeElapsed = 0.0;

    generarNumeros(h_arreglo);
    cantidad = contarPrimos(h_arreglo);

    cudaMalloc(&d_arreglo, SIZE * sizeof(int));
    cudaMalloc(&d_resultadosParciales, BLOCKS * sizeof(long long));


    // Copiar de CPU a GPU
    cudaMemcpy(d_arreglo, h_arreglo, SIZE * sizeof(int), cudaMemcpyHostToDevice);
    
    for(int j = 0; j < N; j++){
        h_resultado = 0;
        start = high_resolution_clock::now();


        // Lanzar la función kernel
        sumarPrimos<<<BLOCKS, THREADS>>>(d_arreglo, d_resultadosParciales, SIZE);

        // Esperar a que todos los hilos terminen
        cudaDeviceSynchronize();

        // Copiar de GPU a CPU
        cudaMemcpy(h_resultadosParciales, d_resultadosParciales, BLOCKS * sizeof(long long), cudaMemcpyDeviceToHost);

        for (int i = 0; i < BLOCKS; i++) {
            h_resultado += h_resultadosParciales[i];
        }

        end = high_resolution_clock::now();

        // Calcular el tiempo promedio
        timeElapsed += duration<double, std::milli>(end - start).count();
    }

    cout << "Último elemento = " << h_arreglo[4999999] << endl;

    cout << "Cantidad de números primos = " << cantidad << endl;

    cout << "Suma de los números primos = " << h_resultado << endl;

    cout << "avg time = " << fixed << setprecision(3) << (timeElapsed/N) << " ms\n";

    // Liberar memoria
    delete [] h_arreglo;
    delete [] h_resultadosParciales;
    cudaFree(d_arreglo);
    cudaFree(d_resultadosParciales);

    return 0;
}