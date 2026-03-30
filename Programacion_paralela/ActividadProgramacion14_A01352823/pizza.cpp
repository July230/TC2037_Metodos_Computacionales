/**
 *Explicacion. 
 * 
 * Cada estudiante intenta comer una rebanada de
 * pizza en un bucle continuo. Si no hay 
 * rebanadas disponibles, el estudiante notifica
 * y espera hasta que llegue una nueva pizza. 
 * Un hilo separado simula la entrega de pizza, 
 * reponiendo la pizza con 8 rebanadas cuando 
 * los estudiantes se quedan sin ellas. Se bloquea
 * la pizza mientras los estudiantes comen y si 
 * un estudiante ve que no hay pizza entonces llaman
 * por una senal al uber para que les traiga mas 
 * (que es otro hilo) una vez que el uber da la
 * senal de que la pizza se ha entregado entonces
 * se va y los esgtudiantes paran su trabajo para comer
 * 
 * 
 * 
**/


#include <iostream>
#include <unistd.h>
#include <pthread.h>
#include <cstdlib>
#include <ctime>
#include <sys/time.h>

using namespace std;

const int NUM_STUDENTS = 10;
const int SLICES_PER_PIZZA = 8;
bool pizzaRequested = false;


int pizzaSlices = SLICES_PER_PIZZA;
pthread_mutex_t pizzaLock;
pthread_mutex_t noPizza;  //mutex
pthread_cond_t pizzaArrived;

void* student(void* param) {
    int id = (int)param;

    while (true) {
        pthread_mutex_lock(&pizzaLock);
        
        //Avisa que no hay pizza
        while (pizzaSlices == 0) {
            cout << "Estudiante " << id << " EY no hay pizza. Ahorita llamo\n";
            pthread_mutex_unlock(&noPizza);  //unlock
            
            pthread_cond_wait(&pizzaArrived, &pizzaLock);  
        }
        
        //Come pIzza
        pizzaSlices--;
        cout << "Estudiante " << id << " esta comiendo pizza " << pizzaSlices << endl;
        
        pthread_mutex_unlock(&pizzaLock);
        
        sleep(3);
    }
    pthread_exit(0);
}

void* pizzaDelivery(void* param) {
    while (true) {
        pthread_mutex_lock(&noPizza); //lock nopizza
        pthread_mutex_lock(&pizzaLock); //lock nopizza
        sleep(2);
        
        pizzaSlices = SLICES_PER_PIZZA;
        cout << "Soy el uber y ya llego tu pizza con  " << pizzaSlices << "rebanadas"<< endl;
        
        pthread_cond_signal(&pizzaArrived);
        
        pthread_mutex_unlock(&pizzaLock);
    }
    pthread_exit(0);
}

int main(int argc, char* argv[]) {
    pthread_t studentTids[NUM_STUDENTS];
    pthread_t pizzaTid;
    int ids[NUM_STUDENTS];

    pthread_mutex_init(&pizzaLock, NULL);
    pthread_mutex_init(&noPizza, NULL);
    pthread_cond_init(&pizzaArrived, NULL);

    for (int i = 0; i < NUM_STUDENTS; i++) {
        ids[i] = i;
        pthread_create(&studentTids[i], NULL, student, &ids[i]);
    }

    pthread_create(&pizzaTid, NULL, pizzaDelivery, NULL);

    for (int i = 0; i < NUM_STUDENTS; i++) {
        pthread_join(studentTids[i], NULL);
    }

    pthread_join(pizzaTid, NULL);

    pthread_mutex_destroy(&pizzaLock);
    pthread_mutex_destroy(&noPizza);
    pthread_cond_destroy(&pizzaArrived);

    return 0;
}