/*
*   Author:     Snorri Agnarsson
*               Tumi Snær Gíslason
*
*   A lexical analyser for the programming language Myrkvi,
*   using JFlex (the JFlex.jar file is required).
*   
*   Compilation:
*       java -jar JFlex.jar Myrkvi.jflex
*       javac Myrkvi.java
*
*
*/

%%

%public
%class MyrkviLexer
%byaccj
%unicode

%{

public MyrkviParser yyparser;

public MyrkviLexer ( java.io.Reader r, MyrkviParser yyparser )
{
    this(r);
    this.yyparser = yyparser;
}

%}

    /*Regex*/

WS = [ \n\t\r]
IF = if
ELIF = elif
ELSE = else

WHILE = while

DEF = def
RETURN = return
VAR = var
PRINT = print

DIGIT = [0-9]
DOUBLE = {DIGIT}+\.{DIGIT}+([eE][+-]?{DIGIT}+)?
INT = {DIGIT}+
OPCHAR = [\+\-*/]

//INIT = [a-zA-ZþæöðáéýúíóÞÆÖÐÁÉÝÚÍÓ]
SYMBOL = [=(){};,]
STRING = \"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"'
NAME=[:letter:]([:letter:]|{DIGIT})*

TRUE = True
FALSE = False

NULL = NULL


%%

    /* JFlex rules */

{WS}
{
    
} /* whitespace -> ignored */

"#".*$
{
    
} /* comment -> line ignored */


{IF}
{
    return MyrkviParser.IF;
}

{ELIF}
{
    return MyrkviParser.ELIF;
}

{ELSE}
{
    return MyrkviParser.ELSE;
}

{WHILE}
{
    return MyrkviParser.WHILE;
}

{DEF}
{
    return MyrkviParser.DEF;
}

{RETURN}
{
    return MyrkviParser.RETURN;
}

{VAR}
{
    return MyrkviParser.VAR;
}


{PRINT}
{
    return MyrkviParser.PRINT;
}


{NAME}
{
    yyparser.yylval = new MyrkviParserVal(yytext());
    return MyrkviParser.NAME;
}

{DOUBLE}|{INT}|{STRING}|{TRUE}|{FALSE}|{NULL}
{
    yyparser.yylval = new MyrkviParserVal(yytext());
    return MyrkviParser.LITERAL;
}

{OPCHAR}+
{
    yyparser.yylval = new MyrkviParserVal(yytext());
    return MyrkviParser.OPNAME;
}

{SYMBOL} {
    return yycharat(0);
}

.
{
    return MyrkviParser.YYERRCODE;
}