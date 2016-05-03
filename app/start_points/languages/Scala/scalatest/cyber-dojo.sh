rm -f *.class
CLASSES=.:`ls /scalatest/*.jar | tr '\n' ':'`
scalac -cp $CLASSES  *.scala
scala -cp $CLASSES org.scalatest.tools.Runner -oW -s HikerSuite
