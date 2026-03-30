/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 11
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema

Contar el número de pares que existen en un arreglo de enteros

g++ ActividadProgramacion11_1_threads.cpp -o app -pthread
*/

#include <iostream>
#include <iomanip>
#include <random>
#include <ctime>
#include <chrono>
#include <pthread.h>

using namespace std;
using namespace std::chrono;

#define SIZE 1000000000
#define THREADS 8

// A un hilo se le debe dar un sólo bloque de memoria, con una estructura
typedef struct {
    int start, end;
    int* arreglo;
    size_t count;
} Block;

// size_t puede guardar la cantidad maxima y teorica posible de un objeto de cualquier tipo, incluyendo un arreglo .
void generarArregloAleatorio(int *arreglo, size_t tamanio){
    for (size_t i = 0; i < tamanio; i++) {
        arreglo[i] = rand() % 100; // Numeros entre 0 y 99
    }
}

void* contarPares(void* param){
    Block* block = (Block*) param;
    int acum = 0;

    for(int i = block->start; i < block->end; i++){
        if(block->arreglo[i] % 2 == 0){
            acum++;
        }
    }

    block->count = acum;

    return 0;
}

int main(){
    const size_t tamanio = SIZE;
    int* arreglo = new int[tamanio];
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    size_t BlockSize = SIZE/THREADS;

    high_resolution_clock::time_point start, end;
    double timeElapsed;


    generarArregloAleatorio(arreglo, tamanio);

    for(int j = 0; j < 10; j++){
        // Preparar los bloques para cada hilo
        for (int i = 0; i < THREADS; i++) {
            blocks[i].start = i * BlockSize;
            blocks[i].end = (i == THREADS - 1) ? SIZE : (i + 1) * BlockSize;
            blocks[i].arreglo = arreglo;
        }
        start = high_resolution_clock::now();

        // Crear hilos
        for(int i=0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, contarPares, &blocks[i]);
        }

        // Esperar a que los hilos terminen
        for(int i=0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
        }


        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();

    }

    // Sumar los resultados de los hilos
    size_t numPares = 0;
    for (int i = 0; i < THREADS; i++) {
        numPares += blocks[i].count;
    }

    cout << "Número de pares: " << numPares << endl;
    cout << "Tiempo promedio = " << fixed << setprecision(3) << (timeElapsed/10) << " ms\n";

    delete [] arreglo;

    return 0;
}

