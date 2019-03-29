#ifndef _MATRIX
  #define _MATRIX

  /* funcion que inicializa una matriz con numeros aleatorios entre 0 y max-1 */
  void initialize_random_matrix(int **matrix, int rows, int columns, int max);

  /* funcion que multiplica dos matrices */
  void matrix_mul(int **a, int **b, int **res, int rows_a, int cols_b, int common);
#endif
