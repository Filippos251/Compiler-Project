tokens.h file

/*This setup ensures that both your lexer and parser are using the same token definitions and have access to the yylval variable for passing semantic values from the lexer to the parser. It's a common practice in compiler development to separate token definitions into a separate header file for maintainability and consistency. */



//keywords
#define INT        1
#define CHAR       2
#define DOUBLE     3
#define BOOLEAN    4
#define STRING     5
#define CLASS      6
#define NEW        7
#define RETURN     8
#define VOID       9
#define IF         10
#define ELSE       11
#define WHILE      12
#define DO         13
#define FOR        14
#define SWITCH     15
#define CASE       16
#define DEFAULT    17
#define BREAK      18
#define TRUE       19
#define FALSE      20
#define PUBLIC     21
#define PRIVATE    22



// Identifier
#define ID         23


//Operators
#define ADDOP      24   // '+'
#define SUBOP      25   // '-'
#define MULOP      26   // '*'
#define DIVOP      27   // '/'
//Comparison, Assignment Operators
#define EQOP       28    // '=='
#define GTOP       29   // '>'
#define LTOP       30   // '<'
#define NOTEQOP    31   // '!='
#define ASSIGNOP   32   // '='
//Logical Operators
#define ANDOP      33  // '&&'
#define OROP       34  // '||'


// Other Lexical Tokens  (some of them might be extra or i might need some more)
#define LPAREN     35 // Left parenthesis '(' token
#define RPAREN     36 // Right parenthesis ')' token
#define SEMIC      37 // Semicolon ';' token
#define DOT        38 // Dot '.' token
#define COMMA      39 // Comma ',' token
#define COLON      40 // Colon ':' token
#define LBRACK     41 // Left bracket '[' token
#define RBRACK     42 // Right bracket ']' token
#define REFER      43 // Reference token '&'
#define LBRACE     44 // Left brace '{' token
#define RBRACE     45 // Right brace '}' token
#define HASH       46 // Hahtag '#'
#define AT         47 // '@'
#define PERCENT    48 // '%'
#define DOLLAR     49 // '$'
#define EXCLAM     50 // '!'
#define CARET      51 // '^'



#define EOF        0  // End of file token



/*define flags for debugging features*/

#ifndef FLEX_DEBUG
#define FLEX_DEBUG      1    //General flag to enable debugging features.
#define SHOW_TOKENS     1    //When set, it enables printing of token information.
#define SHOW_NUMERIC    1    //When set, it enables printing of numeric constants
#endif


/*Define yyval to send information from the lexer to the parser */

typedef union {
    int num;       // For integer and double literals
    char *str;     // For identifiers, strings, and booleans
    // Add other types as needed
} YYSTYPE;

extern YYSTYPE yylval;  // Declare yylval as extern to be used in both lexer and parser



/*These flags are typically used in conditional statements within the Flex lexer to control the output of debugging information. For example, in the provided code for the token_print function, the output of token information is controlled by these flags. */
