#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define TAM (1024*1024)

int main(int argc, char *argv[])
{
	FILE *f;
	char * p = "Practica del Curso de Administracion 2007 Salamanca\n";
	char * ext = ".conf";
	char * name = (char*) malloc(256 * sizeof(char));
	int backg = 0;
	int mult = 1;

	//printf("%c\n", argv[0][strlen(argv[0])-1]); 
	if (argv[0][strlen(argv[0])-1]=='2') 
		mult = 10;
	else if (argv[0][strlen(argv[0])-1]=='3') 
		mult = 100;

	strcpy(name, argv[0]);
	strcat(name, ext);
	//printf("%s\n",name);
	if ( ( f = fopen ( name, "a+")) == NULL ) {
		perror(argv[0]);
		exit(1);
	}
	int i = 0;

	//printf("%d\n",argc);
	if ((argc > 1) && (!strcmp(argv[1],"-b"))) 
	   backg = 1;
	//printf("%d\n",backg);
	//intf("[%s]\n",argv[1]);
	do {
		for (i = 0; i < ((TAM / strlen(p))*mult);i++) {
			if (EOF == fputs ( p, f )) {
				perror(argv[0]);
				exit(1);
			}
		}
		if (backg == 1) sleep(6);
	} while (backg == 1);
	if ( fclose(f) != 0 ) {
		perror(argv[0]);
		exit(1);
	} else
		exit(0);
}


