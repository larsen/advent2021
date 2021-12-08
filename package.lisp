(defpackage #:advent2021
  (:use #:cl #:cl-ppcre #:alexandria #:split-sequence)
  (:export day1/solution1
           day1/solution2
           day2/solution1
           day2/solution2
           day3/solution1
           day3/solution2
           day4/solution1
           day4/solution2

           read-vents
           vx
           vy
           day5/solution1
           day5/solution2

           day6/solution1
           day6/solution2
           day7/solution1
           day7/solution2
           day8/solution1
           day8/solution2))


(defpackage #:advent2021-sketch
  (:use #:cl #:advent2021 #:sketch))
