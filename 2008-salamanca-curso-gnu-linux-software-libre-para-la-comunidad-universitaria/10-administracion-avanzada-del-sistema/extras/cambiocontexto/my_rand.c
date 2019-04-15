#include <stdlib.h>

#include "my_rand.h"

/* funcion que genera numeros aleatorios entre 0 y max -1 */

int generate_random_int(int max) { /* begin function generate_random_int */

  int number = 0,
      positive = 0;

  /* generamos el numero aleatorio */
  number = rand() % max;
  positive = rand() %2;

  if ( positive == 0 ) {
    return ((-1)*number);
  }

  return number;

} /* end function generate_random_int */

