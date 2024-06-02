%{

/* STATEMENTS BLOCK */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>
#include "hashtbl.h"
#include "flags.h"



extern FILE *yyin; //including the input file  in my path
extern char *yytext; //same for yytext
extern int yylex(); //for bison to identify the lectical analysis function
extern void yyterminate();
extern int yylineno;  // Declare external line number from lexer
extern char *yytext;  // The text of the current token
/*HASHTABLE*/ 
HASTBL *hashtbl;
int scope = 0; //counter showing the current scope
int error_counter = 0;
void yyerror(const char *s);
%}

%error-verbose //for better error reporting

/*storing token's semantic values */
%union{     

   int intval;
   char charval;
   double doubleval;
   char* strval;
   boolean boolval;
}

//keywords
%token INT        "int"
%token CHAR       "char"
%token DOUBLE     "double"
%token BOOLEAN    "boolean'
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
%token BREAK      "berak"
%token TRUE       "true"
%token FALSE      "false"
%token PUBLIC     "public"
%token PRIVATE    "private"
%token PRINT      "print"
%token OUT        "out"


// Identifier
%token    <strval>          ID          "identifier"

//Constants
%token    <intval>          ICONST      "Integer Constant"
%token    <doubleval>       DBLCONST    "Double Constant"
%token    <boolval>         BLCONST     "Boolean Constant"
%token    <strval>          STRCONST    "String Constant"
%token    <charval>         CHARCONST   "Character Constant"


//Operators
%token ADDOP      "+"   
%token SUBOP      "-"  
%token MULOP      "*"  
%token DIVOP      "/"   
//Comparison, Assignment Operators
%token EQOP       "=="   
%token GTOP       ">"   
%token LTOP       "<"   
%token NOTEQOP    "!="   
%token ASSIGNOP   "="  
//Logical Operators
%token ANDOP      "&&" 
%token OROP       "||"  


// Other Lexical Tokens  (some of them might be extra or i might need some more)
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



%token EOF         0    "end of file"

/*Indicating the non terminal rules type*/
%type <strval> program class class_body member_declarations member_declaration variable_declaration data_type method_declaration modifier return_type parameters parameter_list parameter primitive_type
%type <strval> method_body statement assign loop_statement do_while_loop for_loop control_statement if_statement else_if_statements switch_statement case_branch default_branch print_statement 
%type <strval> return_statement break_statement condition comparison_operator expression term factor pointer_list 

/*Precedences*/
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

//solving the dangling else problem
%nonassoc LOWER_THAN_ELSE
%nonassoc else_if_statements // ELSE



%%
program                    : class
                           | class program
                           ;

