#ifndef _DYN_MEM
  #define _DYN_MEM

  /* funcion que crea una matrix rows x columns */
  int **matrix_dyn_mem(int rows, int columns);

  /* funcion que libera el espacio reservado para una matrix */
  void free_matrix(int **matrix, int rows);

#endif
