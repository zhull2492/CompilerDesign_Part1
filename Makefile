CC = gcc

all: connectfour

connectfour.o: connectfour.cpp
	$(CC) -c connectfour.cpp

connectfour: connectfour.o splashscreen.o gameplay.o
	$(CC) -o connectfour connectfour.o splashscreen.o gameplay.o

splashscreen.o: splashscreen.h splashscreen.cpp
	$(CC) -c splashscreen.cpp

gameplay.o: gameplay.h gameplay.cpp
	$(CC) -c gameplay.cpp

clean:
	$(RM) connectfour *.o *~
