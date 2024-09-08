%{




#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bison.tab.h"


extern FILE *yyin; 
extern char *yytext; 
extern int yylex(); 
extern int yylineno;  


int error_counter = 0;
void yyerror(const char *s);
%}


%start program  

%define parse.error verbose


%union{     

   int intval;
   char charval;
   double doubleval;
   char* strval;
   int boolval;
   
}


%token INT        "int"
%token CHAR       "char"
%token DOUBLE     "double"
%token BOOLEAN    "boolean"
%token STRING     "string"
%token CLASS      "class"
%token NEW        "new"
%token RETURN     "return"
%token VOID       "void"
%token IF         "if"
%token ELSE       "else"
%token WHILE      "while"
%token DO         "do"
%token FOR        "for"
%token SWITCH     "switch"
%token CASE       "case"
%token DEFAULT    "default"
%token BREAK      "break"
%token TRUE       "true"
%token FALSE      "false"
%token PUBLIC     "public"
%token PRIVATE    "private"
%token PRINT      "print"
%token OUT        "out"



%token    <strval>          ID          "identifier"

%token    <strval>          CLASS_ID    "ClassName" 


%token    <intval>          ICONST      "Integer Constant"
%token    <doubleval>       DBLCONST    "Double Constant"
%token    <intval>          BLCONST     "Boolean Constant"
%token    <strval>          STRCONST    "String Constant"
%token    <charval>         CHARCONST   "Character Constant"



%token ADDOP      "+"   
%token SUBOP      "-"  
%token MULOP      "*"  
%token DIVOP      "/"   

%token EQOP       "=="   
%token GTOP       ">"   
%token LTOP       "<"   
%token NOTEQOP    "!="   
%token ASSIGNOP   "="  

%token ANDOP      "&&" 
%token OROP       "||"  



%token LPAREN     "(" 
%token RPAREN     ")"
%token SEMIC      ";" 
%token DOT        "." 
%token COMMA      "," 
%token COLON      ":" 
%token LBRACK     "[" 
%token RBRACK     "]" 
%token REFER      "&" 
%token LBRACE     "{" 
%token RBRACE     "}" 
%token HASH       "#" 
%token AT         "@" 
%token PERCENT    "%" 
%token DOLLAR     "$" 
%token EXCLAM     "!" 
%token CARET      "^" 

%token ERROR


%type  program class class_body  member_declaration multi_variable_declaration multi_variable_assinment variable_declaration data_type method_declaration parameters parameter_list   
%type  parameter primitive_type method_body statement assign loop_statement do_while_loop for_loop control_statement if_statement else_if_statements switch_statement
%type  case_branch default_branch print_statement  return_statement break_statement condition comparison_operator expression term factor pointer_list 


%left   COMMA
%right  ASSIGN 
%left   OROP
%left   ANDOP
%left   NOTEQUOP
%left   EQUOP
%left   GTOP
%left   LTOP
%left   SUBOP
%left   ADDOP
%left   DIVOP
%left   MULOP 
%left   REFER
%left   LPAREN RPAREN LBRACK RBRACK DOT METH






%nonassoc ELSE 



%%
program                    : class
                           | class program
                           ;

class                      : PUBLIC CLASS CLASS_ID LBRACE class_body RBRACE                                                                
                           ;



class_body                 : member_declaration
                           | member_declaration class_body
                           ;

member_declaration         : variable_declaration
                           | method_declaration
                           ;

multi_variable_declaration : COMMA ID multi_variable_declaration                                                                                
                           | SEMIC
                           ;

multi_variable_assinment   : COMMA ID ASSIGNOP expression multi_variable_assinment                                                              
                           | SEMIC
                           ;
 
variable_declaration       : PUBLIC data_type ID multi_variable_declaration                                                                     
                           | PRIVATE data_type ID multi_variable_declaration                  
                           | PUBLIC data_type ID ASSIGNOP expression multi_variable_assinment                                                   
                           | PRIVATE data_type ID ASSIGNOP expression multi_variable_assinment 
                           ;


method_declaration         : PUBLIC data_type ID LPAREN parameters RPAREN LBRACE method_body RBRACE
                           | PRIVATE data_type ID LPAREN parameters RPAREN LBRACE method_body RBRACE 
                           ;

data_type                  : INT
                           | DOUBLE
                           | CHAR
                           | BOOLEAN
                           | STRING
                           | VOID
                           ;


parameters                 : parameter_list
                           ;

parameter_list             : parameter
                           | parameter COMMA parameter_list
                           ;

parameter                  : primitive_type ID                                                                                   
                           ;

primitive_type             : INT
                           | CHAR
                           | DOUBLE
                           | BOOLEAN
                           ;

method_body                : variable_declaration method_body  
                           | statement method_body
                           | /* empty */
                           ;

statement                  : assign
                           | loop_statement
                           | control_statement
                           | print_statement
                           | return_statement
                           | break_statement
                           ;

assign                     : ID ASSIGNOP expression SEMIC                                                                       
                           ;

loop_statement             : do_while_loop
                           | for_loop
                           ;

do_while_loop              : DO LBRACE statement RBRACE WHILE LPAREN condition RPAREN SEMIC
                           ;

for_loop                   : FOR LPAREN assign condition SEMIC assign RPAREN LBRACE  statement  RBRACE
                           ;

control_statement          : if_statement
                           | switch_statement
                           ;

if_statement               : IF LPAREN condition RPAREN LBRACE  statement  RBRACE else_if_statements
                           ;

else_if_statements         : ELSE IF LPAREN condition RPAREN LBRACE statement  RBRACE else_if_statements  
                           | ELSE LBRACE  statement  RBRACE
                           | /* empty */ 
                           ;

switch_statement           : SWITCH LPAREN expression RPAREN LBRACE  case_branch default_branch  RBRACE
                           ;

case_branch                : CASE expression COLON  statement case_branch 
                           | /* empty */
                           ;

default_branch             : DEFAULT COLON  statement
                           | /* empty */ 
                           ;

print_statement            : OUT DOT PRINT LPAREN STRING COMMA ID RPAREN SEMIC                                                      
                           ;

return_statement           : RETURN expression SEMIC
                           ;

break_statement            : BREAK SEMIC
                           ;

condition                  : expression comparison_operator expression
                           | BOOLEAN
                           | ID                                                                                                     
                           ;

comparison_operator        : GTOP
                           | LTOP
                           | EQOP
                           | NOTEQOP
                           | ANDOP
                           | OROP
                           ;
 
expression                 : expression ADDOP expression 
                           | expression SUBOP expression
                           | term
                           ;

term                       : term MULOP term
                           | term DIVOP term
                           | factor
                           ;

factor                     : ID                                                                                                   
                           | ICONST
                           | DBLCONST
                           | ID LBRACK pointer_list RBRACK                       
                           | LPAREN expression RPAREN
                           ;

pointer_list               : expression
                           | expression COMMA pointer_list
                           ;


program                    : error SEMIC { yyerrok;}  //program : program error '\n' { yyerrok; }

   

%%



int main(int argc, char *argv[]){
    
	 if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){                                       
            perror ("Error opening file"); return -1;
        }
    }
    
        
    yyparse();

    if(error_counter > 0) 
    {
        printf("There are %d errors. Unable to analyze the program\n", error_counter);

    } 
    else 
    {
        printf("Program analyzed successfully\n");
    }    

    fclose(yyin);
   return 0;

}
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d near '%s'\n", s, yylineno, yytext);
    error_counter++;
}

