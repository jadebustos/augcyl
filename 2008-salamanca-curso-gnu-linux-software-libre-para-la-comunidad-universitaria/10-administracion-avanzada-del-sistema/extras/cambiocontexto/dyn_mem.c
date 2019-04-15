#include <stdlib.h>

#include "dyn_mem.h"

/* funcion que crea una matrix rows x columns */
int **matrix_dyn_mem(int rows, int columns) { /* inicio matrix_dyn_mem */

  int i = 0,
      **ptres;

  /* asignacion dinamica de memoria */
  ptres = (int **)calloc(rows, sizeof(int *));
  for(i=0;i<rows;i++) {
    ptres[i] = (int *)calloc(columns, sizeof(int));
  }

  return ptres;

} /* final matrix_dyn_mem */


/* funcion que libera el espacio reservado para una matrix */
void free_matrix(int **matrix, int rows) { /* begin function_free_matrix */

  int i = 0;

  for(i=0;i<rows;i++)
    free(matrix[i]);

  free(matrix);

  return;
} /* end function free_matrix */
