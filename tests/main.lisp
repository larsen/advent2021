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
  (is = (day4/solution1) 71708)
  (is = (day4/solution2) 34726))

(define-test day5
  (is = (day5/solution1) 6710)
  (is = (day5/solution2) 20121))

(define-test day6
  (is = (day6/solution1) 386755)
  (is = (day6/solution2) 1732731810807))

(define-test day7
  (is = (day7/solution1) 356922)
  (is = (day7/solution2) 100347031))

(define-test day8
  (is = (day8/solution1) 440)
  (is = (day8/solution2) 1046281))

(define-test day9
  (is = (day9/solution1) 560)
  (is = (day9/solution2) 959136))

(define-test day10
  (is = (day10/solution1) 370407)
  (is = (day10/solution2) 3249889609))

(define-test day11
  (is = (day11/solution1) 1757)
  (is = (day11/solution2) 422))
