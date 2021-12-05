(in-package #:advent2021-sketch)

(defsketch ocean-floor ((vents (read-vents))
                        (width 1000)
                        (height 1000))
  (background (rgb 0 0 0.3))
  (with-pen (make-pen :stroke (rgb 1 0 1))
    (loop for (p1 p2) in vents
          do (line (vx p1) (vy p1)
                   (vx p2) (vy p2)))))
