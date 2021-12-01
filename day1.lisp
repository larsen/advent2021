(in-package #:advent2021)

(defun read-sonar-sweep ()
  (mapcar #'parse-integer
          (uiop:read-file-lines
           (asdf:system-relative-pathname 'advent2021 "inputs/day1"))))

(defun day1/solution1 ()
  (let ((sonar-sweeps (read-sonar-sweep)))
    (loop for couple in (loop for i from 1 below (length sonar-sweeps)
                              collect (cons (nth (- i 1) sonar-sweeps)
                                            (nth i sonar-sweeps)))
          when (> (cdr couple)
                  (car couple))
            count couple)))
