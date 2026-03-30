/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 11
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema

g++ ActividadProgramacion11_2_threads.cpp -o app -pthread

Calcular la aproximación de Pi usando la serie de Gregory-Leibniz. El valor de n debe ser 1x107 (10,000,000)
*/

#include <iostream>
#include <iomanip>
#include <random>
#include <ctime>
#include <chrono>
#include <pthread.h>

using namespace std;
using namespace std::chrono;

#define SIZE 10000000 // 1e7
#define THREADS 8

// A un hilo se le debe dar un sólo bloque de memoria, con una estructura
typedef struct {
    int start, end; 
    double pi_partial;
} Block;

void* digitosPI(void* param){
    Block* block = (Block*) param;
    double acum = 0;

    for (int i = block->start; i < block->end; i++) {
        acum += pow(-1, i) / (2 * i + 1);
    }

    block->pi_partial = acum;

    return 0;
}

int main(){
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    int BlockSize = SIZE/THREADS;

    high_resolution_clock::time_point start, end;
    double timeElapsed = 0.0;
    double PI;

    // Preparar los bloques para cada hilo
    for(int i = 0; i < THREADS; i++){
        blocks[i].pi_partial = 0.0;
        blocks[i].start = i * BlockSize;
        blocks[i].end = (i != (THREADS-1))? (i + 1) * BlockSize : SIZE;
        pthread_create(&tids[i], NULL, digitosPI, &blocks[i]);
    }

    for(int j = 0; j < 10; j++){
        PI = 0.0; // Resetear PI en cada iteración
        start = high_resolution_clock::now();

        // Esperar a que los hilos terminen
        for(int i=0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
            PI += blocks[i].pi_partial;
        }


        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();

    }

    cout << "PI: " << PI * 4 << endl;
    cout << "Tiempo promedio = " << fixed << setprecision(3) << (timeElapsed/10) << " ms\n";

    return 0;
}
