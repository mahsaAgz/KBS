(deftemplate factorial
    (slot number)
    (slot result (default 0))
)

(defrule calculate-factorial
    ?fact<- (factorial (number ?number))
    =>
    (bind ?result 1)
    (while (> ?number 1)
        (bind ?result (* ?result ?number))
        (bind ?number (- ?number 1))
    )
    (modify ?fact (result ?result))
    
)

(assert(factorial (number 5)))
(assert(factorial (number 3)))
