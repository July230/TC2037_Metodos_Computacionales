/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 11
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema

Contar el número de pares que existen en un arreglo de enteros

g++ ActividadProgramacion11_1.cpp -o app
*/

#include <iostream>
#include <iomanip>
#include <random>
#include <ctime>

using namespace std;

// size_t puede guardar la cantidad maxima y teorica posible de un objeto de cualquier tipo, incluyendo un arreglo .
void generarArregloAleatorio(int *arreglo, size_t tamanio){
    for (size_t i = 0; i < tamanio; i++) {
        arreglo[i] = rand() % 100; // Numeros entre 0 y 99
    }
}

int contarPares(const int *arreglo, size_t tamanio){
    size_t count = 0;
    for(int i = 0; i < tamanio; i++){
        if(arreglo[i] % 2 == 0){
            count++;
        }
    }
    return count;
}

int main(){
    const size_t tamanio = 1000000000;
    int* arreglo = new int[tamanio];
    double timeElapsed;
    int start, end;

    generarArregloAleatorio(arreglo, tamanio);

    clock_t inicio = clock();
    size_t numPares = contarPares(arreglo, tamanio);
    clock_t fin = clock();

    double tiempoSecuencial = double(fin - inicio) / CLOCKS_PER_SEC;
    cout << "Número de pares: " << numPares << endl;
    cout << "Tiempo secuencial: " << tiempoSecuencial << " segundos" << endl;

    delete [] arreglo;

    return 0;
}

