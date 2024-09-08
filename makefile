BFLAGS = -d -t -v
B = bison
F = flex
CC = gcc



make : bison.o flexer.o final.o

bison.o : bison.y
	$(B) $(BFLAGS) $? 

flexer.o : flexer.l
	$(F) $? 

final.o : lex.yy.c bison.tab.c
	$(CC) $? -o parser -lfl

all: clean lex.yy.c bison.tab.c bison.tab.h parser bison.output
