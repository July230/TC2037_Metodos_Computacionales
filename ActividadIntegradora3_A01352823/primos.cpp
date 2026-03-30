/*
Ian Julián Estrada Castro - A01352823
Actividad Integradora 3 - Programación paralela

Utilizando hilos en C/C++ y CUDA, escribe las versiones de un programa que calcule la suma de 
todos los números primos menores a 5,000,000 (cinco millones)

Este archivo corresponde a la solución secuencial (con un sólo hilo)

g++ primos.cpp -o app
*/


#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <ctime>
#include <cmath>
#include <chrono>

using namespace std;
using namespace std::chrono;

#define SIZE 5000000 // 5e6
#define N 10

// Generar un arreglo con los numeros del 1 al 5000000 (cinco millones)
// Complejidad O(n)
// n es el numero de localidades
void generarNumeros(int *arreglo){
    for(long long i = 0; i < SIZE; i++){
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
    for(int i = 2; i <= sqrt(numero); i++){
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
long long sumarPrimos(int *arreglo){
    long long suma = 0;
    for(long long i = 0; i < SIZE; i++){
        if(esPrimo(arreglo[i])){
            suma += arreglo[i];
        }
    }
    return suma;
}

int main(){
    int* arreglo = new int[SIZE];

    // Elong long para trabajar con numeros grandes
    long long total, suma, cantidad;
    high_resolution_clock::time_point start, end;
    double timeElapsed;

    generarNumeros(arreglo);
    cantidad = contarPrimos(arreglo);

    for(int j = 0; j < N; j++){
        start = high_resolution_clock::now();

        suma = sumarPrimos(arreglo);

        end = high_resolution_clock::now();

        // Calcular el tiempo promedio
        timeElapsed += duration<double, std::milli>(end - start).count();
    }

    cout << "Último elemento = " << arreglo[4999999] << endl;

    cout << "Cantidad de números primos = " << cantidad << endl;

    cout << "Suma de los números primos = " << suma << endl;

    cout << "avg time = " << fixed << setprecision(3) << (timeElapsed/N) << " ms\n";

    delete [] arreglo;
    return 0;
}
