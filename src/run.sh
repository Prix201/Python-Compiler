bison -d parser.y
flex scanner.l
g++ deleting_trailing_spaces.cpp
./a.out
gcc lex.yy.c parser.tab.h
./a.out < input.txt
dot -Tpdf output.dot -o output.pdf
