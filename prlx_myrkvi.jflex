/*
*    Author: Tumi Snær Gíslason
*
*    Prototype -> Takes a text file as input and 
*                writes out a sequence of lexemes and tokens,
*                one pair in each line.
*
*    A lexical analyser for the programming language Myrkvi,
*    using JFlex (the JFlex.jar file is required).
*    
*    Compilation:
*        java -jar JFlex.jar prlx_myrkvi.jflex
*        javac prlx_myrkvi.java
*
*    Example of usage:
*        java prlx_myrkvi < test.txt
*
*/

%%

%public
%class prlx_myrkvi
%unicode
%line
%column

%{
    public final int _error = -1;
    public final int _var = 0;
    public final int _op = 1;
    public final int _compop = 2;
    public final int _par = 3;
    public final int _cond = 4;
    public final int _loop = 5;
    public final int _varname = 6;
    public final int _assign = 7;
    public final int _keyword = 8;
    
    public int getLine(){return yyline;}
    public int getColumn(){return yycolumn;}

    class Yytoken{

        public int tok;
        public String text;
        public Yytoken(int tok, String text){

            this.tok = tok;
            this.text = text;

        }

    }

    public static void main(String[]args)
    throws Exception{

        Yytoken token;
        prlx_myrkvi lexer = new prlx_myrkvi(System.in);
        while((token=lexer.yylex()) != null){

            int line = lexer.getLine();
            int column = lexer.getColumn();
            int tok = token.tok;
            String text = token.text;
            System.out.println("Line "+line+", column "+column+", lexeme \""+text+"\", token "+tok);

        }

    }

%}

    /*Regex*/

_sp = [ ]
_ws = [ \t\n\r]

_if = if
_elif = elif
_else = else

_for = for
_while = while

_def = define
_func = function
_ret = return

_digit = [0-9]
_init = [a-zA-ZþæöðáéýúíóÞÆÖÐÁÉÝÚÍÓ]

_var = ({_init}|{_digit})+
_assign = \=

_int = {_digit}{1,10}
_float = {_digit}{1,10}\.{_digit}{1,10}

_bool = True|False

_symbol = [!%\-&/=?~\^+*:<>|()]|{_ws}
_string = \"({_init}|{_symbol})*\"

_op = [\+\-\*\/\^]
_compop = [\<\>]|\=\=|\<\=|\>\=

_lpar = \(
_rpar = \)


%%

    /* JFlex rules */

{_ws}
{
    
} /* whitespace -> ignored */

"#".*$
{
    
} /* comment -> ignored */

{_int}|{_float}|{_bool}|{_string}
{
    return new Yytoken(_var,yytext());
} /* token 0 */

{_op}
{
    return new Yytoken(_op,yytext());
} /* token 1 */

{_compop}
{
    return new Yytoken(_compop,yytext());
} /* token 2 */

{_lpar}|{_rpar}
{
    return new Yytoken(_par,yytext());
} /* token 3 */

{_if}|{_elif}|{_else}
{
    return new Yytoken(_cond,yytext());
} /* token 4 */

{_for}|{_while}
{
    return new Yytoken(_loop,yytext());
} /* token 5 */

{_def}|{_func}|{_ret}
{
    return new Yytoken(_keyword,yytext());
} /* token 8 */

{_var}
{
    return new Yytoken(_varname,yytext());
} /* token 6 */

{_assign}
{
    return new Yytoken(_assign,yytext());
} /* token 7 */

.
{
    return(new Yytoken(_error,yytext()));
}    /* if nothing else is appropriate -> error, token -1*/
