(in-package #:advent2021/test)

(define-test day1
  (is = (day1/solution1) 1400)
  (is = (day1/solution2) 1429))

(define-test day2
  (is = (day2/solution1) 2019945)
  (is = (day2/solution2) 1599311480))

(define-test day3
  (is = (day3/solution1) 852500)
  (is = (day3/solution2) 1007985))

(define-test day4
  (is = (day4/solution1) 71708))
