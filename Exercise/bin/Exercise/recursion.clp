
;---------- function add

(deffunction recursive-add-two (?a ?b)
(printout t "a: " ?a ", b: " ?b crlf)  
    (if (= ?b 0)
        then ?a
        else (
            recursive-add-two (+ ?a 1) (- ?b 1)
        )
    )
)

(bind ?result-add (recursive-add-two 5 3))
(printout t"result: " ?result-add crlf)


;---------- function multiply

(deffunction recursive-multiple-two (?a ?b)
(printout t "a: " ?a ", b: " ?b crlf)  
    (if (= ?b 1)
        then ?a
        else (+ ?a (recursive-multiple-two ?a (- ?b 1)))
    )
)

(bind ?result-multiple (recursive-multiple-two 5 3))
(printout t "result multiple: " ?result-multiple crlf)



