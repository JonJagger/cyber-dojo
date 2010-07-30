(ns your-test-namespace
   (:use clojure.test))

(deftest test-adder
  (is (= 24  (add2 22))))

(run-all-tests)
