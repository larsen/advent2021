;;;; advent2021.asd

(asdf:defsystem #:advent2021
  :description "Describe advent2021 here"
  :author "Stefano Rodighiero <stefano.rodighiero@gmail.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:alexandria #:cl-ppcre #:split-sequence #:magicl #:sketch)
  :components ((:file "package")
               (:file "day1")
               (:file "day2")
               (:file "day3")
               (:file "day4")
               (:file "day5")
               (:file "sketches"))
  :in-order-to ((test-op (test-op #:advent2021/test))))

(asdf:defsystem #:advent2021/test
  :depends-on (#:advent2021
               #:parachute)
  :components ((:module "tests"
                :components ((:file "package")
                             (:file "main"))))
  :perform (test-op (op _) (symbol-call :parachute :test :advent2021/test)))
