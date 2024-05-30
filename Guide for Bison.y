ΣΥΝΤΑΚΤΙΚΗ ΑΝΑΛΥΣΗ με χρήση Bison

Στον ίδιο φάκελο με τον λεκτικό αναλυτή κλπ φτιάχνω τον συντακτικό αναλυτή

Ο συντακτικός αναλυτής είναι ένα .y αρχείο 
Από τον BISON θα καλούμε κάθε φορά το flex.l

MOΡΦΗ ΑΡΧΕΙΟΥ

%{
 <C CODE + INCLUDES>
%}

 <BLOCK 1>

%%

 <BLOCK 2>

%%

 <BLOCK 3>


Περιγραφή Μπλοκς


<BLOCK 1> : options σχετικά με τον συντακτικό αναλυτή

<BLOCK 2> : Κανόνες τις συντακτικής ανάλυσης, δηλαδή οι κανόνες γραμματικής, δηλαδή το BNF

<BLOCK 3> :Εντολές χρήστη


/*Defining yylval in the Parser File: */

%union {
    char* str;
    // Other types can be added here if needed
}

%token <str> IDENTIFIER INTEGER_LITERAL DOUBLE_LITERAL STRING_LITERAL CHARACTER_LITERAL


Here, %union is used to define the various types of semantic values that tokens can have. The <str> notation specifies that the token will use the str field of yylval.




@<BLOCK 1>
Βάζω τις ίδιες βιβλιοθήκες με τον λ.α.


@<BLOCK 2> : Κανόνες τις συντακτικής ανάλυσης, δηλαδή οι κανόνες γραμματικής, δηλαδή το BNF
Πως μεταφράζω το bnf σε κανόνες
::= <=> :
ε <=> %empty

Στους κανόνες στο δεξί μέρος μπορώ να καλέσω τερματικά (συνήθως γραμμένα με κεφαλαία) ή και μη τερματικά
Οι αριστεροί κανόνες είναι μη τερματικά σύμβολα

@<BLOCK 3>

CODE
Βγάζω τη main() από τον λεκτικό αναλυτή και την βάζω στο bison ( για την ακρίβεια απλά την μεταφέρω)

int main(int argc, char *argv[]){
    int token;
    
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){                                       //το yyin δεν αναγνωρίζεται εδώ γιατί προέρχεται από τον λεκτικό αναλυτή και στο κομμάτι αυτό δεν το έχω δηλώσει
            perror ("Error opening file"); return -1;
        }
    }
    
    /* ΛΕΚΤΙΚΗ ΑΝΑΛΥΣΗ 
    do{
		token = yylex();
                if (error_count > 0) { break; }  /*stop the lexical analysis if any error is found*/
            
    }while(token != EOF);
    */
    /*Πλέον κάνω ΣΥΝΤΑΚΤΙΚΗ ΑΝΑΛΥΣΗ άρα αλλάζω το παραπάνω κομμάτι με τη παρακάτω συνάρτηση*/
    yyparse();

    if(error_count > 0) 
    {
        printf("There are %d errors. Unable to analyze the program\n", error_count);

    } 
    else 
    {
        printf("Program analyzed successfully\n");
    }    

    fclose(yyin);
   /* yyterminate(); */ //terminate the lexical analysis, πλέον δεν κάνω λεκτική ανάλυση άρα αυτή η εντολή είναι περιττή
   return 0;
}



O ΣΥΝΤΑΚΤΙΚΟΣ ΑΝΑΛΥΤΗΣ δεν αναγνωρίζει τη  μορφή των tokens του tokens.h file. Πρέπει να τους αλλάξουμε την μορφή 

#define INT        1

        optional         optional
%token  <type>    INT   <number>      "description"  // αν δεν δηλώσω τον αριθμό, όπως κάνω παραπάνω οι αριθμοί είναι randomly generated 

%token  INT  "integer"    //ουσιαστικά ορίζω το INT και του δίνει ένα description integer. Όπου υπάρχει το INT στους κανόνες του Σ.Α. θα αναγνωρίζεται από αυτόν τον ορισμό

%token <strval> ID   "identifier"

Οπότε αλλάζω τη μορφή ορισμού όλων των tokens του lexer.h file με εξαίρεση το EOF, όπου πρέπει αναγκαστικά να του βάλουμε έναν αριθμό

