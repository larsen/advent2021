(in-package #:advent2021)

(defun read-csv-line (filename)
  (mapcar #'parse-integer
          (split "," (uiop:read-file-string filename))))

(defun triangular (n)
  (* 1/2 n (+ n 1)))
