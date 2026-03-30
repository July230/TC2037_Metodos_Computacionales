#include <iostream>
#include <iomanip>
#include <pthread.h> // Libreria para hilos

using namespace std;

void* task(void* param) {
    for (int i = 0; i < 10; i++) {
        cout << i << " ";
    }
    cout << "\n";
    return 0; // pthread_exit(0);
}
 
int main(int argc, char* argv[]){
    pthread_t tid; // crear un hilo

    // identificador del hilo, atributos, nombre de la tarea, informacion que requiere la tarea
    pthread_create(&tid, NULL, task, NULL);

    // Esperar un hilo
    // Hilo al que esperar
    pthread_join(tid, NULL);

    return 0;
}

// g++ example1.cpp -o app -pthread