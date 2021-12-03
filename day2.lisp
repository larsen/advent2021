(in-package #:advent2021)

(defclass submarine ()
  ((horizontal-position :initform 0 :accessor hpos)
   (depth :initform 0 :accessor depth)
   (aim :initform 0 :accessor aim)))

(defgeneric forward (entity n))
(defmethod forward ((s submarine) n)
  (incf (hpos s) n)
  (incf (depth s) (* (aim s) n)))

(defgeneric down (entity n))
(defmethod down ((s submarine) n)
  (incf (aim s) n))

(defgeneric up (entity n))
(defmethod up ((s submarine) n)
  (decf (aim s) n))

(defun find-function-in-package (function-name package)
  "Given a string FUNCTION-NAME and a PACKAGE, returns the function
object corresponding to that function in the package. If the function
does not exist it generates an error."
  (symbol-function (find-symbol (string-upcase function-name) package)))

(defgeneric execute-instructions (entity instructions))
(defmethod execute-instructions ((s submarine) instructions)
  (loop for (cmd param) in instructions
        do (funcall (find-function-in-package cmd :advent2021)
                    s param)
        finally (return s)))

(defun read-course ()
  (loop for l in (uiop:read-file-lines
                  (asdf:system-relative-pathname 'advent2021 "inputs/day2"))
        collect (destructuring-bind (command param)
                    (split "\\s+" l)
                  (list command (parse-integer param)))))

;; https://www.reddit.com/r/adventofcode/comments/r6zd93/2021_day_2_solutions/hmyblm9/?utm_source=reddit&utm_medium=web2x&context=3

(defun day2/solution1 ()
  (let ((subm (make-instance 'submarine)))
    (execute-instructions subm (read-course))
    (* (hpos subm)
       (aim subm))))

(defun day2/solution2 ()
  (let ((subm (make-instance 'submarine)))
    (execute-instructions subm (read-course))
    (* (hpos subm)
       (depth subm))))
