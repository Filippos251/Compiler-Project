/*flex.l αρχείο */

%{

/* STATEMENTS BLOCK */

#include "hashtbl.h" 
#include "flags.h" 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>

/*define flags for debugging features*/

//#define FLEX_DEBUG      0
#ifndef FLEX_DEBUG
#define FLEX_DEBUG      1    //General flag to enable debugging features.
#define SHOW_TOKENS     1    //When set, it enables printing of token information.
#endif


int yylineno = 1 ;           // shows current line


/** Extern from Bison **/
extern void yyerror(const char *s);

void token_print(int token_id);


%}

/* Read only one file option */
%option noyywrap

%option yylineno   //δειχνει τη τρέχουσα γραμμή, περιττό, όρισα δικό μου counter


/*Names Definitions (macros)

LETTER              [a-zA-Z]
DIGIT               [0-9]
ASCII               [ !"#$%&'()*+,-./:;<=>?@\[\\\]^_`{|}~]
WHITESPACE          [ \t\n]*                                                    //ignore whitespaces
SPECIALCHAR         [ \t\n\r]
NEWLINE             [\n]
ID                  [{LETTER}_]({LETTER}{DIGIT}_)*                              //identifier
CHAR                \'{SPECIALCHAR}\'|\'{ASCII}\'|\'{LETTER}\'|\'{DIGIT}\'    
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

{ID}                                               {token_print(ID);yylval.strval = strdup(yytext); return ID;}   

/*Added an extra action, to ensure that my lexer performs semantic value passing. I do the same for the following 5 rules, which analyse tokens with semantic value*/
 


/*Data Types, Constants */

//yyval δείχνει στο %union στο type str. H strdup είναι ένας pointer που αντιγράφει τα περιεχόμενα του yytext στο yylval

{CHAR}                                             {token_print(CHARCONST); yylval.charval = strdup(yytext); return CHARCONST;}   //yytext[1] doesnt work for '\n', i need a new function

{STRING}                                           {token_print(STRCONST); yylval.strval = strdup(yytext); return STRCONST;}

{INT}                                              {token_print(ICONST); yylval.intval = atoi(yytext); return ICONST;} 

{DOUBLE}                                           {token_print(DBLCONST); yylval.doubleval = atof(yytext);return DBLCONST;} 

{BOOLEAN}                                          {token_print(BLCONST); yylval.strval = strdup(yytext);return BLCONST;}


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
.                                                      {{ yyerror("Unexpected character"); } /* Lexical error handler */}


/* End of File */
<<EOF>>                                                 return 0;


%%
/*End of input*/
int yywrap() {
    return 1;
}

/*Token print function */
void token_print(int token_id){
    if(FLEX_DEBUG && SHOW_TOKENS){  //flags in order to hide the token output if not neccessary, and get as output only errors
        printf("TOKEN FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", yytext, token_id, yylineno);
    }    
}



