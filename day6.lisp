(in-package #:advent2021)


(defun read-school ()
  (mapcar #'parse-integer
          (split ","
                 (uiop:read-file-string
                  (asdf:system-relative-pathname 'advent2021 "inputs/day6")))))

(defun tick-recursive (population)
  (cond
    ((null population) '())
    ((> (car population) 0)
     (concatenate 'list (list (- (car population) 1)) (tick-recursive (cdr population))))
    ((= 0 (car population))
     (concatenate 'list '(6) '(8) (tick-recursive (cdr population))))))

(defun tick-iterative (population)
  (loop for p in population
        when (= p 0)
          collect 6 and collect 8
        when (> p 0)
          collect (- p 1)))

(defun evolve-population (population n)
  (loop repeat n
        do (setf population (tick-iterative population))
        finally (return (length population))))

(defun evolve-population-age-array (population-age)
  (let ((new-population-age (make-array 9)))
    (loop for idx from 1 to 8
                   do (setf (aref new-population-age (- idx 1))
                            (aref population-age idx)))
    (setf (aref new-population-age 8) (aref population-age 0))
    (incf (aref new-population-age 6) (aref population-age 0))
    new-population-age))

(defun day6/solution1 ()
  (evolve-population (read-school) 80))

(defun day6/solution2 ()
  (let ((population-age (make-array 9)))
    (loop for p in (read-school)
          do (incf (aref population-age p)))
    (loop repeat 256
          do (setf population-age (evolve-population-age-array population-age)))
    (reduce #'+ population-age)))
