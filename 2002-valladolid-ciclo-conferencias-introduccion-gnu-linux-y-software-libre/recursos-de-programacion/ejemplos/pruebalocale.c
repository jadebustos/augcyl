#include <stdio.h>
#include <locale.h>
#include <ctype.h>
#include <time.h>

int main() {
  /*
   * Para probar: ejecutar ./a.out, mostrará "verdad"
   * ejecutar luego (unset LANG ; ./a.out), mostrará "falso"
   */
  setlocale(LC_ALL,"");
  printf("%s\n",isalpha('ñ')?"verdad":"falso");
  return 0;
}
