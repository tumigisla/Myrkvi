MyrkviLexer.class MyrkviParser.class MyrkviParserVal.class: MyrkviLexer.java MyrkviParser.java MyrkviParserVal.java
	javac MyrkviLexer.java MyrkviLexer.java MyrkviParser.java MyrkviParserVal.java
MyrkviLexer.java: myrkvi.jflex
	java -jar JFlex.jar myrkvi.jflex
MyrkviParser.java MyrkviParserVal.java: myrkvi.byaccj
	byaccj -J -Jclass=MyrkviParser myrkvi.byaccj
test.masm: MyrkviParser.class test.test
	java MyrkviParser test.test > test.masm
clean:
	rm -Rf *~ Myrkvi*.class MyrkviLexer.java MyrkviParser.java MyrkviParserVal.java tests/*.mexe
test:
	java MyrkviParser tests/test.test | java -jar morpho.jar -c
	java -jar morpho.jar tests/test
	java MyrkviParser tests/fibo.test | java -jar morpho.jar -c
	java -jar morpho.jar tests/fibo
	java MyrkviParser tests/fizzbuzz.test | java -jar morpho.jar -c
	java -jar morpho.jar tests/fizzbuzz
	java MyrkviParser tests/fact.test | java -jar morpho.jar -c
	java -jar morpho.jar tests/fact
	java MyrkviParser tests/bools.test | java -jar morpho.jar -c
	java -jar morpho.jar tests/bools