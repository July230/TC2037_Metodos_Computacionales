// =================================================================
//
// File: example04.cpp
// Author: Pedro Perez
// Description: This file implements the algorithm to find the 
//				minimum value in an array. The time this 
//				implementation takes will be used as the basis to 
//				calculate the improvement obtained with parallel 
//				technologies.
//
// Copyright (c) 2024 by Tecnologico de Monterrey.
// All Rights Reserved. May be reproduced for any non-commercial
// purpose.
//
// =================================================================

#include <iostream>
#include <iomanip>
#include <chrono>
#include <pthread.h>
#include <climits>
#include "utils.h"

using namespace std;
using namespace std::chrono;

#define SIZE 1000000000 // 1e9
#define THREADS 8

// Estructura del hilo
typedef struct {
    int start, end, *array, result; // Cada hilo devolvera result en su estructura
} Block; 

void* minimum(void* param) {
    Block *b = (Block*) param;
    b->result = b->array[b->start];
	for (int i = (b->start + 1); i < b->end; i++) {
		if (b->array[i] < b->result) {
			b->result = b->array[i];
		}
	}
	return 0;
}

int main(int argc, char* argv[]) {
	int *array, result;
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    int blocksize = SIZE / THREADS;

	// These variables are used to keep track of the execution time.
	high_resolution_clock::time_point start, end;
	double timeElapsed;

	array = new int [SIZE];
	
	random_array(array, SIZE);
	display_array("array:", array);

    for(int i = 0; i < THREADS; i++){
        blocks[i].array = array;
        blocks[i].result = 0;
        blocks[i].start = i * blocksize;
        blocks[i].end = (i != (THREADS - 1)) ? (i + 1) * blocksize : SIZE;
    }

	cout << "Starting...\n";
	timeElapsed = 0;
	for (int j = 0; j < N; j++) {
		start = high_resolution_clock::now();

		for(int i = 0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, minimum, &blocks[i]);
        }

        result = INT_MAX; // Comparar con un numero grande
        for(int i = 0; i < THREADS; i++){ // Como cada hilo devuelve un resultado parcial, aqui hay que consolidad el resultado
            pthread_join(tids[i], NULL);
            if(blocks[i].result < result){
                result = blocks[i].result;
            }
        }

		end = high_resolution_clock::now();
		timeElapsed += 
			duration<double, std::milli>(end - start).count();
	}
	cout << "result = " << result << "\n";
	cout << "avg time = " << fixed << setprecision(3) 
		 << (timeElapsed / N) <<  " ms\n";

	delete [] array;

	return 0;
}