%{  
    #include<stdio.h>
    #include<stdlib.h>

    extern char* yytext;
    extern int yylineno;

    int yylex ();
    void yyerror(const char *s);

%}

%code requires{
    #include "node.c"
    node*tree;
}
%union{
    char*lexeme;
    node*head;

}

%token <head> STRING INT FLOAT
%token <head> PLUS MINUS MULTIPLY DIVIDE MODULO POW
%token <head> eq_rel neq_rel gt_rel lt_rel geq_rel leq_rel and_token or_token not_token and_op or_op xor_op nor_op lshift_op rshift_op
%token <head> equal add_eq minus_eq mult_eq div_eq mod_eq pow_eq and_eq random_eq xor_eq lshift_eq rshift_eq
%token <head> IF ELIF ELSE FOR WHILE BREAK CONTINUE DEF CLASS
%token <head> INDENT DEDENT
%token <head>  NAME
%token <head>  RANGE

%token <head> COLON OPEN_BRACKET CLOSE_BRACKET COMMA OPEN_SQUARE_BRACKET CLOSE_SQUARE_BRACKET
%token <head> NEWLINE
%token <head> concat 
%token <head> IN 
%token <head> AT_THE_RATE
%token <head> RETURN
%token <head> FULLSTOP
%token <head> GOTO
%token <head> concat_eq
%token <head> INT_NAME FLOAT_NAME STRING_NAME
%token <head> SEMI_COLON COLON_EQ


%token <head> TRUE_T NONE FALSE_T

%left POW  AT_THE_RATE  DIVIDE  concat  MODULO PLUS MINUS lshift_eq rshift_op and_token xor_op or_op
%right not_token IF ELSE ELIF

%type<head>file  
%type<head>stmts 
%type<head>stmt  
%type<head>compound_stmt  
%type<head>simple_stmt  
%type<head>if_stmt 
%type<head>elif_stmts  
%type<head>else_stmt  
%type<head>while_stmt  
%type<head>for_stmt  
%type<head>rangelist
%type<head>funcdef 
%type<head>parameters
%type<head>typedarglist
%type<head>tfpdef
%type<head>classdef 
%type<head>expr_stmt 
%type<head>annassign
%type<head>augassign
%type<head>something 
%type<head>suite 
%type<head>flow_stmt 
%type<head>test
%type<head>or_test
%type<head>and_test 
%type<head>not_test
%type<head>comparison
%type<head>comp_op
%type<head>expr
%type<head>xor_expr
%type<head>and_expr
%type<head>shift_expr
%type<head>shift_op
%type<head>arith_expr
%type<head>add_minus 
%type<head>term
%type<head>ops 
%type<head>factor
%type<head>ops2 
%type<head>power
%type<head>atom_expr
%type<head>trailers
%type<head>atom
%type<head>trailer
%type<head>arglist
%type<head>arguments 
%type<head>argument
%type<head>subscriptlist
%type<head>testlist
%type<head>STRINGS
%type<head>OR
%type<head>AND




%start file

%%


file :          stmts                               {node*temp = create_new_node("BLOCK","");add_new_child(temp,$1);$$ = temp;tree = $$;}
|               %empty                              {tree = NULL;}

stmts :         stmts stmt                          {$$ = $1;add_new_child($$,$2);}
|               stmt                                {node*temp = create_new_node("SUITE","");add_new_child(temp,$1);$$ = temp;}

stmt :          compound_stmt                       {$$ = $1;}
|               simple_stmt                         {$$ = $1;}
|               NEWLINE                             {$$ = NULL;}

