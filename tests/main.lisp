(in-package #:advent2021/test)

(define-test day1
  (is = (day1/solution1) 1400)
  (is = (day1/solution2) 1429))

(define-test day2
  (is = (day2/solution1) 2019945)
  (is = (day2/solution2) 1599311480))
