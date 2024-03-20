#include <stdio.h>
#include "parser.tab.h"
#include "lex.yy.c"
extern node*tree;



int main(void){

    yyparse();
    print_it(tree);

    return 0;
}