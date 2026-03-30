/*
Ian Julián Estrada Castro - A01352823
Ejercicio de programación 11
Desarrollar una solución secuencial (sin hilos) y una paralela para el problema
g++ ActividadProgramacion11_2.cpp -o app

Calcular la aproximación de Pi usando la serie de Gregory-Leibniz. El valor de n debe ser 1x107 (10,000,000)
*/

#include <iostream>
#include <iomanip>
#include <random>
#include <ctime>

using namespace std;

double digitosPI(int n){
    double pi = 0.0;
    for (int i = 0; i < n; i++) {
        pi += pow(-1, i) / (2 * i + 1);
    }
    pi *= 4;

    return pi;
}

int main(){
    const int n = 10000000;
    double timeElapsed;
    int start, end;

    clock_t inicio = clock();
    double PI = digitosPI(n);
    clock_t fin = clock();

    double tiempoSecuencial = double(fin - inicio) / CLOCKS_PER_SEC;
    cout << "PI: " << PI << endl;
    cout << "Tiempo secuencial: " << tiempoSecuencial << " segundos" << endl;

    return 0;
}