%token EOF  0 "end of file"

To <type> είναι ο τύπος του token δηλαδή το token ID έιναι τύπου <charval>. Για να χρησιμοποιήσω τα token <type> πρέπει να τα ορίσω.

/*Περιέχει κάθε δυνατό τύπο που μπορώ να χρησιμοποιήσω στους ορισμούς των tokens */
/*Δήλωση τύπων που περιέχει η μνήμη. Αν το input file έχει μία δήλωση τύπου int x = 5; το 5 θέλω να το αποθηκεύσω στο union για να μπορώ να το χρησιμοποιήσω μετά*/
%union{     

   int intval;
   char charval;
   double doubletval;
   char* strval;
}

Το union είναι σαν ένα enum struct
ΟΠΟΤΕ ΣΤΟΝ Λ.Α. μπορώ να φτιάξω τρία ακόμα tokens ICONST, FCONST, STRCONST για να καταλαβαίνει ο Σ.Α. τον τύπο των tokens με semantic value (τα consts, τα ids, Boolean, ...)

int x = 5;
Πρέπει να αποθηκεύσω το 5 ως intval αλλά και το x ως strval, γιατί το έχω ορίσει δυναμικά και πρέπει να υπάρζει στη μνήμη για να το χρησιμοποιώ και στο μέλλον
 
Όταν τρέξω τον Σ.Α. παράγονται 3 αρχεία
Το syntax.output περιέχει όλα τα στοιχεία για ότι έχει συμβεί, και τις καταστάσεις, φαίνονται τα conflicts
Το syntax.tab.c είναι κώδικας που δεν με ενδιαφέρει
Και το syntax.tab.h περιέχει όλα τα id που έχουν ανατεθεί στα tokens

ΓΙΑ ΝΑ ΤΡΕΞΩ ΤΟ ΑΡΧΕΙΟ

αρχείο MAKE FILE, αρχείο make file φτιάχνει άλλα αρχεία, για να μην χρειαστεί να τρέχω πολλές φορές τις debug & run εντολές.

make, make clean //πετάει όλα τα generated αρχεία

ΠΕΡΙΣΣΟΤΕΡΑ ΓΙΑ Σ.Α.
CONFLICTS
φαίνονται στα states δηλασή στο .output file
shift-reduce & reduce-reduce conflicts παράγονται δύο δέντρα Σ.Α. δεν θέλω η γραμματική μου να είναι διφορούμενη
e.g.
<S> ::= <S>+<S> | <S>*<S> | *<S> | INT

3 + 5*4, στην παραπάνω έκφραση δεν είναι ξεκάθαρη η προτεραιότητα, conflict
ΛΥΣΗ:
generally: 
x op y op z

%left  //αριστερή προεραιτικότητα  (x op y) op z
%right //x op (y op z)
%nonassoc // δεν επιτρέπονται δύο ίδιους op στη σειρά

προταιρεότητες
Στο wiki βρίσκω για τη C (operators precedences) και γράφω από κάτω προς τα πάνω

%left COMMA
%right ASSIGN
%left OR
%left AND

τελευταίο άλυτο conflict είναι το dangling else problem στο if

if a then if b then s else s2
if a then (if b then s else s2)  ή if a then (if b then s) else s2
λύση: στο τέλος του if statement στη γραμματική βάζω %prec LOWE_THAN_ELSE και στα options %nonassoc LOWER_THAN_ELSE και %nonassoc ο κανόνας που έβαλα το prec (43o minute)

Έχω δηλώσει τον τύπο των τερματικώμ συμβόλων, tokens. Πρέπει να δηλώσει και αυτόν των μη τερματικών ( αριστεροί κανόνες της γραμματικής)
%type <strval> program method_declaration ...

ERRORS

Τροποποίηση γραμματικής για ανίχνευση και διόρθωση λαθών // περιττό βήμα
e.g.
int main() {
   <code>
}  αν λείπει το int ή είναι κάτι άλλο έχω θέμα, αν την ονομάσω mainZ έχω θέμα, αν λείπουν παρενθέσεις επίσης. Οπότε τροποποιώ τη γραμματική για να εμποδίζω αυτά τα στανταρ λάθη

