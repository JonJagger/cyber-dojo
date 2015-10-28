CLJ_FILES=`ls *.clj | grep -v 'test' | tr '\n' ' '`
TEST_CLJ_FILES=`ls *.clj | grep 'test' | tr '\n' ' '`
java -cp /clojure/clojure-1.4.0.jar:. -Dclojure.compile.path=. clojure.main -i $CLJ_FILES $TEST_CLJ_FILES
