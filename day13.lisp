(in-package #:advent2021)

(defun points-to-grid (points-as-string)
  (let* ((points (mapcar (lambda (str)
                          (destructuring-bind (x y)
                              (split "," str)
                            (list (parse-integer x) (parse-integer y))))
                         (split "\\n" points-as-string)))
         (size-cols (+ 1 (apply #'max (mapcar #'first points))))
         (size-rows (+ 1 (apply #'max (mapcar #'second points))))
         (grid (magicl:empty (list size-rows size-cols))))
    (loop for (x y) in points
          do (setf (magicl:tref grid y x) 1))
    grid))

(defun read-transparent-paper ()
  (destructuring-bind (points fold-instructions)
      (split "\\n\\n" (uiop:read-file-string
                       (asdf:system-relative-pathname 'advent2021 "inputs/day13")))
    (values
     (points-to-grid points)
     (mapcar (lambda (fold-instr-line)
               (register-groups-bind (axis (#'parse-integer value))
                   ("fold along (\\w)=(\\d+)" fold-instr-line)
                 (list axis value)))
             (split "\\n" fold-instructions)))))

(defun print-paper (paper)
  (loop with (max-rows max-cols) = (magicl:shape paper)
        for row from 0 below max-rows
        do (loop for col from 0 below max-cols
                 do (format t "~a" (if (zerop (MAGICL:TREF paper row col))
                                       #\.
                                       #\#)))
           (format t "~%")))

(defun fold-x (paper x)
  (let* ((paper-shape (magicl:shape paper))
         (new-paper (magicl:empty (list (first paper-shape) x))))
    (loop for col2 from (- (second paper-shape) 1) downto (+ x 1)
          for col1 from (+ 1 (- (* 2 x) (second paper-shape))) below x
          do (loop for row from 0 below (first paper-shape)
                   do (setf (magicl:tref new-paper row col1)
                            (clamp (+ (magicl:tref paper row col1)
                                      (magicl:tref paper row col2))
                                   0 1))))
    new-paper))

(defun fold-y (paper y)
  (magicl:transpose (fold-x (magicl:transpose paper) y)))

(defun day13/solution1 ()
  (multiple-value-bind (paper fold-instructions)
      (read-transparent-paper)
    (setf paper (cond
                  ((string= "x" (first (first fold-instructions)))
                   (fold-x paper (second (first fold-instructions))))
                  ((string= "y" (first (first fold-instructions)))
                   (fold-y paper (second (first fold-instructions))))))
    (let ((counter 0))
      (loop for col from 0 below (second (magicl:shape paper))
            do (loop for row from 0 below (first (magicl:shape paper))
                     when (= 1 (magicl:tref paper row col))
                       do (incf counter)))
      counter)))

(defun day13/solution2 ()
  (multiple-value-bind (paper fold-instructions)
      (read-transparent-paper)
    (loop for counter from 0
          for (axis value) in fold-instructions
          do (setf paper (cond
                           ((string= "x" axis) (fold-x paper value))
                           ((string= "y" axis) (fold-y paper value)))))
    ;; (print-paper paper)
    "UCLZRAZU"))

