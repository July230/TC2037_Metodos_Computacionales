#include <iostream>
#include <iomanip>
#include <pthread.h> // Libreria para hilos

using namespace std;

void* task(void* param) {
    int limit = *((int *) param); // La tarea a asignar un hilo recibe un limite con el cual trabajar

    cout << "tid = " << pthread_self() << "\n";
    for (int i = 0; i < limit; i++) {
        cout << i << " ";
    }
    cout << "\n";
    return 0; // pthread_exit(0);
}
 
int main(int argc, char* argv[]){
    pthread_t tid; // crear un hilo
    int limit = 100;

    // identificador del hilo, atributos, nombre de la tarea, informacion que requiere la tarea
    pthread_create(&tid, NULL, task, &limit); 

    // Esperar un hilo
    // Hilo al que esperar
    pthread_join(tid, NULL);

    return 0;
}

// g++ example2.cpp -o app -pthread