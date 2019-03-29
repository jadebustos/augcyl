#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

#include "datos.h"
#include "dyn_mem.h"
#include "my_rand.h"
#include "matrix.h"
#include "threads.h"

int main (void) { /* inicio funcion main */

  int **matrizA,
      **matrizB,
      **matrizC,
      i, j, 
      num;

  thread_data *ptdatos;

  pthread_t hilo[ORDER*ORDER];

  struct tm *inicio, *final;
  time_t hora_inicio, hora_final;

  /* hora de inicio */
  time(&hora_inicio);
  inicio = localtime(&hora_inicio);

  /* inicializamos el generador de numeros aleatorios */
  srand( (unsigned int)time( NULL ) );

  /* reservamos la memoria para las matrices */
  matrizA = matrix_dyn_mem(ORDER, ORDER);
  matrizB = matrix_dyn_mem(ORDER, ORDER);
  matrizC = matrix_dyn_mem(ORDER, ORDER);

  /* reservamos memoria para los datos de los hilos */
  ptdatos = (thread_data *)calloc(ORDER*ORDER, sizeof(thread_data));

  /* comprobacion de memoria */

  if  ( matrizA == NULL || matrizB == NULL || matrizC == NULL || ptdatos == NULL ) {
    printf("Hubo un error en la asignacion de memoria.\n");
    exit(1);
  }

  /* realizamos varias veces el proceso */

  for(num=0;num<EJECUCIONES;num++) { /* inicio primer for */
    int k = 0;
    /* inicializamos las dos matrices con valores aleatorios */
    /* implementarlo mediante hilos */
    initialize_random_matrix(matrizA, ORDER, ORDER, MAX_NUMBER);
    initialize_random_matrix(matrizB, ORDER, ORDER, MAX_NUMBER);

    /* multiplicacion de matrices */
    for(i=0;i<ORDER;i++) {  /*inicio segundo for for */
      for(j=0;j<ORDER;j++) {  /* inicio tercer for */
        /* data for threads */
        ptdatos[k].row = i;
        ptdatos[k].column = j;
        ptdatos[k].id = k; 
	ptdatos[k].a = matrizA;
	ptdatos[k].b = matrizB;
	ptdatos[k].c = matrizC; 
        pthread_create(&hilo[k], NULL, (void *) &mult_matrix_threaded, (void *)(ptdatos+k)); 
        ++k;
      } /* final tercer for */
    } /* final segundo for */

    /* esperamos a que terminen los hilos */
    for(i=0;i<ORDER*ORDER;i++) 
      pthread_join(hilo[i], NULL);  

  } /* final primer for */

  /* liberamos el espacio reservado */

  free_matrix(matrizA, ORDER);
  free_matrix(matrizB, ORDER);
  free_matrix(matrizC, ORDER);
  free(ptdatos);

  /* hora final */
  time(&hora_final);
  final = localtime(&hora_final);
  printf("Tiempo de ejecucion: %d segundos\n", hora_final-hora_inicio);

  return 0;

} /* final funcion main */
