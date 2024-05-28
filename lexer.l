/*flex.l αρχείο */

%{

/* STATEMENTS BLOCK */

#include "tokens.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>


int pc = 1 ;           // program counter, shows current line
int error_counter = 0; // Program's total errors


extern char *yytext; // Current token
extern int yylex(void);                  // lexer function
extern void yyterminate(void);           // terminating the lexical analysis 


void lexical_error();        // functions that detects unrecognizable tokens and the line in which they are located
void token_print(int token_id);

YYSTYPE yylval;//global variable type YYSTYPE used to pass information from the lexer to the parser. It is typically used to store the value of tokens that have associated semantic values
%}

/* Read only one file option */
%option noyywrap

%option yylineno   //δειχνει τη τρέχουσα γραμμή


/*Names Definitions (macros)

LETTER              [a-zA-Z]
DIGIT               [0-9]
ASCII               [ !"#$%&'()*+,-./:;<=>?@\[\\\]^_`{|}~]
WHITESPACE          [ \t\n]+                                                    //ignore whitespaces
NEWLINE             [\n]
ID                  [{LETTER}_]({LETTER}{DIGIT}_)*                              //identifier
CHAR                \'{NEWLINE}\'|\'{ASCII}\'|\'{LETTER}\'|\'{DIGIT}\'    
STRING              \" [^\"\n]+ \"
INT                 {DIGIT}+
DOUBLE              {DIGIT}+\.{DIGIT}+d
BOOLEAN             "true"|"false"
LINECOMMENT         \/\/[^\n]*      
MULTICOMMENT        \/\*([^*]|\*[^\/])*\*\/


%%


/*RULES BLOCK */

/* Keywords */


"int"                                               {token_print(INT); return INT;}  

"char"                                              {token_print(CHAR);return CHAR;}

"double"                                            {token_print(DOUBLE);return DOUBLE;}

"boolean"                                           {token_print(BOOLEAN);return BOOLEAN;}

"String"                                            {token_print(STRING);return STRING;}

"class"                                             {token_print(CLASS);return CLASS;}

"new"                                               {token_print(NEW);return NEW;}

"return"                                            {token_print(RETURN);return RETURN;}

"void"                                              {token_print(VOID);return VOID;}

"if"                                                {token_print(IF);return IF;}

"else"                                              {token_print(ELSE);return ELSE;}

"while"                                             {token_print(WHILE);return WHILE;}

"do"                                                {token_print(DO);return DO;}

"for"                                               {token_print(FOR);return FOR;}

"switch"                                            {token_print(SWITCH);return SWITCH;}

"case"                                              {token_print(CASE);return CASE;}

"default"                                           {token_print(DEFAULT);return DEFAULT;}

"break"                                             {token_print(BRAKE);return BREAK;}

"true"                                              {token_print(TRUE);return TRUE;}

"false"                                             {token_print(FALSE);return FALSE;}

"public"                                            {token_print(PUBLIC);return PUBLIC;}

"private"                                           {token_print(PRIVATE);return PRIVATE;}




 /* Operators */    
"+"                                                {token_print(ADDOP);return ADDOP;}  

"-"                                                {token_print(SUBOP);return SUBOP;} 

"*"                                                {token_print(MULOP);return MULOP;} 

"/"                                                {token_print(DIVOP);return DIVOP;} 

"=="                                               {token_print(EQOP);return EQOP;} 

"="                                                {token_print(ASSIGNOP);return ASSIGNOP;} 

">"                                                {token_print(GTOP);return GTOP;} 

"<"                                                {token_print(LTOP);return LTOP;}

"!="                                               {token_print(NOTEQOP);return NOTEQOP;}

"&&"                                               {token_print(ANDOP);return ANDOP;}

"||"                                               {token_print(OROP);return OROP;}  


 /* Identifier */

{ID}                                               {token_print(ID);yylval.str = strdup(yytext); return ID;}   

/*Added an extra action, to ensure that my lexer performs semantic value passing. I do the same for the following 5 rules, which analyse tokens with semantic value*/
 


/*Data Types */

{CHAR}                                             {token_print(CHAR); yylval.str = strdup(yytext); return CHAR;}

{STRING}                                           {token_print(STRING); yylval.str = strdup(yytext); return STRING;}

{INT}                                              {token_print(INT); yylval.num = atoi(yytext); return INT;} 

{DOUBLE}                                           {token_print(DOUBLE); yylval.num = atof(yytext);return DOUBLE;} 

{BOOLEAN}                                          {token_print(BOOLEAN); yylval.str = strdup(yytext);return BOOLEAN;}


/* Whitespaces */

{WHITESPACE}                                        {/* ignore whitespace */}


/* Newline */

{NEWLINE}                                           { pc += 1; }


/*COMMENTS*/

{LINECOMMENT}                                       {/*Ignore single Line comment */}

{MULTICOMMENT}                                      {/*Ignore multi line comment */}

 /* Other Lexical Tokens (some of them might be extra or I might need some more as I ve already said in the header file */
"("                                                    {token_print(LPAREN); return LPAREN;}
 
")"                                                    {token_print(RPAREN); return RPAREN;} 

";"                                                    {token_print(SEMIC); return SEMIC;}

"."                                                    {token_print(DOT); return DOT;}

","                                                    {token_print(COMMA); return COMMA;}

":"                                                    {token_print(COLON); return COLON; }

"["                                                    {token_print(LBRACK); return LBRACK;}

"]"                                                    {token_print(RBRACK); return RBRACK;}

"&"                                                    {token_print(REFER); return REFER; }

"{"                                                    {token_print(LBRACE); return LBRACE;}

"}"                                                    {token_print(RBACE); return RBRACE;}

"#"                                                    {token_print(HASH); return HASH;}

"@"                                                    {token_print(AT); return AT;}

"%"                                                    {token_print(PERCENT); return PERCENT;}

"$"                                                    {token_print(DOLLAR); return DOLLAR;}

"!"                                                    {token_print(EXCLAM); return EXCLAM;}

"^"                                                    {token_print(CARET); return CARET;}


/* Unrecognised token */
.                                                   {lexical_error();}


/* End of File */
<<EOF>>                                                 return 0;


%%

int main(int argc, char *argv[]){
    int token;
    
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("Error opening file"); return -1;
        }
    }
    
    do{
		token = yylex();
                if (error_count > 0) { break; }  /*stop the lexical analysis if any error is found*/
            
    }while(token != EOF);

    if(error_count > 0) 
    {
        printf("There are %d errors. Unable to analyze the program\n", error_count);

    } 
    else 
    {
        printf("Program analyzed successfully\n");
    }    

    fclose(yyin);
    yyterminate();  //terminate the lexical analysis
}





void lexical_error() {
    fprintf(stderr, "Lexical error: Unrecognized token '%s' at line %d\n", yytext, pc);
    error_counter++;
}


/*Token print function */
void token_print(int token_id){
    if(FLEX_DEBUG && SHOW_TOKENS){
        printf("TOKEN FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", yytext, token_id, pc);
    }    
}



/*
yylval is a union which you can either declare or the bison will declare automatically. Bison's default yylval is essentially useless. 
You declare yylval using %union { ... } in your parser because you may need to return other values from the scanner to the parser. 
For example, when you match a number in your scanner, you'll want to return a token like T_NUM. But you most probably also want the value of that number, which is where yylval comes handy. 
Using yylval, if you have an integer field, you could simply do yylval.num = atoi(yytext) inside your scanner, and then use that num field in the parser. */
