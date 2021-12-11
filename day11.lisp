(in-package #:advent2021)

(defun read-octopus-grid ()
  (magicl:from-list
   (mapcar #'parse-integer
           (loop for line in (uiop:read-file-lines
                               (asdf:system-relative-pathname 'advent2021 "inputs/day11"))
                 append (split "" line)))
   '(10 10)))

(defun octopus-neighbours (row col grid)
  (loop for (dx dy) in '((-1 -1) (+0 -1) (+1 -1)
                         (-1 +0)         (+1 +0)
                         (-1 +1) (+0 +1) (+1 +1))
        when (handler-case
                 (magicl:tref grid (+ row dy) (+ col dx))
               (condition () nil))
          collect (list (+ row dy) (+ col dx))))

(defun octopus-grid-step (octopus-grid)
  (let ((new-octopus-grid (magicl:deep-copy-tensor octopus-grid))
        (flashed (magicl:copy-tensor octopus-grid))
        (total-flashes 0)
        (flashes 0))

    (magicl:map! #'1+ new-octopus-grid)

    (loop do (setf flashes 0)
             (loop for col from 0 below 10
                   do (loop for row from 0 below 10
                            when (and (> (magicl:tref new-octopus-grid row col) 9)
                                      (/= 1 (magicl:tref flashed row col)))
                              do (incf total-flashes)
                                 (incf flashes)
                                 (setf (magicl:tref flashed row col) 1)
                                 (loop for (n-row n-col) in (octopus-neighbours row col new-octopus-grid)
                                       do (incf (magicl:tref new-octopus-grid n-row n-col)))))
          until (zerop flashes))

    (magicl:map! (lambda (elem)
                   (if (> elem 9)
                       0
                       elem)) new-octopus-grid)

    (values new-octopus-grid total-flashes)))

(defun day11/solution1 ()
  (let ((octopus-grid (read-octopus-grid))
        (total-flashes 0))
    (loop repeat 100
          do (multiple-value-bind (new-grid flashes)
                 (octopus-grid-step octopus-grid)
               (incf total-flashes flashes)
               (setf octopus-grid new-grid))
          finally (return total-flashes))))

(defun all-grid-elems (grid)
  (loop with (maxrow maxcol) = (magicl:shape grid)
        for col from 0 below maxcol
        append (loop for row from 0 below maxrow
                     collect (magicl:tref grid row col))))

(defun day11/solution2 ()
  (loop for counter from 0
        for octopus-grid = (read-octopus-grid) then (octopus-grid-step octopus-grid)
        until (= 100 (count 0 (all-grid-elems octopus-grid)))
        finally (return counter)))
