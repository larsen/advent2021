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
  (background +yellow+)

  (let* ((shape (magicl:shape caves-map))
         (rows (first shape))
         (cols (second shape))
         (point-size 10)
         (basin '((0 9))))

    ;; draw map
    (loop for col from 0 below cols
          do (loop for row from 0 below rows
                   do (with-pen (make-pen :fill (gray (/ (magicl:tref caves-map row col) 10)))
                        (circle (+ 10 (* (* 2 point-size) col))
                                (+ 10 (* (* 2 point-size) row)) point-size))))

    ;; extend basin
    (loop with n-added-points
          do (setf n-added-points 0)
             (loop for (p-row p-col) in basin
                   do (loop for (n-row n-col) in (neighbours p-row p-col caves-map)
                            when (and (/= 9 (magicl:tref caves-map n-row n-col))
                                      (not (find (list n-row n-col) basin :test 'equalp)))
                              do (push (list n-row n-col) basin)
                                 (incf n-added-points)
                            finally (return n-added-points)))
          when (zerop n-added-points)
            return basin)

    ;; paint basin
    ;; (loop for (row col) in basin
    ;;       do (with-pen water-pen
    ;;            (circle (+ 10 (* (* 2 point-size) col))
    ;;                    (+ 10 (* (* 2 point-size) row)) point-size)))
    ))
