%{
#include <string.h> 
#include "hillary.tab.h"

extern int atoi (const char *);
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */ 
%x COMMENT

%%

[0-9]+            { yylval.num = atoi(yytext); return NUM; }
[a-zA-Z][a-zA-Z]* { return NAME; }
[\n\t ]+          /* skip white space */
"//"              { BEGIN (COMMENT); }
<COMMENT>.+       /* skip comment */
<COMMENT>\n       {  /* end of comment --> resume normal processing */
                  BEGIN (0); }

"state"           { return STATE; }
"county"          { return COUNTY; }
"cancelled"       { return CANCELLED; }
"Hillary"         { return HILLARY; }
"Hillary Clinton" { return HILLARY; }
"Donald"          { return DONALD; }
"Donald Trump"    { return DONALD; }
"electors"        { return ELECTORS; }
"Democrats"       { return DEMOCRATS; }
"(D)"             { return DEMOCRATS; }
"Republicans"     { return REPUBLICANS; }
"(R)"             { return REPUBLICANS; }
"Win !"           { return WIN; }
"verbose"         { return VERBOSE; }

.                 { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%