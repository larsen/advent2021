(in-package #:advent2021)

(defun day7/solution1 ()
  (let* ((crabs (read-csv-line (asdf:system-relative-pathname 'advent2021 "inputs/day7")))
         (median (median crabs)))
    (reduce #'+ (mapcar (lambda (c)
                          (abs (- c median)))
                        crabs))))

(defun day7/solution2 ()
  (let* ((crabs (read-csv-line (asdf:system-relative-pathname 'advent2021 "inputs/day7")))
         (min (apply #'min crabs))
         (max (apply #'max crabs)))
    (loop for d from min to max
          minimizing (reduce #'+ (mapcar (lambda (c)
                                           (triangular (abs (- c d))))
                                         crabs)))))
