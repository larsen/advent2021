(in-package #:advent2021)

(defun read-course ()
  (loop for l in (uiop:read-file-lines
                  (asdf:system-relative-pathname 'advent2021 "inputs/day2"))
        collect (destructuring-bind (command param)
                    (split "\\s+" l)
                  (list command (parse-integer param)))))

(defun day2/solution1 ()
  (loop with depth = 0
        with horizontal-position = 0
        for cmd in (read-course)
        do (cond
             ((string= "forward" (first cmd)) (incf horizontal-position (second cmd)))
             ((string= "down" (first cmd)) (incf depth (second cmd)))
             ((string= "up" (first cmd)) (decf depth (second cmd))))
        finally (return (* horizontal-position
                           depth))))

(defun day2/solution2 ()
  (loop with depth = 0
        with horizontal-position = 0
        with aim = 0
        for cmd in (read-course)
        do (cond
             ((string= "forward" (first cmd))
              (progn (incf horizontal-position (second cmd))
                     (incf depth (* aim (second cmd)))))
             ((string= "down" (first cmd)) (incf aim (second cmd)))
             ((string= "up" (first cmd)) (decf aim (second cmd))))
        finally (return (* horizontal-position
                           depth))))
