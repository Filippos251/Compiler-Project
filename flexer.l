

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bison.tab.h"


extern int yylineno;       


%}


%option noyywrap

%option yylineno   




%%








"int"                                               { return INT;}  

"char"                                              { return CHAR;}

"double"                                            { return DOUBLE;}

"boolean"                                           { return BOOLEAN;}

"String"                                            { return STRING;}

"class"                                             { return CLASS;}

"new"                                               { return NEW;}

"return"                                            { return RETURN;}

"void"                                              { return VOID;}

"if"                                                { return IF;}

"else"                                              { return ELSE;}

"while"                                             { return WHILE;}

"do"                                                { return DO;}

"for"                                               { return FOR;}

"switch"                                            { return SWITCH;}

"case"                                              { return CASE;}

"default"                                           { return DEFAULT;}

"break"                                             { return BREAK;}

"true"                                              { return TRUE; yylval.intval = 1; return BLCONST;}

"false"                                             { return FALSE; yylval.intval = 0; return BLCONST;}

"public"                                            { return PUBLIC;}

"private"                                           { return PRIVATE;}





"+"                                                { return ADDOP;}  

"-"                                                { return SUBOP;} 

"*"                                                { return MULOP;} 

"/"                                                { return DIVOP;} 

"=="                                               { return EQOP;} 

"="                                                { return ASSIGNOP;} 

">"                                                { return GTOP;} 

"<"                                                { return LTOP;}

"!="                                               { return NOTEQOP;}

"&&"                                               { return ANDOP;}

"||"                                               { return OROP;}  



[A-Z][a-zA-Z0-9_]*                                 { yylval.strval = strdup(yytext); return CLASS_ID;}


[a-zA-Z][a-zA-Z0-9_]*                              { yylval.strval = strdup(yytext); return ID;}   


 






'.'                                                { yylval.charval = yytext[1]; return CHARCONST;}   

\"([^\\\"]|\\.)*\"                                 { yylval.strval = strdup(yytext); return STRCONST;}

[0-9]+                                             { yylval.intval = atoi(yytext); return ICONST;} 

[0-9]+"."[0-9]+"d"                                 { yylval.doubleval = atof(yytext);return DBLCONST;} 





[ \t]+                                             {/* ignore whitespace */}




\n                                                 { yylineno++; }




"//"(.)*\n                                          {/*Ignore single Line comment */ yylineno++;}

"/*"([^*]|\*+[^*/])*"*/"                            {/*Ignore multi line comment */ yylineno++;}


"("                                                    { return LPAREN;}
 
")"                                                    { return RPAREN;} 

";"                                                    { return SEMIC;}

"."                                                    { return DOT;}

","                                                    { return COMMA;}

":"                                                    { return COLON; }

"["                                                    { return LBRACK;}

"]"                                                    { return RBRACK;}

"&"                                                    { return REFER; }

"{"                                                    { return LBRACE;}

"}"                                                    { return RBRACE;}

"#"                                                    { return HASH;}

"@"                                                    { return AT;}

"%"                                                    { return PERCENT;}

"$"                                                    { return DOLLAR;}

"!"                                                    { return EXCLAM;}

"^"                                                    { return CARET;}



.                                                      { fprintf(stderr, "Unrecognized character '%s' at line %d\n", yytext, yylineno); return ERROR; }


<<EOF>>                                                 return 0;


%%




