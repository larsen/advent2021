(in-package #:advent2021)

(defun read-caves-map ()
  (let* ((raw-map (loop for l in (uiop:read-file-lines
                                  (asdf:system-relative-pathname
                                   'advent2021 "inputs/day9"))
                        collect (split "" l)))
         (rows (length raw-map))
         (cols (length (first raw-map))))
    (magicl:from-list (mapcar #'parse-integer
                              (loop for r in raw-map
                                    append r))
                      (list rows cols))))

(defun neighbours (row col grid)
  (loop for (dx dy) in '((0 -1) (-1 0) (0 1) (1 0))
        when (handler-case
                 (magicl:tref grid (+ row dx) (+ col dy))
               (condition () nil))
        collect (list (+ row dx) (+ col dy))))

(defun is-low-point-p (row col caves-map)
  (loop with height = (magicl:tref caves-map row col)
        for neighbour in (neighbours row col caves-map)
        always (> (magicl:tref caves-map
                               (first neighbour)
                               (second neighbour))
                  height)))

(defun day9/solution1 ()
  (let* ((caves-map (read-caves-map))
         (rows (first (magicl:shape caves-map)))
         (cols (second (magicl:shape caves-map))))
    (reduce #'+ (loop for col from 0 below cols
                      append (loop for row from 0 below rows
                                   when (is-low-point-p row col caves-map)
                                     collect (+ 1 (magicl:tref caves-map row col)))))))

(defun expand-low-point (low-point caves-map)
  (loop with basin = (list low-point)
        with n-added-points = 0
        do (setf n-added-points 0)
           (loop for (p-row p-col) in basin
                 do (loop for (n-row n-col) in (neighbours p-row p-col caves-map)
                          when (and (/= 9 (magicl:tref caves-map n-row n-col))
                                    (not (find (list n-row n-col) basin :test 'equalp)))
                            do (push (list n-row n-col) basin)
                               (incf n-added-points)
                          finally (return n-added-points)))
        when (zerop n-added-points)
          return basin))

(defun day9/solution2 ()
  (let* ((caves-map (read-caves-map))
         (rows (first (magicl:shape caves-map)))
         (cols (second (magicl:shape caves-map)))
         (low-points '()))

    ;; Collect all low-points
    (loop for col from 0 below cols
          append (loop for row from 0 below rows
                       when (is-low-point-p row col caves-map)
                         do (push (list row col) low-points)))

    (reduce #'* (subseq (sort
                         ;; Compute basins
                         (loop for low-point in low-points
                               collect (length (expand-low-point low-point caves-map)))
                         #'>)
                        0 3))))
