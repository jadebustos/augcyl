#ifndef _THREADS
  #define _THREADS
  #include "datos.h"

  typedef struct {
     int id,
         row,
         column;

     int **a,
         **b,
         **c;

  } thread_data;

  /* funcion que multiplica la fila de una matriz por la columna de otra */
  void mult_matrix_threaded( thread_data *ptdatos );

#endif
