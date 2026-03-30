#include <iostream>
#include <iomanip>
#include <pthread.h> // Libreria para hilos

using namespace std;

#define THREADS 4 // Limite para la cantidad de hilos, extreme cuidado con la cantidad de hilos

// Definir una estructura
typedef struct {
    int id, start, end;
} Block; // Alias de la estructura

void* task(void* param) {
    Block *block = (Block*) param;

    cout << "tid = " << block->id << "has started\n";
    for (int i = block->start; i < block->end; i++) {
        //cout << i << " ";
    }
    //cout << "\n";
    cout << "tid = " << block->id << "has ended\n";
    return 0; // pthread_exit(0);
}
 
int main(int argc, char* argv[]){
    pthread_t tids[THREADS]; // crear un hilo
    Block blocks[THREADS]; 

    // Ahora se crearan hilos hasta el limite definido
    for (int i = 0; 1 < THREADS; i++){
        blocks[i].id = i;
        blocks[i].start = i * 10;
        blocks[i].end = (i + 1) * 10;
        pthread_create(&tids[i], NULL, task, &blocks[i]);
    }

    for (int i = 0; 1 < THREADS; i++){
        pthread_join(tids[i], NULL);
    }

    return 0;
}

// g++ example4.cpp -o app -pthread