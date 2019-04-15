#include "matrix.h"
#include "my_rand.h"

/* funcion que inicializa una matriz con numeros aleatorios entre 0 y max-1 */
void initialize_random_matrix(int **matrix, int rows, int columns, int max) { /* begin function initialize_random_matrix */

  int i, j;

  for(i=0;i<rows;i++) { /* begin first for */
    for(j=0;j<columns;j++) { /* begin second for */
      matrix[i][j] = generate_random_int(max); 
    } /* end second for */
  } /* end first for */

  return;
} /* end function initialize_random_matrix */

/* funcion que multiplica dos matrices */
void matrix_mul(int **a, int **b, int **res, int rows_a, int cols_b, int common) { /* begin function matrix_mul */

  int i, j, k,
      res_ij = 0;

  for(i=0;i<rows_a;i++) { /* begin first for */
    res_ij = 0;
    for(j=0;j<cols_b;j++) { /* begin second for */
      for(k=0;k<common;k++) { /* begin third for */
        res_ij += a[i][k]*b[k][j];
      } /* end third for */
      res[i][j] = res_ij;
    } /* end second for */
  } /* end first for */

  return;

} /* end function matrix_mul */
