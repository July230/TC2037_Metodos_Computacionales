/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 12
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema

Contar el número de pares que existen en un arreglo de enteros

*/

#include <iostream>
#include <iomanip>
#include <random>
#include <chrono>
#include <algorithm>
#include <cuda_runtime.h>

using namespace std;
using namespace std::chrono;

#define SIZE 1000000000
#define THREADS 512
#define BLOCKS 	min(32, ((SIZE / THREADS) + 1))

// size_t puede guardar la cantidad maxima y teorica posible de un objeto de cualquier tipo, incluyendo un arreglo .
void generarArregloAleatorio(int *arreglo, size_t tamanio){
    for (size_t i = 0; i < tamanio; i++) {
        arreglo[i] = rand() % 100; // Numeros entre 0 y 99
    }
}

// Cambiar a lógica de kernel
__global__ void contarPares(int* arreglo, size_t tamanio, unsigned long long int* count){;
    int index = threadIdx.x + (blockIdx.x * blockDim.x);
    unsigned long long int acum = 0;

    while(index < tamanio){ // Cada hilo procesa elementos del arreglo
        if(arreglo[index] % 2 == 0){
            acum++;
        }
        index += blockDim.x * gridDim.x;
    }
    atomicAdd(count, acum); // Sumar las cuentas locales de cada hilo

}

int main(){
    const size_t tamanio = SIZE;
    int* h_arreglo = new int[tamanio];
    int* d_arreglo;
    unsigned long long int* d_count; // Apuntador para variable que esta en el GPU
    unsigned long long int numPares = 0;
    double timeElapsed = 0;
    high_resolution_clock::time_point start, end;

    // Reservar memoria en GPU
    cudaMalloc(&d_arreglo, tamanio * sizeof(int));
    cudaMalloc(&d_count, sizeof(unsigned long long int));

    // Iniciar arreglo con valores aleatorios
    generarArregloAleatorio(h_arreglo, tamanio);

    for(int j = 0; j < 10; j++){
        // Inicializar contador en el dispositivo a 0 
        cudaMemset(d_count, 0, sizeof(unsigned long long int)); // cudaMemset para iniciar un bloque de memoria en el dispositivo

        start = high_resolution_clock::now();

        // Copiar datos del arreglo al GPU
        cudaMemcpy(d_arreglo, h_arreglo, tamanio * sizeof(int), cudaMemcpyHostToDevice);

        // Lanzar el kernel
        contarPares<<<BLOCKS, THREADS>>>(d_arreglo, tamanio, d_count);

        // Esperar a que todos los hilos terminen
        cudaDeviceSynchronize();

        // Copiar contador del GPU al CPU
        cudaMemcpy(&numPares, d_count, sizeof(unsigned long long int), cudaMemcpyDeviceToHost);

        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();

    }

    cout << "Número de pares: " << numPares << endl;
    cout << "Tiempo promedio = " << fixed << setprecision(3) << (timeElapsed/10) << " ms\n";

    // Liberar memoria de la GPU
    cudaFree(d_arreglo);
    cudaFree(d_count);

    delete [] h_arreglo;

    return 0;
}