main header:     INT    MAIN   LPAREN   RPAREN
                 |error MAIN   LPAREN   RPAREN   { yyerror("Wrong use of 'int main()"); yyerrok; } // yyerrok εντολή ανάκαμψης λάθους
                 |INT   error  LPAREN   RPAREN
                 |INT    MAIN   error   RPAREN
                 |INT    MAIN   LPARN    error

ΠΙΝΑΚΑΣ ΣΥΜΒΟΛΩΝ (HASH TABLE)
o οποίος περιέχει τα ids των tokens και διαχειρίζεται τις εμβέλειες του προγράμματος
Ο πίνακας συμβόλων είναι ένας πίνακας που έχει ως τίτλους στυλών και δηλαδή περιεχόμενα τα επόμενα
Identifier, Value, Type, Scope (σε ποιο σημείο του προγράμματος αναφέρομαι, δηλαδή που εμφανίζεται η μεταβήτή που ορίζω)

Aν είχα ένα input file:
int x = 5;
double y = 3.0;
boolean b = true;
string my_str = "something";

Θέλω να αποθηκεύω τα variables στη μνήμη( όταν αποθήκευα τα semantic values στο union ήταν άλλος ο λόγος)
Πίνακας συμβόλων ως μνήμη:
Identifier:x, Value:5, Type:int, Scope:
Identifier:y, Value:3.0, Type:double, Scope:
Identifier:b, Value:true, Type:boolean, Scope:

Scopes 
e.g.
int a = 6;  //scope 0
int main(){       //main scope 0, μέσα στο άγγιστρο scope 1 μέσα στο if scope 2, βγαίνω από άγγιστρο μειώνεται κατά ένα το scope, μπαίνω σε άγγιστρο scope+=1 
  if(...){
   int x = 5;
  }
  else{
  printf("number %d", x);    // error δεν ξέρει τι είναι το x. H δήλωση του x δεν βρίσκεται σε visible scope από το else
 }
}
//Το scope 2 της if με το scope 2 της else έιναι διαφορετικό

Υλοποίηση Πίνακα συμβόλων //έχω φτιάξει ένα αρχείο hashtbl.h που είναι σημαντικό για το κομμάτι αυτό
Στον Σ.Α. δηλαδή .y file
Στα definitions #include "extra/hashtbl.h"  //έχω φτιάξει έναν έξτρα φάκελο στον οποίο έχω συμπεριλάβει το hashtbl.h file
Για να δηλώσω ότι υπάρχει ο πίνακας :
φτιάχνω μία global μεταβλητή 
HASTBL *hashtbl;
int scope = 0; //counter που δείχνει σε ποιο scope είμαι
Στη main i initialize the table, the variable *hashtbl
Δεσμεύω χώρο για τον πίνακα και πετάω μήνυμα λάθους αν δεν γίνει η δέσμευση
if(!(hashtbl = hashtbl_create(10, NULL))) {
        fprintf(stderr, "ERROR: hashtbl_create() failed!\n");
        exit(EXIT_FAILURE);
    }
 Στο τέλος το κάνω free από τη μνήμη 
   hashtbl_destroy(hashtbl);  //υπάρχει στο hashtbl.h

Στο hashtbl.h insert εισάγει δεδομένα στο πίνακα, remove κάποιας τιμής του πίνακα, hashtbl_get εμφανίζονται τη τρέχουσα στιγμή τα περιεχόμενα του πίνακα στο scope που επιλέγω

Πότε αποθηκεύω κάτι στο hashtbl; 
e.g.
int x = 5;
double y = 3.0;

ψάχνω να βρω τα identifiers για να τα αποθηκεύσω στο hashtbl
Δηλαδή κάθε φορά που βρίσκω το token ID θέλω να το αποθηκέυω σττον πίνακα συμβόλων
Παίρνω τη συνάρτηση hashtbl_insert από το hashtbl.h
Δηλαδή στους κανόνες της γραμματικής κάθε φορά που έχω το ID  ως τερματικό σύμβολο καλώ την  {hashtbl_insert(hahstbl, $1 ,NULL, scope); //υποθέτω ότι αρχικά δεν έχω δεδομένα
$1 παίρνω τον κανόνα του πρώτου συμβόλου που βλέπω αριστερά, το οποίο ειναι το ID, για να βρω το key του 
Γενική μορφή: int hashtbl_insert(HASHTBL *hashtbl, const char *key, void *data, int scope); 
Ο μη-τερματικός κανόνας παίρνει τη τιμή $$
