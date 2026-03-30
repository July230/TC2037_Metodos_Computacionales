#include <iostream>
#include <iomanip>
#include <pthread.h> // Libreria para hilos

using namespace std;

#define THREADS 4 // Limite para la cantidad de hilos, extreme cuidado con la cantidad de hilos

void* task(void* param) {
    int limit = *((int *) param); // La tarea a asignar un hilo recibe un limite con el cual trabajar

    cout << "tid = " << pthread_self() << "has started\n";
    for (int i = 0; i < limit; i++) {
        cout << i << " ";
    }
    cout << "\n";
    cout << "tid = " << pthread_self() << "has ended\n";
    return 0; // pthread_exit(0);
}
 
int main(int argc, char* argv[]){
    pthread_t tids[THREADS]; // crear un hilo
    int limit = 100;

    // Ahora se crearan hilos hasta el limite definido
    for (int i = 0; 1 < THREADS; i++){
        pthread_create(&tids[i], NULL, task, &limit);
    }

    for (int i = 0; 1 < THREADS; i++){
        pthread_join(tids[i], NULL);
    }

    return 0;
}

// g++ example3.cpp -o app -pthread