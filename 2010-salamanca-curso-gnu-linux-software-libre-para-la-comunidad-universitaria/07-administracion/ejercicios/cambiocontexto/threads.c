#include <stdio.h>

#include "datos.h"
#include "threads.h"

/* funcion que multiplica la fila de una matriz por la columna de otra */
void mult_matrix_threaded( thread_data *ptdatos ) {

   int i,
       res = 0;

   for(i=0;i<ORDER;i++) {

     res += ((ptdatos->a)[ptdatos->row][i]) * ((ptdatos->b)[i][ptdatos->column]); 
   }

   (ptdatos->c)[ptdatos->row][ptdatos->column] = res;

   pthread_exit(0);
}
