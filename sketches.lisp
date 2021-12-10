(in-package #:advent2021-sketch)

;; Day

(defsketch ocean-floor ((vents (read-vents))
                        (width 1000)
                        (height 1000))
  (background (rgb 0 0 0.3))
  (with-pen (make-pen :stroke (rgb 1 0 1))
    (loop for (p1 p2) in vents
          do (line (vx p1) (vy p1)
                   (vx p2) (vy p2)))))

;; Day 9

(defsketch caves ((caves-map (read-caves-map))
                  (water-pen (make-pen :fill +blue+)))
  (background +black+)

  (let* ((shape (magicl:shape caves-map))
         (rows (first shape))
         (cols (second shape))
         (point-size 3)
         (low-points '())
         (basin '()))

    ;; draw map
    (loop for col from 0 below cols
          do (loop for row from 0 below rows
                   do (with-pen (make-pen :fill (gray (/ (magicl:tref caves-map row col) 10)))
                        (circle (+ 10 (* (* 2 point-size) col))
                                (+ 10 (* (* 2 point-size) row)) point-size))))

    ;; Collect all low-points
    (loop for col from 0 below cols
          append (loop for row from 0 below rows
                       when (is-low-point-p row col caves-map)
                         do (push (list row col) low-points)))

    (loop for lp in low-points
          do (setf basin (expand-low-point lp caves-map))
             (loop for (row col) in basin
                   do (with-pen water-pen
                        (circle (+ 10 (* (* 2 point-size) col))
                                (+ 10 (* (* 2 point-size) row)) point-size))))))
