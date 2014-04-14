
(ns untitled
  (:use clojure.test))
  
(deftest test-answer
  (is (= (* 6 9)  (answer))))

(run-all-tests #"untitled")

