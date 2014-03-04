/*
*   Author: Tumi Snær Gíslason
*
*   A lexical analyser for the programming language Myrkvi,
*   using JFlex (the JFlex.jar file is required).
*   
*   Compilation:
*       java -jar JFlex.jar myrkvi.jflex
*       javac myrkvi.java
*
*   Example of usage:
*       java myrkvi < test.txt
*
*/

%%

%public
%class Myrkvi
%byaccj
%unicode
%line
%column

%{
    public final int _error = -1;
    public final int _if = 0;
    public final int _elif = 1;
    public final int _else = 2;
    public final int _while = 3;
    public final int _def = 4;
    public final int _func = 5;
    public final int _ret = 6;
    public final int _var = 7;
    public final int _literal = 8;
    public final int _name = 9;
    public final int _opname = 10;
    
    public int getLine(){return yyline;}
    public int getColumn(){return yycolumn;}
/*
    class Yytoken{

        public int tok;
        public String text;
        public Yytoken(int tok, String text){

            this.tok = tok;
            this.text = text;

        }

    }
*/

    public static void main(String[]args)
    throws Exception{

        Yytoken token;
        myrkvi lexer = new myrkvi(System.in);
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

_ws = [ \n\t\r]
_newline = [\n]
_tab = [\t]

_if = if
_elif = elif
_else = else

_while = while

_def = def
_func = function
_ret = return
_var = var

_digit = [0-9]
_double = {_digit}+\.{_digit}+([eE][+-]?{_digit}+)?
_int = {_digit}+
_opname = [+-*/]

_init = [a-zA-ZþæöðáéýúíóÞÆÖÐÁÉÝÚÍÓ]
_symbol = [\"!%\-&/=?~\^+*:<>|\(\)\{\}]
_name = ({_init}|{_digit}|{_symbol})*
_string = \"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"'

_true = True
_false = False

_null = NULL

%%

    /* JFlex rules */

{_ws}
{
    
} /* whitespace -> ignored */

"#".*$
{
    
} /* comment -> ignored */

{_if}
{
    return new Yytoken(_if,yytext());
} /* token 0 */

{_elif}
{
    return new Yytoken(_elif,yytext());
} /* token 1 */

{_else}
{
    return new Yytoken(_else,yytext());
} /* token 2 */

{_while}
{
    return new Yytoken(_while,yytext());
} /* token 3 */

{_def}
{
    return new Yytoken(_def,yytext());
} /* token 4 */

{_func}
{
    return new Yytoken(_func,yytext());
} /* token 5 */

{_ret}
{
    return new Yytoken(_ret,yytext());
} /* token 6 */

{_var}
{
    return new Yytoken(_var,yytext());
} /* token 7 */

{_double}|{_int}|{_string}|{_true}|{_false}|{_null}
{
    return new Yytoken(_literal,yytext());
} /* token 8 */

{_name}
{
    return new Yytoken(_name,yytext());
} /* token 9 */

{_opname}
{
    return new Yytoken(_opname,yytext());
} /* token 10 */

.
{
    return(new Yytoken(_error,yytext()));
}   /* if nothing else is appropriate -> error, token -1*/
