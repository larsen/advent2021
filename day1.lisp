(in-package #:advent2021)

(defun read-sonar-sweep ()
  (mapcar #'parse-integer
          (uiop:read-file-lines
           (asdf:system-relative-pathname 'advent2021 "inputs/day1"))))

(defun count-increasing-values (numbers)
  (loop for couple in (loop for i from 1 below (length numbers)
                            collect (cons (nth (- i 1) numbers)
                                          (nth i numbers)))
        when (> (cdr couple)
                (car couple))
          count couple))

(defun day1/solution1 ()
  (count-increasing-values (read-sonar-sweep)))

(defun day1/solution2 ()
  (let ((sonar-sweeps (read-sonar-sweep)))
    (count-increasing-values
     (loop for i from 2 below (length sonar-sweeps)
           collect (+ (nth (- i 2) sonar-sweeps)
                      (nth (- i 1) sonar-sweeps)
                      (nth i sonar-sweeps))))))