compound_stmt : if_stmt {printf("IF_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               while_stmt {printf("WHILE_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               for_stmt {printf("FOR_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               funcdef {printf("FUNC FORMED in line : %d\n",yylineno);$$ = $1;}
|               classdef {printf("CLASSS FORMED in line : %d\n",yylineno);$$ = $1;}

simple_stmt :   expr_stmt                                   {printf("EXPR_STMT FORMED in line : %d\n",yylineno);node*temp = create_new_node("EXPR_STMT","");add_new_child(temp,$1);$$ = $1;}
|               flow_stmt                                   {printf("FLOW_STMT FORMED in line : %d\n",yylineno);node*temp = create_new_node("FLOW_STMT","");add_new_child(temp,$1);$$ = $1;}

if_stmt :       IF test COLON suite elif_stmts else_stmt    {node*temp = create_new_node("IF_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);add_new_child(temp,$5);add_new_child(temp,$6);$$ = temp;}
|               IF test COLON suite else_stmt               {node*temp = create_new_node("IF_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);add_new_child(temp,$5);$$ = temp;}
|               IF test COLON suite elif_stmts              {node*temp = create_new_node("IF_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);add_new_child(temp,$5);$$ = temp;}
|               IF test COLON suite                         {node*temp = create_new_node("IF_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);$$ = temp;}

elif_stmts :    ELIF test COLON suite                       {node*temp = create_new_node("ELIF_STMTS","");node*temp2 = create_new_node("ELIF_STMT","");add_new_child(temp2,$2);add_new_child(temp2,$4);add_new_child(temp,temp2);$$ = temp;}
|               elif_stmts ELIF test COLON suite            {$$ = $1;node*temp = create_new_node("ELIF_STMT","");add_new_child(temp,$3);add_new_child(temp,$5);add_new_child($$,temp);}

else_stmt :     ELSE COLON suite                            {node*temp = create_new_node("ELSE_STMT","");add_new_child(temp,$3);$$ = temp;}


while_stmt :    WHILE test COLON suite else_stmt            {node*temp = create_new_node("WHILE_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);add_new_child(temp,$5);$$ = temp;}
|               WHILE test COLON suite                      {node*temp = create_new_node("WHILE_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);$$ = temp;}

for_stmt :      FOR NAME IN RANGE rangelist COLON suite     {node*temp = create_new_node("FOR_STMT","");add_new_child(temp,$1);add_new_child(temp,$5);add_new_child(temp,$6);add_new_child(temp,$7);$$ = temp;}


rangelist :     OPEN_BRACKET expr CLOSE_BRACKET                         {node*temp = create_new_node("RANGE_STMT","");add_new_child(temp,$2);$$ = temp;}
|               OPEN_BRACKET expr COMMA expr CLOSE_BRACKET              {node*temp = create_new_node("RANGE_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);$$ = temp;}
|               OPEN_BRACKET expr COMMA expr COMMA expr CLOSE_BRACKET   {node*temp = create_new_node("RANGE_STMT","");add_new_child(temp,$2);add_new_child(temp,$4);add_new_child(temp,$6);$$ = temp;}



funcdef :       DEF NAME parameters GOTO test COLON suite   {$$ = create_new_node("FUNCTION","");node*temp = create_new_node("->","");add_new_child($$,$2);add_new_child($$,$3);add_new_child($$,temp);add_new_child($$,$5);add_new_child($$,$7);}
|               DEF NAME parameters COLON suite             {node*temp = create_new_node("FUNCTION","");add_new_child(temp,$2);add_new_child(temp,$3);add_new_child(temp,$5);$$ = temp;}

parameters:     OPEN_BRACKET typedarglist CLOSE_BRACKET     {$$ = $2;}  
|               OPEN_BRACKET CLOSE_BRACKET                  {$$ = NULL;}

typedarglist:   tfpdef                                      {node*temp = create_new_node("PARAMETERS","");add_new_child(temp,$1);$$ = temp;} 
|               typedarglist COMMA tfpdef                   {$$ = $1;add_new_child($$,$3);}

tfpdef:         NAME                                        {$$ = $1;} 
|               NAME COLON test                             {node*temp = create_new_node(":","");add_new_child(temp,$1);add_new_child(temp,$3);$$ = temp;} 



classdef :      CLASS NAME parameters COLON suite           {node*temp = create_new_node("CLASS","");add_new_child(temp,$2);add_new_child(temp,$3);add_new_child(temp,$5);$$ = temp;}
|               CLASS NAME COLON suite                      {node*temp = create_new_node("CLASS","");add_new_child(temp,$2);add_new_child(temp,$4);$$ = temp;}

expr_stmt :     testlist                                    {$$ = $1;}
|               annassign                                   {$$ = $1;}
|               testlist augassign testlist                 {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}
|               testlist something                          {node*temp = create_new_node("=","");add_new_child(temp,$1);add_new_child(temp,$2);$$ = temp;}

something :     something equal testlist                     {node*temp = create_new_node("=","");add_new_child(temp,$1);add_new_child(temp,$3);$$ = temp;}
|               equal testlist                               {$$ = $2;}

annassign:      testlist COLON test                          {$$ = create_new_node(":","");add_new_child($$,$1);add_new_child($$,$3);}
|               testlist COLON test equal testlist                {$$ = create_new_node("=","");node*temp = create_new_node(":","");add_new_child(temp,$1);add_new_child(temp,$3);add_new_child($$,temp);add_new_child($$,$5);}

augassign:      add_eq                                      {node*temp = create_new_node("+=","");$$ = temp;}
|               minus_eq                                    {node*temp = create_new_node("-=","");$$ = temp;}
|               mult_eq                                     {node*temp = create_new_node("*=","");$$ = temp;}
|               div_eq                                      {node*temp = create_new_node("/=","");$$ = temp;}
|               mod_eq                                      {node*temp = create_new_node("%%=","");$$ = temp;}
|               and_eq                                      {node*temp = create_new_node("&=","");$$ = temp;}
|               xor_eq                                      {node*temp = create_new_node("^=","");$$ = temp;}
|               lshift_eq                                   {node*temp = create_new_node("<<=","");$$ = temp;}
|               rshift_eq                                   {node*temp = create_new_node(">>=","");$$ = temp;}
|               pow_eq                                      {node*temp = create_new_node("**=","");$$ = temp;}      
|               concat_eq                                   {node*temp = create_new_node("//=","");$$ = temp;} 
|               random_eq                                   {node*temp = create_new_node("|=","");$$ = temp;} 

suite :         NEWLINE INDENT stmts DEDENT                 {$$ = $3;}
|               simple_stmt                                 {$$ = $1;}

flow_stmt :     BREAK                                       {node*temp = create_new_node("BREAK_STMT","");$$ = temp;}    
|               CONTINUE                                    {node*temp = create_new_node("CONTINUE","");$$ = temp;}
|               RETURN                                      {node*temp = create_new_node("RETURN","");$$ = temp;}
|               RETURN testlist                                  {node*temp = create_new_node("RETURN","");add_new_child(temp,$2);$$ = temp;}

test:           or_test                                     {$$ = $1;}

or_test:        and_test                                    {$$ = $1;}
|               or_test OR and_test                         {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

OR :            or_token                                    {$$ = create_new_node("or","");}
AND:            and_token                                   {$$ = create_new_node("and","");}

and_test:       not_test                                    {$$ = $1;}
|               and_test AND not_test                       {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

not_test :      not_token not_test                          {node*temp = create_new_node("not","");add_new_child(temp,$2);$$ = temp;}
|               comparison                                  {$$ = $1;}


comparison :    expr                                        {$$ = $1;}
|               comparison comp_op expr                     {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

comp_op:        lt_rel                                      {node*temp = create_new_node("<","");$$ = temp;}
|               gt_rel                                      {node*temp = create_new_node(">","");$$ = temp;}
|               geq_rel                                     {node*temp = create_new_node(">=","");$$ = temp;}
|               leq_rel                                     {node*temp = create_new_node("<=","");$$ = temp;}    
|               eq_rel                                      {node*temp = create_new_node("==","");$$ = temp;}
|               neq_rel                                     {node*temp = create_new_node("!=","");$$ = temp;}
|               IN                                          {node*temp = create_new_node("in","");$$ = temp;}
|               not_token IN                                {node*temp = create_new_node("not in","");$$ = temp;}

expr:           xor_expr                                    {$$ = $1;}
|               expr or_op xor_expr                         {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

xor_expr:       and_expr                                    {$$ = $1;}
|               xor_expr xor_op and_expr                    {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

and_expr:       shift_expr                                  {$$ = $1;}         
|               and_expr and_op shift_expr                  {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}


shift_expr:     arith_expr                                  {$$ = $1;}
|               shift_expr shift_op arith_expr              {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}


shift_op :      lshift_op                                   {node*temp = create_new_node("<<","");$$=temp;}
|               rshift_op                                   {node*temp = create_new_node(">>","");$$=temp;}


arith_expr:     term                                        {$$ = $1;}
|               arith_expr add_minus term                   {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

add_minus :     PLUS                                        {node*temp = create_new_node("+","");$$=temp;}    
|               MINUS                                       {node*temp = create_new_node("-","");$$=temp;}

term:           factor                                      {$$ = $1;} 
|               term ops factor                             {$$ = $2;add_new_child($$,$1);add_new_child($$,$3);}

ops :           MULTIPLY                                    {node*temp = create_new_node("*","");$$=temp;}
|               POW                                         {node*temp = create_new_node("**","");$$=temp;}
|               DIVIDE                                      {node*temp = create_new_node("/","");$$=temp;}
|               MODULO                                      {node*temp = create_new_node("%%","");$$=temp;}
|               concat                                      {node*temp = create_new_node("//","");$$=temp;}

factor:         ops2 factor                                 {node*temp = create_new_node("SINGNED_FACTOR","");add_new_child(temp,$1);add_new_child(temp,$2);$$ = temp;}                                 
|               power                                       {$$ = $1;}
ops2 :          PLUS                                        {node*temp = create_new_node("+","");$$ = temp;}
|               MINUS                                       {node*temp = create_new_node("-","");$$ = temp;}
|               nor_op                                      {node*temp = create_new_node("~","");$$ = temp;}

power:          atom_expr                                   {$$ = $1;}
|               atom_expr power factor                      {node*temp = create_new_node($2->name,"");add_new_child(temp,$1);add_new_child(temp,$2);add_new_child(temp,$3);$$ = temp;}

atom_expr:      atom trailers                               {node*temp = create_new_node("ATOM_EXPR","");add_new_child(temp,$1);add_new_child(temp,$2);$$ = temp;}
|               atom                                        {$$ = $1;}

trailers :      trailers trailer                            {$$ = $1;add_new_child($$,$2);$$->type = 1;}
|               trailer                                     {node*temp = create_new_node("TRAILERS","");add_new_child(temp,$1);$$ = temp;$$->type = 1;}
                                

atom:           OPEN_BRACKET testlist CLOSE_BRACKET              {$$ = create_new_node("ATOM","");node*temp1 = create_new_node("(","");node*temp2 = create_new_node(")","");add_new_child($$,temp1);add_new_child($$,$2);add_new_child($$,temp2);}
|               OPEN_BRACKET CLOSE_BRACKET                  {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node("(","");node*temp2 = create_new_node(")","");add_new_child($$,temp1);add_new_child($$,temp2);}
|               OPEN_SQUARE_BRACKET testlist CLOSE_SQUARE_BRACKET   {$$ = create_new_node("ATOM","");node*temp1 = create_new_node("[","");node*temp2 = create_new_node("]","");add_new_child($$,temp1);add_new_child($$,$2);add_new_child($$,temp2);}
|               OPEN_SQUARE_BRACKET CLOSE_SQUARE_BRACKET   {$$ = create_new_node("ATOM","");node*temp1 = create_new_node("[","");node*temp2 = create_new_node("]","");add_new_child($$,temp1);add_new_child($$,temp2);}
|               NAME                                        {$$ = $1;}
|               INT                                         {$$ = $1;}
|               FLOAT                                       {$$ = $1;}
|               STRINGS                                     {$$ = $1;}
|               NONE                                        {node*temp = create_new_node("NONE","");$$ = temp;}
|               TRUE_T                                      {node*temp = create_new_node("TRUE","");$$ = temp;}
|               FALSE_T                                     {node*temp = create_new_node("FALSE","");$$ = temp;}
|               INT_NAME                                    {node*temp = create_new_node("int","");$$ = temp;}
|               FLOAT_NAME                                  {node*temp = create_new_node("float","");$$ = temp;}
|               STRING_NAME                                 {node*temp = create_new_node("string","");$$ = temp;}
|               not_token                                   {node*temp = create_new_node("not","");$$ = temp;}

trailer:        OPEN_BRACKET arglist CLOSE_BRACKET                      {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node("(","");node*temp2 = create_new_node(")","");add_new_child($$,temp1);add_new_child($$,$2);add_new_child($$,temp2);}
|               OPEN_BRACKET CLOSE_BRACKET                              {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node("(","");node*temp2 = create_new_node(")","");add_new_child($$,temp1);;add_new_child($$,temp2);}
|               OPEN_SQUARE_BRACKET subscriptlist CLOSE_SQUARE_BRACKET  {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node("[","");node*temp2 = create_new_node("]","");add_new_child($$,temp1);add_new_child($$,$2);add_new_child($$,temp2);}
|               OPEN_SQUARE_BRACKET CLOSE_SQUARE_BRACKET                {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node("[","");node*temp2 = create_new_node("]","");add_new_child($$,temp1);add_new_child($$,temp2);}
|               FULLSTOP NAME                                           {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node(".","");add_new_child($$,temp1);add_new_child($$,$2);}

arglist:        argument                                                {$$ = $1;}                  
|               argument arguments  COMMA                               {node*temp = create_new_node("LIST","");add_new_child(temp,$1);add_new_child(temp,$2);$$ = temp;}
|               argument COMMA                                          {$$ = $1;}       
|               argument arguments                                      {node*temp = create_new_node("LIST","");add_new_child(temp,$1);add_new_child(temp,$2);$$ = temp;}                    

arguments :     arguments COMMA argument                                {$$ = $1;add_new_child($$,$3);}
|               COMMA argument                                          {node*temp = create_new_node("ARGUMENTS","");add_new_child(temp,$2);$$ = temp;}

argument:       test                                                    {$$ = $1;}                       
|               test equal test                                         {node*temp = create_new_node("=","");add_new_child(temp,$1);add_new_child(temp,$3);$$ = temp;}


subscriptlist : test                                                    {$$ = $1;}
|               test COLON test                                         {node*temp = create_new_node(":","");add_new_child(temp,$1);add_new_child(temp,$3);$$ = temp;}    
|               test COLON                                              {$$ = $1;}

testlist :      testlist COMMA test {$$ = $1;add_new_child($$,$3);$$->type = 1;}
|               test                {node*temp = create_new_node("LIST","");add_new_child(temp,$1);$$ = temp;$$->type = 1;}

STRINGS :       STRINGS STRING      {$$ = $1;add_new_child($$,$2);$$->type = 1;}
|               STRING              {node*temp = create_new_node("STRINGS","");add_new_child(temp,$1);$$ = temp;$$->type = 1;}


%%

int main(void){
    yyparse();


    print_it(tree);

    return 0;
}

void yyerror(const char *s) {
  fprintf(stderr,"INVALID INPUT in line:%d and pattern : %s \n",yylineno,yytext); 
}

