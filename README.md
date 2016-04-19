# CompilationHW1
Repo for HW in compilation course @ Afeka College of Enginering
A basic lexical parser and shift reduce parser for compiling an imaginary elections results language

Joint work of @barrinbar and @omerel

## Usage
1. Create flex file, run: `flex hillary.lex`<br/>lex.yy.c will be created.
2. Create bison file, run: `bison -d hillary.y`<br/>hillary.tab.c and hillary.tab.h files will be created
3. Compile the C files flex and bison created:`gcc -o hillary.exe  lex.yy.c hillary.tab.c`
4. Run the exe file with a relevant input according to the syntax:`.\hillary.exe  <input file>`
