#include <iostream>
#include <iomanip>
#include <chrono>
#include <pthread.h>
#include "utils.h"

using namespace std;
using namespace std::chrono;

const int LENGHT = 100000000; // 1e8
const int THREADS = 4;

// A un hilo se le debe dar un sólo bloque de memoria, con una estructura
typedef struct {
    int start, end, *C, *A, *B;
} Block;

void* add_vector(void* param) {
    Block *b = (Block*) param;

    for (int i = b->start; i < b->end; i++) {
        b->C[i] = b->A[i] + b->B[i];
    }

    return 0;
}

int main(int argc, char* argv[]){
    int *A, *B, *C;
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    int blockSIZE = LENGHT/THREADS; // Tamaño de block es el tamaño del arreglo entre la cantidad de hilos

    // These variable are used to keep track of the execution time
    high_resolution_clock::time_point start, end;
    double timeElapsed;

    A = new int[LENGHT];
    B = new int[LENGHT];
    C = new int[LENGHT];

    fill_array(A, LENGHT);
    display_array("A:", A);
    fill_array(B, LENGHT);
    display_array("B:", B);

    for(int i = 0; i < THREADS; i++){

        // La operación es i*blockSize para el inicio
        // La operación es (i+1) * block para el final
        blocks[i].C = C;
        blocks[i].B = B;
        blocks[i].A = A;
        blocks[i].start = (i * blockSIZE);
        blocks[i].end = (i != (THREADS - 1)) ? (i + 1) * blockSIZE : LENGHT;
    }
    cout << "Starting...\n";
    timeElapsed = 0;
    for(int j = 0; j < N; j++){
        start = high_resolution_clock::now();
        for(int i=0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, add_vector, &blocks[i]);
        }
        for(int i=0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
        }


        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();

    }
    display_array("C:", C);
    cout << "avg time = " << fixed << setprecision(3) << (timeElapsed/N) << " ms\n";

    delete [] A;
    delete [] B;
    delete [] C;

    return 0;
};

// g++ example1.cpp -o app -pthread
// Con más hilos, hay un speed up (Tiempo sin hilos / tiempo con hilos)