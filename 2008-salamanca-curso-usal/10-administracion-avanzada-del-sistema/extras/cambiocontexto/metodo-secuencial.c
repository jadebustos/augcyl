#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "datos.h"
#include "dyn_mem.h"
#include "my_rand.h"
#include "matrix.h"

int main (void) { /* inicio funcion main */

  int **matrizA,
      **matrizB,
      **matrizC,
      i, j;

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

  /* comprobacion de memoria */

  if  ( matrizA == NULL || matrizB == NULL || matrizC == NULL ) {
    printf("Hubo un error en la asignacion de memoria.\n");
    exit(1);
  }

  /* realizamos el proceso unas cuantas veces */

  for(i=0;i<EJECUCIONES;i++) {
    /* inicializamos las dos matrices con valores aleatorios */
    initialize_random_matrix(matrizA, ORDER, ORDER, MAX_NUMBER);
    initialize_random_matrix(matrizB, ORDER, ORDER, MAX_NUMBER);

    /* multiplicamos las matrices */
    matrix_mul(matrizA, matrizB, matrizC, ORDER, ORDER, ORDER);
  }

  /* liberamos el espacio reservado */

  free_matrix(matrizA, ORDER);
  free_matrix(matrizB, ORDER);
  free_matrix(matrizC, ORDER);

  /* hora final */
  time(&hora_final);
  final = localtime(&hora_final);
  printf("Tiempo de ejecucion: %d segundos\n", hora_final-hora_inicio);

return 0;

} /* final funcion main */
