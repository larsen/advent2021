(in-package #:advent2021)

(defun read-sonar-sweep ()
  (mapcar #'parse-integer
          (uiop:read-file-lines
           (asdf:system-relative-pathname 'advent2021 "inputs/day1"))))

(defun count-increasing-values (numbers)
  (loop for couple in (zip #'cons numbers (cdr numbers))
        when (> (cdr couple)
                (car couple))
          count couple))

(defun zip (f &rest lists)
  (apply #'mapcar f lists))

(defun day1/solution1 ()
  (count-increasing-values (read-sonar-sweep)))

(defun day1/solution2 ()
  (let ((sonar-sweeps (read-sonar-sweep)))
    (count-increasing-values
     (zip #'+
          sonar-sweeps
          (cdr sonar-sweeps)
          (cdr (cdr sonar-sweeps))))))


