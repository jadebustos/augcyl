#include <stdio.h>
#include <locale.h>
#include <ctype.h>
#include <time.h>

int main() {
  /*
   * Para probar: ejecutar ./a.out, mostrar� "verdad"
   * ejecutar luego (unset LANG ; ./a.out), mostrar� "falso"
   */
  setlocale(LC_ALL,"");
  printf("%s\n",isalpha('�')?"verdad":"falso");
  return 0;
}
