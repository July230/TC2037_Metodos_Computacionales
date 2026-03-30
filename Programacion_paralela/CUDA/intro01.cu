// =================================================================
//
// File: intro01.cu
// Author: Pedro Perez
// Description: This file shows some of the basic CUDA directives.
//
// Copyright (c) 2023 by Tecnologico de Monterrey.
// All Rights Reserved. May be reproduced for any non-commercial
// purpose.
//
// =================================================================

#include <iostream>
#include <cuda_runtime.h>

using namespace std;

// Los parametros son localidades de memoria, al estilo de THREADS, no es necesario hacer el truco de block
__global__ void add(int *a, int *b, int *c) {
	*c = *a + *b;
}

int main(int argc, char* argv[]) {
	int a, b, c; // Variables en el CPU
	int *d_a, *d_b, *d_c; // Apuntadores para variables que estan en el GPU
	
	a = 12;
	b = 13;

	cudaMalloc((void**) &d_a, sizeof(int)); // Reservando bloques de memoria con cudaMalloc
	cudaMalloc((void**) &d_b, sizeof(int));
	cudaMalloc((void**) &d_c, sizeof(int));

	cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice); // cudaMempcy pasamos memoria del CPU al GPU y viceversa
	cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

    // Host siempre es el CPU y device es el GPU

	add<<<1, 1>>>(d_a, d_b, d_c); // <<1, 1>> Un bloque de un hilo cada uno

	cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

	cout << "c = " << c << "\n";

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	return 0;
}