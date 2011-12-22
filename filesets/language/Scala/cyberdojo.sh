scalac -deprecation -cp .:./scalatest-1.6.1.jar *.scala
if [ $? -eq 0 ]; then
  scala -cp .:./scalatest-1.6.1.jar org.scalatest.tools.Runner -p . -oW
fi

