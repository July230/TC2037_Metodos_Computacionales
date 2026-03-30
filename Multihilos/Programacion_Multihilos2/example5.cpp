// =================================================================
//
// File: example05.cpp
// Author: Pedro Perez
// Description: This file contains the approximation of Pi using the 
//				Monte-Carlo method.The time this implementation 
//				takes will be used as the basis to calculate the 
//				improvement obtained with parallel technologies.
//
// Reference:
//	https://www.geogebra.org/m/cF7RwK3H
//
// Copyright (c) 2024 by Tecnologico de Monterrey.
// All Rights Reserved. May be reproduced for any non-commercial
// purpose.
//
// =================================================================

#include <iostream>
#include <iomanip>
#include <chrono>
#include <random>
#include <pthread.h>
#include <cstdlib>
#include <ctime>
#include "utils.h"

using namespace std;
using namespace std::chrono;

#define INTERVAL 		 10000//1e4
#define NUMBER_OF_POINTS (INTERVAL * INTERVAL) // 1e8
#define THREADS 8

typedef struct {
    int start, end, count;
} Block;

void* aprox_pi(void* param) {
    default_random_engine generator; // Generador de numeros aleatorios
    uniform_real_distribution<double> distribution(0.0, 1.0); // Generar numeros aleatorio dentro de ese rango
    Block *b = (Block*) param;

	b->count = 0;
	for (int i = b->start; i < b->end; i++) {
		double x = (distribution(generator) * 2) - 1; // El centro del cuadrado esta en el punto (0,0)
        double y = (distribution(generator) * 2) - 1;
		double dist = (x * x) + (y * y);
		if (dist <= 1) {
			b->count++;
		}
	}
	return 0;
}

int main(int argc, char* argv[]) {
	double result;
    int count;
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    int blockSize = NUMBER_OF_POINTS / THREADS;
	
	// These variables are used to keep track of the execution time.
	high_resolution_clock::time_point start, end;
	double timeElapsed;

    for(int i = 0; i < THREADS; i++){
        blocks[i].count = 0;
        blocks[i].start = i * blockSize;
        blocks[i].end = (i != (THREADS - 1)) ? (i + 1) * blockSize : NUMBER_OF_POINTS;
    }

	cout << "Starting...\n";
	timeElapsed = 0;
	for (int j = 0; j < N; j++) {
		start = high_resolution_clock::now();

        for(int i = 0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, aprox_pi, &blocks[i]);
        }

        count = 0;
        for(int i = 0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
            count += blocks[i].count;
        }
        result = ((double) (4.0 * count)) / ((double) NUMBER_OF_POINTS);

		end = high_resolution_clock::now();
		timeElapsed += 
			duration<double, std::milli>(end - start).count();
	}
	cout << "result = " << fixed << setprecision(20)  << result << "\n";
	cout << "avg time = " << fixed << setprecision(3) 
		 << (timeElapsed / N) <<  " ms\n";

	return 0;
}

// g++ example5.cpp -o app -pthread