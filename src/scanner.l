%option yylineno
%{  
    #include<stdio.h>
    #include<stdlib.h>
    #include "parser.tab.c"

    


    typedef struct stack{
        int array[1000];
        int r;
    }stack;

    void push(stack*temp,int num){temp->array[++temp->r] = num;}
    void pop(stack*temp){temp->r--;}
    int top(stack*temp){return temp->array[temp->r];}
    int size(stack*temp){return temp->r;}


    void do_it(char*str){
        
        node*temp = create_new_node(str,yytext);
        yylval.head = temp;
    }

    stack*indent;
    int a = 0;
    int dedent = 0;
    int newline = 0;
    int ind = 0;
%}





%%
 if(dedent || newline || ind){
    if(newline){newline--;return NEWLINE;}
    if(dedent){dedent--;return DEDENT;}
    if(ind){ind--;return INDENT;}

 }

"." {return FULLSTOP;}

^[\t ]* {
    
    int curr_indent = 0;
    int i = yyleng-1;
    while(yytext[i] == ' ' || yytext[i] == '\t'){curr_indent++;i--;}
    if(a==0){
        indent = (stack*)malloc(sizeof(stack));
        indent->r = 0;
        push(indent,curr_indent);
        a = 1; 
    }
    // printf("\n%d\n",top(indent));
}

[ \t] {}
[ \n\t]*[#][^\n]* {}



[\n][\n]*[ \t]* {
    newline++;
    if(a == 0){
        indent = (stack*)malloc(sizeof(stack));
        indent->r = 1;
        indent->array[0] = 0;
        a = 1;
    }

    int curr_indent = 0;
    int i = yyleng-1;
    while(yytext[i] == ' ' || yytext[i] == '\t'){curr_indent++;i--;}


    if(top(indent) > curr_indent){
        while(size(indent) != 1 && curr_indent < top(indent)){pop(indent);dedent++;}

        if(curr_indent != top(indent)){printf("\nIn line : %d \nIndentationError: unindent does not match any outer indentation level\n",yylineno);exit(1);}
    }else if(top(indent) < curr_indent){
        push(indent,curr_indent);
        ind++;
    }

    // printf("\n%d\n",top(indent));

    if(newline){newline--;return NEWLINE;}

}


[\n]* {return NEWLINE;}




[0-9][0-9_]* {do_it("INT");return INT;}
[0][bB][0-1][0-1_]* {do_it("INT");return INT;}
[0][oO][0-7][0-7_]* {do_it("INT");return INT;}
[0][xX][0-9a-fA-F][0-9_a-fA-F]* {do_it("INT");return INT;}

[0-9][0-9_]*[.][0-9][0-9_]* {do_it("FLOAT");return FLOAT;}
[0-9][0-9_]*[.][0-9][0-9_]*[eE][+-][0-9_]* {do_it("FLOAT");return FLOAT;}

"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULTIPLY;}
"/" {return DIVIDE;}
"%" {return MODULO;}
"**" {return POW;}

"==" {return eq_rel;}
"!=" {return neq_rel;}
">" {return gt_rel;}
"<" {return lt_rel;}
">=" {return geq_rel;}
"<=" {return leq_rel;}
"and" {return and_token;}
"or" {return or_token;}
"not" {return not_token;}
"&" {return and_op;}
"|" {return or_op;}
"^" {return xor_op;}
"~" {return nor_op;}
"<<" {return lshift_op;}
">>" {return rshift_op;}

"=" {return equal;}
"+=" {return add_eq;}
"-=" {return minus_eq;}
"*=" {return mult_eq;}
"/=" {return div_eq;}
"%=" {return mod_eq;}
"**=" {return pow_eq;}
"&=" {return and_eq;}
"|=" {return random_eq;}
"^=" {return xor_eq;}
"<<=" {return lshift_eq;}
">>=" {return rshift_eq;}
"//" {return concat;}
"//=" {return concat_eq;}




"if" {return IF;}
"in" {return IN;}
"elif" {return ELIF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"break" {return BREAK;}
"continue" {return CONTINUE;}
"def" {return DEF;}
"class" {return CLASS;}
"__init__" {do_it("NAME");return NAME;}
"__main__" {do_it("NAME");return NAME;}
"__name__" {do_it("NAME");return NAME;}
"return" {return RETURN;}
"range"  {return RANGE;}

":" {return COLON;}
"(" {return OPEN_BRACKET;}
")" {return CLOSE_BRACKET;}
"," {return COMMA;}
"[" {return OPEN_SQUARE_BRACKET;}
"]" {return CLOSE_SQUARE_BRACKET;}
";" {return SEMI_COLON;}
"@" {return AT_THE_RATE;}
":=" {return COLON_EQ;}
"None" {return NONE;}
"True" {return TRUE_T;}
"Flase" {return FALSE_T;}
"->" {return GOTO;}
"float" {return FLOAT_NAME;}
"int" {return INT_NAME;}
"string" {return STRING_NAME;}

["][^"]*["] {//Correct String 
    do_it("STRING");return STRING;}
['][^']*['] {do_it("STRING");return STRING;}
["]["]["][^"]*["]["]["] {do_it("STRING");return STRING;}
['][']['][^']*['][']['] {do_it("STRING");return STRING;}
[rufRUF]["][^"]*["] {do_it("STRING");return STRING;}
[rufRUF]['][^']*['] {do_it("STRING");return STRING;}
[rufRUF]["]["]["][^"]*["]["]["] {do_it("STRING");return STRING;}
[rufRUF]['][']['][^']*['][']['] {do_it("STRING");return STRING;}
[Ff][Rr]["][^"]*["] {do_it("STRING");return STRING;}
[Ff][Rr]['][^']*['] {do_it("STRING");return STRING;}
[Ff][Rr]["]["]["][^"]*["]["]["] {do_it("STRING");return STRING;}
[Ff][Rr]['][']['][^']*['][']['] {do_it("STRING");return STRING;}

[a-zA-Z][a-zA-Z0-9_]* {do_it("NAME");return NAME;}

. {printf("\n>>%s<<fuck\n",yytext);}

%%


int yywrap(){
    return 1;
}
