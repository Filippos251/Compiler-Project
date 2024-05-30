PARSER.y

%{

/* STATEMENTS BLOCK */

//#include "tokens.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>




extern FILE *yyin; //including the input file  in my path
extern char *yytext; //same for yytext
extern int yylex(); //for bison to identify the lectical analysis function
extern void yyterminate();
/*HASHTABLE*/ 
HASTBL *hashtbl;
int scope = 0; //counter showing the current scope
error_counter = 0;

void lexical_error();  
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


%type <strval> program class class_body member_declarations member_declaration variable_declaration data_type method_declaration modifier return_type parameters parameter_list parameter primitive_type
%type <strval> method_body statement assign loop_statement do_while_loop for_loop control_statement if_statement else_if_statements switch_statement case_branch default_branch print_statement 
%type <strval> return_statement break_statement condition comparison_operator expression term factor pointer_list 

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
%nonassoc else_if_statements



%%

program                    : class
                           | class program
                           ;

class                      : PUBLIC CLASS ID LBRACE class_body RBRACE                                                               {hashtbl_insert(hahstbl, $3 ,NULL, scope);
                           ;

class_body                 : /* empty */     
                           | member_declarations
                           | member_declarations class_body
                           ;

member_declarations        : member_declaration
                           | member_declaration member_declarations
                           ;

member_declaration         : variable_declaration
                           | method_declaration
                           ;

variable_declaration       : PUBLIC data_type ID SEMIC                                                                            {hashtbl_insert(hahstbl, $3 ,NULL, scope);
                           | PRIVATE data_type ID SEMIC                                                                           {hashtbl_insert(hahstbl, $3 ,NULL, scope);
                           ;

data_type                  : INT
                           | DOUBLE
                           | CHAR
                           | BOOLEAN
                           | STRING
                           ;

method_declaration         : modifier return_type ID LPAREN parameters RPAREN LBRACE method_body RBRACE                          {hashtbl_insert(hahstbl, $3 ,NULL, scope);
                           ;

modifier                   : PUBLIC
                           | PRIVATE
                           ;

return_type                : data_type
                           | VOID
                           ;

parameters                 : /* empty */
                           | parameter_list
                           ;

parameter_list             : parameter
                           | parameter COMMA parameter_list
                           ;

parameter                  : primitive_type ID                                                                                    {hashtbl_insert(hahstbl, $2 ,NULL, scope);
                           ;

primitive_type             : INT
                           | CHAR
                           | DOUBLE
                           | BOOLEAN
                           ;

method_body                : /* empty */
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

assign                     : ID ASSIGNOP expression SEMIC                                                                          {hashtbl_insert(hahstbl, $1 ,NULL, scope);
                           ;

loop_statement             : do_while_loop
                           | for_loop
                           ;

do_while_loop              : DO LBRACE statement RBRACE WHILE LPAREN condition RPAREN SEMIC
                           ;

for_loop                   : FOR LPAREN assign condition SEMIC assign RPAREN LBRACE statement RBRACE
                           ;

control_statement          : if_statement
                           | switch_statement
                           ;

if_statement               : IF LPAREN condition RPAREN LBRACE statement RBRACE else_if_statements
                           ;

else_if_statements         : /* empty */
                           | ELSE IF LPAREN condition RPAREN LBRACE statement RBRACE else_if_statements
                           | ELSE LBRACE statement RBRACE %prec LOWER_THAN_ELSE
                           ;

switch_statement           : SWITCH LPAREN expression RPAREN LBRACE case_branch default_branch RBRACE
                           ;

case_branch                : /* empty */
                           | CASE expression COLON statement case_branch
                           ;

default_branch             : /* empty */
                           | DEFAULT COLON statement
                           ;

print_statement            : OUT DOT PRINT LPAREN STRING COMMA ID RPAREN SEMIC                                                      {hashtbl_insert(hahstbl, $7 ,NULL, scope);
                           ;

return_statement           : RETURN expression SEMIC
                           ;

break_statement            : BREAK SEMIC
                           ;

condition                  : expression comparison_operator expression
                           | BOOLEAN
                           | ID                                                                                                     {hashtbl_insert(hahstbl, $1 ,NULL, scope);
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

factor                     : ID                                                                                                    {hashtbl_insert(hahstbl, $1 ,NULL, scope);
                           | ID LBRACK pointer_list RBRACK                                                                         {hashtbl_insert(hahstbl, $1 ,NULL, scope);
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

    if(error_count > 0) 
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





void lexical_error() {
    fprintf(stderr, "Lexical error: Unrecognized token '%s' at line %d\n", yytext, pc);
    error_counter++;
    //yyless(1); μέθοδος πανικού
}


/* I have to make a yyerror function 

void yyerror(const char *message)
{
    error_count++;
    
    if(flag_err_type==0){
        printf("-> ERROR at line %d caused by %s : %s\n", lineno, yytext, message);
    }else if(flag_err_type==1){
        *str_buf_ptr = '\0'; // String or Comment Error. Cleanup old chars stored in buffer.
        printf("-> ERROR at line %d near \"%s\": %s\n", lineno, str_buf, message);
    }
    flag_err_type = 0; // Reset flag_err_type to default.
    if(MAX_ERRORS <= 0) return;
    if(error_count == MAX_ERRORS){
        printf("Max errors (%d) detected. ABORTING...\n", MAX_ERRORS);
        exit(-1);
    }
}
*/