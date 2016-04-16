%token VERBOSE STATE NAME ELECTORS 
%token NUM
%token DEMOCRATS REPUBLICANS WIN COUNTY HILLARY DONALD CANCELLED

%%
input:  verbose statelist ;

verbose: VERBOSE | /* empty */;

statelist: /* empty */ ;
statelist: statelist state ;

state: STATE ':' NAME ';' ELECTORS ':' NUM ';' countylist ;
state: STATE ':' NAME ';' ELECTORS ':' NUM ';' winner ;

winner:  DEMOCRATS WIN '!'  |  REPUBLICANS WIN '!' ;

countylist: /* empty */;
countylist: countylist county ;


county: COUNTY ':' NAME ';' HILLARY ':' NUM  DONALD ':' NUM ;
county: COUNTY ':' NAME ';' NUM '(' 'D' ')' NUM '(' 'R' ')';
county: COUNTY ':' NAME ';' CANCELLED ;
