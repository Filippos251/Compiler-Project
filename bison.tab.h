/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INT = 258,                     /* "int"  */
    CHAR = 259,                    /* "char"  */
    DOUBLE = 260,                  /* "double"  */
    BOOLEAN = 261,                 /* "boolean"  */
    STRING = 262,                  /* "string"  */
    CLASS = 263,                   /* "class"  */
    NEW = 264,                     /* "new"  */
    RETURN = 265,                  /* "return"  */
    VOID = 266,                    /* "void"  */
    IF = 267,                      /* "if"  */
    ELSE = 268,                    /* "else"  */
    WHILE = 269,                   /* "while"  */
    DO = 270,                      /* "do"  */
    FOR = 271,                     /* "for"  */
    SWITCH = 272,                  /* "switch"  */
    CASE = 273,                    /* "case"  */
    DEFAULT = 274,                 /* "default"  */
    BREAK = 275,                   /* "break"  */
    TRUE = 276,                    /* "true"  */
    FALSE = 277,                   /* "false"  */
    PUBLIC = 278,                  /* "public"  */
    PRIVATE = 279,                 /* "private"  */
    PRINT = 280,                   /* "print"  */
    OUT = 281,                     /* "out"  */
    ID = 282,                      /* "identifier"  */
    CLASS_ID = 283,                /* "ClassName"  */
    ICONST = 284,                  /* "Integer Constant"  */
    DBLCONST = 285,                /* "Double Constant"  */
    BLCONST = 286,                 /* "Boolean Constant"  */
    STRCONST = 287,                /* "String Constant"  */
    CHARCONST = 288,               /* "Character Constant"  */
    ADDOP = 289,                   /* "+"  */
    SUBOP = 290,                   /* "-"  */
    MULOP = 291,                   /* "*"  */
    DIVOP = 292,                   /* "/"  */
    EQOP = 293,                    /* "=="  */
    GTOP = 294,                    /* ">"  */
    LTOP = 295,                    /* "<"  */
    NOTEQOP = 296,                 /* "!="  */
    ASSIGNOP = 297,                /* "="  */
    ANDOP = 298,                   /* "&&"  */
    OROP = 299,                    /* "||"  */
    LPAREN = 300,                  /* "("  */
    RPAREN = 301,                  /* ")"  */
    SEMIC = 302,                   /* ";"  */
    DOT = 303,                     /* "."  */
    COMMA = 304,                   /* ","  */
    COLON = 305,                   /* ":"  */
    LBRACK = 306,                  /* "["  */
    RBRACK = 307,                  /* "]"  */
    REFER = 308,                   /* "&"  */
    LBRACE = 309,                  /* "{"  */
    RBRACE = 310,                  /* "}"  */
    HASH = 311,                    /* "#"  */
    AT = 312,                      /* "@"  */
    PERCENT = 313,                 /* "%"  */
    DOLLAR = 314,                  /* "$"  */
    EXCLAM = 315,                  /* "!"  */
    CARET = 316,                   /* "^"  */
    ERROR = 317,                   /* ERROR  */
    ASSIGN = 318,                  /* ASSIGN  */
    NOTEQUOP = 319,                /* NOTEQUOP  */
    EQUOP = 320,                   /* EQUOP  */
    METH = 321                     /* METH  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 28 "bison.y"
     

   int intval;
   char charval;
   double doubleval;
   char* strval;
   int boolval;
   

#line 140 "bison.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
