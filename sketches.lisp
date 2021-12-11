(in-package #:advent2021-sketch)

;; Day 5

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
                   do (with-pen (make-pen :fill (rgb 0 0 (/ (magicl:tref caves-map row col) 10)))
                        (circle (+ 10 (* (* 2 point-size) col))
                                (+ 10 (* (* 2 point-size) row)) point-size))))))

;; Day 11

(defsketch octopus-grid-sketch ((octopus-grid (read-octopus-grid))
                                (width 500)
                                (height 500)
                                (offset 100)
                                (point-size 18)
                                (counter 0))
  (background +black+)
  (let* ((shape (magicl:shape octopus-grid))
         (rows (first shape))
         (cols (second shape)))
    (loop for col from 0 below cols
          do (loop for row from 0 below rows
                   do (with-pen (make-pen :fill (gray (/ (magicl:tref octopus-grid row col) 10)))
                        (circle (+ offset (* (* 2 point-size) col))
                                (+ offset (* (* 2 point-size) row)) point-size)))))
  (with-font (make-font :color +white+ :size 30)
    (text (format nil "~a" counter) 10 10)))

(defmethod kit.sdl2:textinput-event ((window octopus-grid-sketch) ts text)
  (setf (slot-value window 'octopus-grid)
        (octopus-grid-step (slot-value window 'octopus-grid)))
  (incf (slot-value window 'counter)))
