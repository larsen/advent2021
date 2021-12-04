(in-package #:advent2021)

(defclass bingo-card ()
  ((numbers :initarg :numbers :accessor numbers)
   (marked-numbers :initarg :marked-numbers :accessor marked-numbers)))

(defun new-bingo-card (numbers)
  (make-instance 'bingo-card
                 :numbers (magicl:from-list numbers '(5 5))
                 :marked-numbers (magicl:from-list (loop repeat 25 collect 0) '(5 5))))

(defmethod print-object ((card bingo-card) stream)
  (loop for row from 0 below 5
        do (loop for col from 0 below 5
                 do (format stream "~a~2,' d "
                            (if (= 1 (magicl:tref (marked-numbers card) row col)) #\* #\Space)
                            (magicl:tref (numbers card) row col)))
           (format stream "~%")))

(defmethod mark ((card bingo-card) n)
  (loop for row from 0 below 5
        do (loop for col from 0 below 5
                 when (= n (magicl:tref (numbers card) row col))
                   do (setf (magicl:tref (marked-numbers card) row col) 1))))

(defmethod reset-markers ((card bingo-card))
  (setf (marked-numbers card) (magicl:from-list (loop repeat 25 collect 0) '(5 5))))

(defmethod %winner-p ((card bingo-card) &key (check :rows))
  (let ((marked-numbers-to-check (if (eq check :rows)
                                     (marked-numbers card)
                                     (magicl:transpose (marked-numbers card)))))
    (loop for row from 0 below 5
            thereis (loop for col from 0 below 5
                          always (= 1 (magicl:tref marked-numbers-to-check row col))))))

(defmethod winner-p ((card bingo-card))
  (or (%winner-p card :check :rows)
      (%winner-p card :check :cols)))

(defmethod unmarked-numbers ((card bingo-card))
  (loop for row from 0 below 5
        append (loop for col from 0 below 5
                     when (= 0 (magicl:tref (marked-numbers card) row col))
                       collect (magicl:tref (numbers card) row col))))

(defun read-bingo-game ()
  (destructuring-bind (drafted-numbers &rest cards)
      (split "\\n\\n"
             (uiop:read-file-string
              (asdf:system-relative-pathname 'advent2021 "inputs/day4")))
    (values
     (mapcar #'parse-integer (split "," drafted-numbers))
     (loop for card in cards
           collect (new-bingo-card (mapcar #'parse-integer (split "\\s+" (string-trim " " card))))))))

(defun game-winner-p (bingo-cards)
  (loop for c in bingo-cards
        when (winner-p c)
          return c))

(defun score (n winner-card)
  (* n (reduce #'+ (unmarked-numbers winner-card))))

(defun day4/solution1 ()
  (multiple-value-bind (drafted-numbers bingo-cards)
      (read-bingo-game)
    (loop for n in drafted-numbers
          do (loop for c in bingo-cards do (mark c n))
          when (game-winner-p bingo-cards)
            return (score n (game-winner-p bingo-cards)))))

(defun day4/solution2 ()
  (let ((winners '()))
    (multiple-value-bind (drafted-numbers bingo-cards)
        (read-bingo-game)
      (loop for n in drafted-numbers
            do (loop for c in bingo-cards do (mark c n)
                     when (winner-p c)
                       do (push (list n c) winners))
               (setf bingo-cards (delete-if #'winner-p bingo-cards))
            finally (let ((last-winner-and-winning-number (car winners)))
                      (return (score (first last-winner-and-winning-number)
                                     (second last-winner-and-winning-number))))))))
