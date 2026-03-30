/*
Ian Julián Estrada Castro - A01352823
Actividad Integradora 3 - Programación paralela

Utilizando hilos en C/C++ y CUDA, escribe las versiones de un programa que calcule la suma de 
todos los números primos menores a 5,000,000 (cinco millones)

Este archivo corresponde a la solución paralela (con hilos)

g++ primos_threads.cpp -o app -pthread
*/

#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <ctime>
#include <cmath>
#include <chrono>
#include <pthread.h>

using namespace std;
using namespace std::chrono;

#define SIZE 5000000 // 5e6
#define THREADS 8
#define N 10

// Variables con las que cuenta cada hilo
typedef struct {

    // long long para trabajar con numeros grandes
    long long start, end, suma;
    int *arreglo;
} Block;

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
bool esPrimo(int numero){
    if(numero < 2){
        return false;
    } 
    int limit = sqrt(numero);
    for(int i = 2; i <= limit; i++){
        if(numero % i == 0){
            return false;
        }
    }
    return true;
}

// Función para contar los números primos hasta SIZE
// Complejidad O(n)
// Donde n es la cantidad de elementos en el arreglo
long long contarPrimos(int *arreglo){
    long long contador = 0;
    for(int i = 0; i < SIZE; i++){
        if(esPrimo(arreglo[i])){
            contador++;
        }
    }
    return contador;
}

// Función que suma los números primos 
// Complejidad O(n)
// Donde n es la cantidad de elementos en el arreglo
void* sumarPrimos(void* param){
    Block* block = (Block*) param;
    long long acum = 0;

    for(long long i = block->start; i < block->end; i++){
        if(esPrimo(block->arreglo[i])){
            acum += block->arreglo[i];
        }
    }
    block->suma = acum;
    return 0;
}

int main(){
    int* arreglo = new int[SIZE];
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    long long BlockSize = SIZE/THREADS;
    long long cantidad, total;
    high_resolution_clock::time_point start, end;
    double timeElapsed = 0.0;

    generarNumeros(arreglo);
    cantidad = contarPrimos(arreglo);

    for (int i = 0; i < THREADS; i++) {
        blocks[i].start = i * BlockSize;
        blocks[i].end = (i == THREADS - 1) ? SIZE : (i + 1) * BlockSize;
        blocks[i].arreglo = arreglo;
    }

    for(int j = 0; j < N; j++){
        total = 0;
        start = high_resolution_clock::now();

        // Crear hilos
        for(int i=0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, sumarPrimos, &blocks[i]);
        }

        // Esperar a que los hilos terminen
        for(int i=0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
            total += blocks[i].suma;
        }

        end = high_resolution_clock::now();

        // Calcular el tiempo promedio
        timeElapsed += duration<double, std::milli>(end - start).count();
    }

    cout << "Último elemento = " << arreglo[4999999] << endl;

    cout << "Cantidad de números primos = " << cantidad << endl;

    cout << "Suma de los números primos = " << total << endl;

    cout << "avg time = " << fixed << setprecision(3) << (timeElapsed/N) << " ms\n";

    delete [] arreglo;
    return 0;
}
