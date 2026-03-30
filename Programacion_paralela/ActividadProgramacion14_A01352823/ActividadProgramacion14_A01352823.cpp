/*
Ian Julián Estrada Castro - A01352823
Un grupo de estudiantes está desarrollando una actividad integradoras de la materia TC2037. 
Los estudiantes solo pueden programar mientras comen pizza.


g++ ActividadProgramacion14_A01352823.cpp -o app -pthread


Lo que hacemos en este programa es declarar el número de rebanadas de pizza y estudiantes. 
Iniciamos RequestPizza como falso, lo que asegura que los estudiantes comen hasta que la pizza se acaba.
Sólo un estudiante puede comer una rebanada de pizza a la vez, esto sucede indefinidamente hasta que no hay pizza,
lo que ocurre cuando el contador de rebanadas es 0. Cuando esto sucede, el primer estudiante (hilo) que descubre que no hay pizza
marca la necesidad de pedir más pizza y notifica al hilo encargado de la entrega de la pizza "All Night Long". 
El hilo encargado de la entrega repone las rebanadas al total máximo inicial después de un tiempo que simula la entrega. 
Mientras tanto, los demás estudiantes que ven que no hay pizza esperan (duermen) hasta que llegue la pizza. 
Se utilizan mutex y variables de condición para asegurar que sólo un hilo pueda modificar el número de rebanadas a la vez 
y para coordinar la espera y la nitificación de la llegada de nuevas pizzas.
*/

#include <iostream>
#include <iomanip>
#include <unistd.h>
#include <pthread.h>
#include <cstdlib>
#include <ctime>
#include <sys/time.h>
#include <cstdint> // para usar intptr_t

using namespace std;

// Aquí, los estudiantes juegan el rol de los hilos
const int MAX_PIZZA_SLICES = 8;
const int STUDENTS = 10;
bool RequestPizza = false;

int rebanadas = MAX_PIZZA_SLICES;

// Proteger secciones donde se accede a rebanadas y RequestPizza
pthread_mutex_t NoHayPizza;

// Variable de condición para sincronizar los hilos que esperan por la pizza
pthread_cond_t llamarPizza;

void* comerPizza(void* param){

    // Se usa intptr_t para no perder datos en sistemas de 64 bits cuando el entero es de 32 bits
    intptr_t id = (intptr_t) param;

    while(true){

        // Bloquear NoHayPizza, sólo un hilo tiene acceso
        pthread_mutex_lock(&NoHayPizza);

        // Cuando ya no haya rebanadas
        while(rebanadas == 0){ 

            // Verificar si se ha pedido pizza
            if(!RequestPizza){

                // Si entra, se pide pizza
                RequestPizza = true;
                
                cout << "Soy " << id << ", se acabó la pizza, voy a pedir a All Night Long" << endl;

                // Desbloquear el candado de no hay pizza y pedir la pizza
                pthread_cond_signal(&llamarPizza); 
            } else {
                cout << "Soy " << id << ", no hay pizza, esperaré a que llegue..." << endl;

                // Si la pizza ya fue solicitada, esperar con cond_wait
                pthread_cond_wait(&llamarPizza, &NoHayPizza);
            }


        }

        // Por cada iteración, rebanadas se reduce una unidad
        rebanadas--; 

        cout << "Soy " << id << "Y estoy comiendo pizza. Quedan " << rebanadas << " rebanadas." << endl; 

        // Desbloquear NoHayPizza después de actualizar las rebanadas, ahora los estudiantes pueden comer
        pthread_mutex_unlock(&NoHayPizza);

        // Esperar tres segundos por cada iteracion
        sleep(3);

    }
    
    // Finalizar el hilo del estudiante cuando la operación termina
    // Aunque en este caso, el bucle es infinito
    pthread_exit(0);
}

void* entregarPizza(void* param){
    while(true){

        // Esperar a que alguien llama para pedir pizza
        pthread_mutex_lock(&NoHayPizza);
        while(!RequestPizza){
            pthread_cond_wait(&llamarPizza, &NoHayPizza);    
        }

        sleep(2);

        // Reponer la cantidad máxima de rebanadas
        rebanadas = MAX_PIZZA_SLICES;

        // Restablecer request a falso
        RequestPizza = false;
        cout << "Ya llegó la pizza, ahora hay " << rebanadas << " rebanadas" << endl;

        // Ahora los demás hilos pueden continuar, despertar a los estudiantes que esperan pizza
        pthread_cond_broadcast(&llamarPizza);

        // Ahora los estudiantes pueden comer
        pthread_mutex_unlock(&NoHayPizza);
    }
    pthread_exit(0);
}

int main(int argc, char* argv[]){

    // Hilos para los estudiantes y uno para la entrega de la pizza
    pthread_t IDEstudiantes [STUDENTS];
    pthread_t IDPizza;
    int id [STUDENTS];

    // Iniciar mutex y condición
    pthread_mutex_init(&NoHayPizza, NULL);
    pthread_cond_init(&llamarPizza, NULL);

    for(int i = 0; i < STUDENTS; i++){
        id[i] = i;
        pthread_create(&IDEstudiantes[i], NULL, comerPizza, &id[i]);
    }

    pthread_create(&IDPizza, NULL, entregarPizza, NULL);

    // Esperar a que todos los estudiantes coman o duerman
    for(int i = 0; i < STUDENTS; i++){
        pthread_join(IDEstudiantes[i], NULL);
    }

    // Esperar a que el hilo de entrega termine
    pthread_join(IDPizza, NULL);

    // Liberar memoria, se destruye el mutex y la condición
    pthread_mutex_destroy(&NoHayPizza);
    pthread_cond_destroy(&llamarPizza);

    return 0;

}