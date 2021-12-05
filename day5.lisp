(in-package #:advent2021)

(defun read-vents ()
  (loop for line in (uiop:read-file-lines
                     (asdf:system-relative-pathname 'advent2021 "inputs/day5"))
        collect (register-groups-bind ((#'parse-integer x1 y1 x2 y2))
                    ("(\\d+),(\\d+) -> (\\d+),(\\d+)" line)
                  (list (vector x1 y1)
                        (vector x2 y2)))))

(defun vx (v) (aref v 0))
(defun vy (v) (aref v 1))

(defun leftmost-point-first (segment)
  (let ((x1 (vx (first segment)))
        (x2 (vx (second segment))))
    (if (< x1 x2)
        segment
        (reverse segment))))

(defun straightp (segment)
  (or (= (vx (first segment))
         (vx (second segment)))
      (= (vy (first segment))
         (vy (second segment)))))

(defun plot-vents (segment ocean-floor)
  (let ((x1 (vx (first segment)))
        (y1 (vy (first segment)))
        (x2 (vx (second segment)))
        (y2 (vy (second segment))))
    (cond ((= x1 x2) (loop for y from (min y1 y2) to (max y1 y2)
                       do (incf (gethash (vector x1 y) ocean-floor 0))))
          ((= y1 y2) (loop for x from (min x1 x2) to (max x1 x2)
                           do (incf (gethash (vector x y1) ocean-floor 0))))
          (t (let ((ordered-segment (leftmost-point-first segment)))
               (if (> (vy (second ordered-segment))
                      (vy (first ordered-segment)))
                   (loop for x from (vx (first ordered-segment)) to (vx (second ordered-segment))
                         for y from (vy (first ordered-segment)) to (vy (second ordered-segment))
                         do (incf (gethash (vector x y) ocean-floor 0)))
                   (loop for x from (vx (first ordered-segment)) to (vx (second ordered-segment))
                         for y from (vy (first ordered-segment)) downto (vy (second ordered-segment))
                           do (incf (gethash (vector x y) ocean-floor 0)))))))))

(defun day5/solution1 ()
  (let ((ocean-floor (make-hash-table :test 'equalp)))
    (loop for segment in (read-vents)
          when (straightp segment)
            do (plot-vents segment ocean-floor))
    (loop for v being the hash-values of ocean-floor
          count (>= v 2))))

(defun day5/solution2 ()
  (let ((ocean-floor (make-hash-table :test 'equalp)))
    (loop for segment in (read-vents)
            do (plot-vents segment ocean-floor))
    (loop for v being the hash-values of ocean-floor
          count (>= v 2))))
