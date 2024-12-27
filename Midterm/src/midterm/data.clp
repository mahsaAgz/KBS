(deftemplate bid
    (slot id)
    (slot cost)
)
(deftemplate lowest
    (slot id)
    (slot cost)
)
(deftemplate second-lowest
    (slot id)
    (slot cost)
)

(assert (bid (id 1) (cost 5)))
(assert (bid (id 1) (cost 4)))
(assert (bid (id 1) (cost 6)))
(assert (bid (id 1) (cost 1)))
(assert (bid (id 1) (cost 2)))

(deffacts initial
  (lowest (id 0) (cost 999999))
  (second-lowest (id 0) (cost 999999))
)
(defrule find-second-lowest
    (bid (id ?id) (cost ?cost))
    ?lowest-fact <- (lowest (cost ?lowest-cost))
    (test (< ?cost ?lowest-cost))
    =>
    (modify ?lowest-fact (cost ?cost))
)
 
(defrule find-second-lowest
  (declare (saliance -10))
  (bid (id ?id) (cost ?cost))
  ?lowest-fact <- (lowest (cost ?lowest-cost))
  ?second-lowest-fact <- (second-lowest (cost ?second-lowest-cost))
  (test (and (< ?cost ?second-lowest-cost) (> ?cost ?lowest-cost)))
  =>
  (modify ?second-lowest-fact (cost ?cost))
)
