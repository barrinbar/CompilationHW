%code{ 
#include <stdio.h>
extern int yylex (void);
void yyerror (char *s);
}

%union {
	int num;
	struct{ int d_electors, r_electors; } state_count;
	struct{	int d_votes, r_votes; } county_votes;
}

%type <state_count> state statelist
%type <county_votes> county countylist
%type <num> verbose winner


%token VERBOSE STATE NAME ELECTORS 
%token <num> NUM
%token DEMOCRATS REPUBLICANS WIN COUNTY HILLARY DONALD CANCELLED


%%
input:  verbose statelist 
			{
				// If the democrats defeated the republicans
				if($2.d_electors > 270 && ($2.d_electors > $2.r_electors))
					printf("\n Hillary Clinton wins! ") ;
				
				// If the republicans defeated the democrats
				else if($2.r_electors > 270 && ($2.r_electors >$2.d_electors))
					printf("\n Donald Trump wins! ") ;
				
				// Otherwise there aren't enough electors
				else
					printf("\n No Winner!");

				// If verbose is selected
				if($1 == 0)
				{
					printf("\n Donald Trump has %d electors. \n",$2.r_electors);
					printf("\n Hillary Clinton has %d electors. \n",$2.d_electors);
				};
			};

verbose: VERBOSE /* empty */
			{$$=0;} | {$$=1;};

statelist: /* empty */
			{ $$.d_electors = 0; $$.r_electors = 0; };
statelist: statelist state
			{
				$$.d_electors = $1.d_electors + $2.d_electors;
				$$.r_electors = $1.r_electors + $2.r_electors;
			};

state: STATE ':' NAME ';' ELECTORS ':' NUM ';' countylist
			{
				// If there are more democrat than republican electors in the county
				if ($9.d_votes > $9.r_votes)
					{ $$.d_electors = $7; $$.r_electors = 0;}

				// Otherwise there are more republican than democrat electors in the county
				else 
					{ $$.r_electors = $7; $$.d_electors = 0;}
			};

state: STATE ':' NAME ';' ELECTORS ':' NUM ';' winner
			{
				// If the winner is the democrat candidate
				if ($9 == 0)
					{ $$.d_electors = $7; $$.r_electors = 0;}

				// Othrwise the winner is the republican candidate
				else 
					{ $$.r_electors = $7; $$.d_electors = 0;}
			};

winner:	DEMOCRATS WIN '!' {$$ = 0;} |
		REPUBLICANS WIN '!' {$$ = 1;};

countylist: /* empty */
			{
				$$.d_votes = 0;
				$$.r_votes = 0;
			};

countylist: countylist county
			{
				$$.d_votes = $1.d_votes + $2.d_votes;
				$$.r_votes = $1.r_votes + $2.r_votes;
			};

county: COUNTY ':' NAME ';' HILLARY ':' NUM DONALD ':' NUM
			{
				$$.d_votes = $7;
				$$.r_votes = $10;
			};

county: COUNTY ':' NAME ';' NUM '(' 'D' ')' NUM '(' 'R' ')'
			{
				$$.d_votes = $5;
				$$.r_votes = $9;
			};

county: COUNTY ':' NAME ';' CANCELLED
			{
				$$.d_votes = 0;
				$$.r_votes = 0;
			};


%%
main (int argc, char **argv)
{
	extern FILE *yyin;

	if (argc != 2)
	{
		fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
		return 1;
	}
	yyin = fopen (argv [1], "r");
	
	if (yyin == NULL)
	{
		fprintf (stderr, "failed to open %s\n", argv[1]);
		return 2;
	}

	yyparse ();

	fclose (yyin);
	return 0;
}

void yyerror (char *s)
{
	fprintf (stderr, "%s\n", s);
}