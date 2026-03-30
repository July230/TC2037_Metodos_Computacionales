#include <iostream>
#include <iomanip>
#include <cmath>
#include <pthread.h> 

using namespace std;

#define THREADS 2

void* task1(void* param) {

    cout << "tid = " << pthread_self() << " Empieza raiz \n";
    for (int i = 1; i <= 10; i++) {
        cout << sqrt(i) << " ";
    }
    cout << "\n";
    cout << "tid = " << pthread_self() << " Termina raiz \n";
    return 0; // pthread_exit(0);
}

void* task2(void* param) {

    cout << "tid = " << pthread_self() << " Empieza cuadrado \n";
    for (int i = 1; i <= 10; i++) {
        cout << i*i << " ";
    }
    cout << "\n";
    cout << "tid = " << pthread_self() << " Termina cuadrado \n";
    return 0; // pthread_exit(0);
}

int main(int argc, char* argv[]){
    pthread_t tids[THREADS];

    // Crear un hilo
    pthread_create(&tids[0], NULL, task1, NULL);
    pthread_join(tids[0], NULL);
    
    pthread_create(&tids[1], NULL, task2, NULL);
    pthread_join(tids[1], NULL);


    return 0;
}

// g++ ActividadProgramacion10_A01352823.cpp -o actividad -pthread