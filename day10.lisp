(in-package #:advent2021)

(defun read-navigation-subsystem ()
  (uiop:read-file-lines (asdf:system-relative-pathname 'advent2021 "inputs/day10")))

(defparameter delimiters
  '((#\( . #\))
    (#\[ . #\])
    (#\{ . #\})
    (#\< . #\>)))

(defparameter delimiter-score
  '((#\) . 3)
    (#\] . 57)
    (#\} . 1197)
    (#\> . 25137)))

(defparameter delimiter-autocomplete-score
  '((#\( . 1)
    (#\[ . 2)
    (#\{ . 3)
    (#\< . 4)))

(defun corruption-score (line)
  (let ((score 0))
    (loop with stack = '()
          for c across line
          when (find c (mapcar #'car delimiters))
            do (push c stack)
          when (and (find c (mapcar #'cdr delimiters))
                    (char/= c (cdr (assoc (pop stack) delimiters))))
            do (incf score (cdr (assoc c delimiter-score)))
          finally (return score))))

(defun day10/solution1 ()
  (let ((navigation-susystem (read-navigation-subsystem))
        (total-score 0))
    (loop for line in navigation-susystem
          do (incf total-score (corruption-score line)))
    total-score))

(defun autocomplete-score (line)
  (let ((stack '()))
    (loop for c across line
          when (find c (mapcar #'car delimiters))
            do (push c stack)
          when (find c (mapcar #'cdr delimiters))
            do (pop stack))
    (reduce (lambda (acc score)
              (+ (* acc 5) score))
            (loop for delimiter in stack
                  collect (cdr (assoc delimiter delimiter-autocomplete-score))))))

(defun day10/solution2 ()
  (let* ((navigation-susystem (read-navigation-subsystem))
         (scores (sort (loop for line in navigation-susystem
                             when (zerop (corruption-score line))
                               collect (autocomplete-score line))
                       #'>)))
    (median scores)))
