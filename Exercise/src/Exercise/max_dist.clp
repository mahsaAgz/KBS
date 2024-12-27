
; ----- Temps
(reset)
;(watch all)
(deftemplate coordinate
    (slot x)
    (slot y)
)
(deftemplate distance
    (slot dist)
)
(deftemplate max-distance
    (slot max-dist (type INTEGER))
    
)

(deftemplate max-coordinate-pair

    (slot x1)
    (slot y1)
    (slot x2)
    (slot y2)
)(do-backward-chaining max-coordinate-pair)

; -----  Data

(assert (coordinate (x 0)(y 0)))
(assert (coordinate (x 3)(y 4)))
(assert (coordinate (x 2)(y 2)))
(assert (coordinate (x -1)(y 5)))
(assert (coordinate (x 3)(y -6)))
(assert (max-distance  (max-dist 0)))

; ----- Rules

(defrule calculate-distance
    (coordinate (x ?x1)(y ?y1))
    (coordinate (x ?x2)(y ?y2))
=>
    (bind ?dist-temp (sqrt (+ (* (- ?x1 ?x2) (- ?x1 ?x2))(* (- ?y1 ?y2) (- ?y1 ?y2)))))
    (assert (distance (dist ?dist-temp)))
)



(defrule calculate-max-distance
    (distance (dist ?dist))
    ?max-distance <- (max-distance (max-dist ?max))
    (test (> ?dist ?max))
=>
    (modify ?max-distance (max-dist ?dist))
    (printout t "Maximum distance found: " ?dist crlf)
)



(defrule find-max-coordinate-pair
    (declare (salience -10))
    (max-coordinate-pair (x1 ?)(y1 ?)(x2 ?)(y2 ?));(max-dist ?max-dist))
    (max-distance (max-dist ?max-dist))
    (coordinate (x ?x1)(y ?y1))
    (coordinate (x ?x2)(y ?y2))
    (test (= ?max-dist (sqrt (+ (* (- ?x1 ?x2) (- ?x1 ?x2)) (* (- ?y1 ?y2) (- ?y1 ?y2))))))
=>
    (assert (max-coordinate-pair (x1 ?x1)(y1 ?y1)(x2 ?x2)(y2 ?y2)))
)





(defrule print-max-coordinate-pair
    (declare (salience -20))
    (max-distance (max-dist ?max-dist))
    (max-coordinate-pair (x1 ?x1)(y1 ?y1)(x2 ?x2)(y2 ?y2))
=>
    (printout t "The max coordinate pair is (" ?x1 ", " ?y1 ") and (" ?x2 ", " ?y2 ")." crlf)
)


;(defrule do-factorial
;    (need-factorial ?n ?)
;=>
;    (bind ?result 1)
;    (bind ?x ?n)
;    (while (> ?x 1)
;        (bind ?result (* ?result ?x))
;        (bind ?x (- ?x 1))
;    )
;    (assert (factorial ?n ?result))
;)
