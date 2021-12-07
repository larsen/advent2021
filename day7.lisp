(in-package #:advent2021)

(defun read-crabs-positions ()
  (mapcar #'parse-integer
          (split ","
                 (uiop:read-file-string
                  (asdf:system-relative-pathname 'advent2021 "inputs/day7")))))

(defun day7/solution1 ()
  (let* ((crabs (read-crabs-positions))
         (median (median crabs)))
    (reduce #'+ (mapcar (lambda (c)
                          (abs (- c median)))
                        crabs))))

(defun triangular (n)
  (* 1/2 n (+ n 1)))

(defun day7/solution2 ()
  (let* ((crabs (read-crabs-positions))
         (min (apply #'min crabs))
         (max (apply #'max crabs)))
    (loop for d from min to max
          minimizing (reduce #'+ (mapcar (lambda (c)
                                           (triangular (abs (- c d))))
                                         crabs)))))
