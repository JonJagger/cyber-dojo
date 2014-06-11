
(ns hiker
  (:use clojure.test))

(deftest test-life-the-universe-and-everything
  (is (= (42)  (answer))))

(run-all-tests #"hiker")
