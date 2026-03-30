/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 12
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema

Calcular la aproximación de Pi usando la serie de Gregory-Leibniz. El valor de n debe ser 1x107 (10,000,000)
*/

#include <iostream>
#include <iomanip>
#include <ctime>
#include <chrono>
#include <cuda_runtime.h>


using namespace std;
using namespace std::chrono;

#define SIZE 1000000000 // 1e9
#define THREADS 512
#define BLOCKS 	min(64, ((SIZE / THREADS) + 1))

__global__ void digitosPI(double* pi_partial, int start, int end){
    __shared__ double cache[THREADS];
    int index = threadIdx.x + (blockIdx.x * blockDim.x);
    int cacheIndex = threadIdx.x;
    double acum = 0.0;
    double term = 0.0;

    while(index < end){ // Cada hilo procesa elementos del arreglo
        term = (index % 2 == 0 ? 1.0 : -1.0) / (2 * index + 1);
        acum += term;
        index += blockDim.x * gridDim.x;
    }

    cache[cacheIndex] = acum;

    __syncthreads();

    int i = blockDim.x / 2;
    while (i > 0) {
        if (cacheIndex < i) {
            cache[cacheIndex] += cache[cacheIndex + i];
        }
        __syncthreads();
        i /= 2;
    }

    if (cacheIndex == 0) {
        pi_partial[blockIdx.x] = cache[cacheIndex];
    }
}

int main(){
    double* h_pi_partial = new double[BLOCKS];
    double* d_pi_partial;
    high_resolution_clock::time_point start, end;
    double timeElapsed = 0.0;
    double PI = 0.0;
    double suma = 0.0;

    // Reservar memoria en GPU
    cudaMalloc(&d_pi_partial, BLOCKS * sizeof(double));

    for(int j = 0; j < 10; j++){
        start = high_resolution_clock::now();

        // No copiamos de CPU a GPU ya que kernel no requere de una entrada específica

        digitosPI<<<BLOCKS, THREADS>>>(d_pi_partial, 0, SIZE);

        // Esperar a que todos los hilos terminen
        cudaDeviceSynchronize();

        // Copiar contador del GPU al CPU
        cudaMemcpy(h_pi_partial, d_pi_partial, BLOCKS * sizeof(double), cudaMemcpyDeviceToHost);

        // Calcular PI sumando los resultados parciales
        suma = 0.0;
        for(int i = 0; i < BLOCKS; i++){
            suma += h_pi_partial[i];
        }

        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();

    }

    PI = suma * 4;
    // Multiplicar 4 por el total de PI

    cout << "PI: " << PI << endl;
    cout << "Tiempo promedio = " << fixed << setprecision(3) << (timeElapsed/10) << " ms\n";

    // Liberar memoria de la GPU
    cudaFree(d_pi_partial);
    delete [] h_pi_partial;

    return 0;
}