class                      : PUBLIC CLASS ID LBRACE class_body RBRACE                                                               {hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           | PUBLIC CLASS ID error class_body RBRACE                                                                {yyerror("ERROR: Missing '{'");} /*feeding the error function*/
                           ;

class_body                 : empty  { }     
                           | member_declarations                                                                         
                           | member_declarations class_body
                           ;

member_declarations        : member_declaration
                           | member_declaration member_declarations
                           ;

member_declaration         : variable_declaration
                           | method_declaration
                           ;


variable_declaration       : PUBLIC data_type ID multi_variable_declaration
{hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           | {scope++;}PRIVATE data_type ID multi_variable_declaration {hashtbl_get(hashtbl, scope);scope--;}           {hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           | PUBLIC data_type ID ASSIGNOP expression multi_variable_declaration
{hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           | {scope++}PRIVATE data_type ID ASSIGNOP expression multi_variable_declaration {hashtbl_get(hashtbl, scope);scope--;}    {hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           ;
                           
                           
multi_variable_declaration : COMMA ID multi_variable_declaration
{hashtbl_insert(hahstbl, $2 ,NULL, scope);}
                           | COMMA ID ASSIGNOP expression multi_variable_declaration
{hashtbl_insert(hahstbl, $2 ,NULL, scope);}    
                           | SEMIC
                           ;
                           
                           
data_type                  : INT
                           | DOUBLE
                           | CHAR
                           | BOOLEAN
                           | STRING
                           ;

method_declaration         : PUBLIC return_type ID LPAREN parameters RPAREN LBRACE method_body RBRACE                           {hashtbl_insert(hahstbl, $3 ,NULL, scope);}
                           | PRIVATE return_type ID LPAREN parameters RPAREN LBRACE{scope++;;} method_body {hashtbl_get(hashtbl, scope);scope--;} RBRACE   {hashtbl_insert(hahstbl, $3 ,NULL, scope);scope++;} {hashtbl_get(hashtbl, scope);scope--;}
                           ;

/*modifier                   : PUBLIC
                           | PRIVATE
                           ; */

return_type                : data_type
                           | VOID
                           ;

parameters                 : empty  { }
                           | parameter_list
                           ;

parameter_list             : parameter
                           | parameter COMMA parameter_list
                           ;

parameter                  : primitive_type ID                                                                                    {hashtbl_insert(hahstbl, $2 ,NULL, scope);}
                           ;

primitive_type             : INT
                           | CHAR
                           | DOUBLE
                           | BOOLEAN
                           ;

method_body                : empty  { }  
                           | variable_declaration method_body
                           | statement method_body
                           ;

statement                  : assign
                           | loop_statement
                           | control_statement
                           | print_statement
                           | return_statement
                           | break_statement
                           ;

assign                     : ID ASSIGNOP expression SEMIC                                                                          {hashtbl_insert(hahstbl, $1 ,NULL, scope);}

                           | ID error expression SEMIC                                                                             {yyerror("ERROR: Missing '='");}
                           ;

loop_statement             : do_while_loop
                           | for_loop
                           ;

do_while_loop              : DO LBRACE{scope++;} statement{hashtbl_get(hashtbl, scope);scope--;} RBRACE WHILE LPAREN condition RPAREN SEMIC
                           ;

for_loop                   : FOR LPAREN assign condition SEMIC assign RPAREN LBRACE {scope++;} statement {hashtbl_get(hashtbl, scope);scope--;} RBRACE
                           ;

control_statement          : if_statement
                           | switch_statement
                           ;

if_statement               : IF LPAREN condition RPAREN LBRACE {scope++;} statement {hashtbl_get(hashtbl, scope);scope--;} RBRACE else_if_statements
                           ;

else_if_statements         : empty  { }
                           | ELSE IF LPAREN condition RPAREN LBRACE {scope++;}statement {hashtbl_get(hashtbl, scope);scope--;} RBRACE else_if_statements
                           | ELSE LBRACE {scope++;} statement {hashtbl_get(hashtbl, scope);scope--;} RBRACE %prec LOWER_THAN_ELSE
                           ;

switch_statement           : SWITCH LPAREN expression RPAREN LBRACE {scope++;} case_branch default_branch {hashtbl_get(hashtbl, scope);scope--;} RBRACE
                           ;

case_branch                : empty  { }
                           | CASE expression COLON {scope++;} statement {hashtbl_get(hashtbl, scope);scope--;} case_branch
                           ;

default_branch             : empty  { }
                           | DEFAULT COLON {scope++;} statement {hashtbl_get(hashtbl, scope);scope--;}
                           ;

print_statement            : OUT DOT PRINT LPAREN STRING COMMA ID RPAREN SEMIC                                                      {hashtbl_insert(hahstbl, $7 ,NULL, scope);}
                           ;

return_statement           : RETURN expression SEMIC
                           ;

break_statement            : BREAK SEMIC
                           ;

condition                  : expression comparison_operator expression
                           | BOOLEAN
                           | ID                                                                                                     {hashtbl_insert(hahstbl, $1 ,NULL, scope);}
                           ;

comparison_operator        : GTOP
                           | LTOP
                           | EQOP
                           | NOTEQOP
                           | ANDOP
                           | OROP
                           ;
 
expression                 : term
                           | expression ADDOP term
                           | expression SUBOP term
                           ;

term                       : factor
                           | term MULOP factor
                           | term DIVOP factor
                           ;

factor                     : ID                                                                                                    {hashtbl_insert(hahstbl, $1 ,NULL, scope);}
                           | ID LBRACK {scope++;}pointer_list {hashtbl_get(hashtbl, scope);scope--;} RBRACK                        {hashtbl_insert(hahstbl, $1 ,NULL, scope);}
                           | LPAREN expression RPAREN
                           ;

pointer_list               : expression
                           | expression COMMA pointer_list
                           ;


%%




int main(int argc, char *argv[]){
    //allocating memory for the hashtable
	if(!(hashtbl = hashtbl_create(10, NULL))) {
        fprintf(stderr, "ERROR: hashtbl_create() failed!\n");
        exit(EXIT_FAILURE);
    }
    
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){                                       
            perror ("Error opening file"); return -1;
        }
    }
    
        
    yyparse();

    if(error_counter > 0) 
    {
        printf("There are %d errors. Unable to analyze the program\n", error_count);

    } 
    else 
    {
        printf("Program analyzed successfully\n");
    }    
    hashtbl_destroy(hashtbl);   //free hashtable from the memory
    fclose(yyin);
   return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d near '%s'\n", s, yylineno, yytext);
    error_counter++;
}
