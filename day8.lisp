(in-package #:advent2021)

(defun read-seven-segments-notes ()
  (loop for l in (uiop:read-file-lines (asdf:system-relative-pathname 'advent2021 "inputs/day8"))
        collect (mapcar (lambda (str)
                          (split " " str))
                        (split " \\| " l))))

(defun day8/solution1 ()
  (loop for note in (read-seven-segments-notes)
        sum (loop for output in (cdr note)
                  sum (loop for n in output
                            count (or (= (length n) 2)
                                      (= (length n) 4)
                                      (= (length n) 3)
                                      (= (length n) 7))))))

;;   0:      1:      2:      3:      4:
;;  aaaa    ....    aaaa    aaaa    ....
;; b    c  .    c  .    c  .    c  b    c
;; b    c  .    c  .    c  .    c  b    c
;;  ....    ....    dddd    dddd    dddd
;; e    f  .    f  e    .  .    f  .    f
;; e    f  .    f  e    .  .    f  .    f
;;  gggg    ....    gggg    gggg    ....
;;
;;   5:      6:      7:      8:      9:
;;  aaaa    aaaa    aaaa    aaaa    aaaa
;; b    .  b    .  .    c  b    c  b    c
;; b    .  b    .  .    c  b    c  b    c
;;  dddd    dddd    ....    dddd    dddd
;; .    f  e    f  .    f  e    f  .    f
;; .    f  e    f  .    f  e    f  .    f
;;  gggg    gggg    ....    gggg    gggg

(defparameter +digits-segments+
  '(("abcefg" . 0)
    ("cf" . 1)
    ("acdeg" . 2)
    ("acdfg" . 3)
    ("bcdf" . 4)
    ("abdfg" . 5)
    ("abdefg" . 6)
    ("acf" . 7)
    ("abcdefg" . 8)
    ("abcdfg" . 9)))

(defun digits-to-number (digits)
  (mapcar (lambda (d)
            (cdr (assoc d +DIGITS-SEGMENTS+ :test 'string=)))
          digits))

(defun translate (signals wiring)
  (let ((wires-mapping (make-hash-table)))
    (loop for w1 across wiring
          for w2 across "abcdefg"
          do (setf (gethash w1 wires-mapping) w2))
    (sort (coerce (loop for s across signals
                        collect (gethash s wires-mapping))
                  'string)
          #'char<)))

;; be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
(defun sensible-wiring (wiring notes)
  (loop for note in notes
        always (find (translate note wiring)
                     (mapcar #'first +DIGITS-SEGMENTS+)
                     :test #'string=)))

(defun day8/solution2 ()
  (let ((segments-notes (read-seven-segments-notes)))
    (loop with sensible-wiring
          for (notes digits) in segments-notes
          do (map-permutations (lambda (wiring)
                                 (when (sensible-wiring wiring notes)
                                   (setf sensible-wiring wiring)))
                               "abcdefg")
          sum (reduce (lambda (acc d)
                        (+ (* acc 10) d))
                      (DIGITS-TO-NUMBER
                       (mapcar (lambda (d)
                                 (translate d sensible-wiring))
                               digits))))))
