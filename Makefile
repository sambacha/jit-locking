# Makefile

CFLAGS = -Wall -g 
LDFLAGS =
LDLIBS = 

run-with-lockfile: run-with-lockfile.c
	$(CC) $(CFLAGS) run-with-lockfile.c $(LFGLAGS) $(LDLIBS) -o run-with-lockfile

clean:
	rm -f rotatelogs *~ core
