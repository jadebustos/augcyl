CC=gcc
LIBRARY=-lpthread

matrix.o:
	$(CC) -c matrix.c

my_rand.o:
	$(CC) -c my_rand.c

dyn_mem.o:
	$(CC) -c dyn_mem.c

metodo-secuencial: matrix.o my_rand.o dyn_mem.o
	$(CC) metodo-secuencial.c matrix.o my_rand.o dyn_mem.o -o metodo-secuencial

metodo-multihilo: threads.o matrix.o my_rand.o dyn_mem.o
	$(CC) metodo-multihilo.c threads.o matrix.o my_rand.o dyn_mem.o -o metodo-multihilo $(LIBRARY)

clean:
	rm -f *.o

all:
	make metodo-secuencial
	make metodo-multihilo
	make clean
