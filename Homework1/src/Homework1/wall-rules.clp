;  REQUIREMENT SPECIFICATION RULE
;
; This rule looks to see if a set of requirements has been given. 
; If none is present, it creates a wall-requirements object and
; fills in the slots by querying the user.
;
(defrule wall-requirements-rule-1
	(not (wall-requirements))
=>
	(format t "%nNo specification for the wall has been given.%n")
;	format t: This specifies that the output will be printed to the terminal (t means terminal output).
	(format t "%nWhat is the project name?%n (quoted string)> ")
	(bind ?project-name (read))
	(format t "%nWhat is the desired fire resistance?%n (in hours)> ")
	(bind ?fr (read))
	(format t "%nWhat is the desired thermal resistance?%n (in F/BTU/h/ft^2)> ")
	(bind ?tr (read))
	(format t "%nWhat is the desired condensation risk?")
	(format t "%n(none, negligible, low, high)> ")
	(bind ?cr (read))
	(format t "%nWhat is the desired sound transmission loss?%n (in dB)> ")
	(bind ?str (read))
	(format t "%nWhat is the desired exterior material?")
	(format t "%n(no-preference, Wood, Steel, Aluminum, Cement, Brick)> ")
	(bind ?ex_m (read))
	(format t "%n")
	(assert (wall-requirements
		  (project-name ?project-name)
		  (fire-resistance ?fr)
		  (thermal-resistance ?tr)
		  (sound-transmission-loss ?str)
		  (condensation-risk ?cr)
		  (exterior-material ?ex_m)
		     )
	)
)

;  WALL SELECTION RULE 1
;
; This rule searches for a wall section that meets the requirements
; specified in the requirements object and identifies the wall section
; as a viable alternative
;
;  WALL SELECTION RULE 1
;
; This rule searches for a wall section that meets the requirements
; specified in the requirements object and identifies the wall section
; as a viable alternative
;

(defrule wall-selection-rule-1
;
; What are the wall requirements?
;
	(wall-requirements 	
	  (fire-resistance ?reqd-fr)
  	  (thermal-resistance ?reqd-tr)
	  (condensation-risk ?reqd-cr)
	  (sound-transmission-loss ?reqd-stl)
	  (exterior-material ?reqd-ext-mat) ; Add exterior material requirement
	)
;
; Are fire, thermal, sound, and material requirements satisfied by wall section?
;
 	(wall-section 	
	  (id ?id)
	  (description ?description)
	  (fire-resistance ?fr&:(>= ?fr ?reqd-fr))
	  (thermal-resistance ?tr&:(>= ?tr ?reqd-tr))
	  (sound-transmission-loss ?str&:(>= ?str ?reqd-stl))
	  (condensation-risk ?cr)
	  (exterior-material ?ext-mat&:(or (eq ?ext-mat ?reqd-ext-mat) (eq ?reqd-ext-mat no-preference)))
	  (cost ?cost)
	)
;
; It hasn't already been identified as a viable alternative
;
	(not (wall-selection (id ?id)))
;
; Condensation risk equal or lower than required
;
	(test
	  (or 
  	    (eq ?reqd-cr high)
	    (and (eq ?reqd-cr low)
	         (or (eq ?cr none) (eq ?cr negligible) (eq ?cr low)))
	    (and (eq ?reqd-cr negligible)
	         (or (eq ?cr none) (eq ?cr negligible)))
	    (and (eq ?reqd-cr none)
	         (eq ?cr none))
	  )
	)
=>
	(format t "%nWall section %d is a viable alternative.%n" ?id)
	(assert (wall-selection (id ?id) (cost ?cost) (description ?description)))
)


(defrule wall-selection-rule-2
   (declare (no-loop TRUE))
   ?wall1 <- (wall-selection (id ?id1) (cost ?cost1) (description ?description1) (best ?best1))
   ?wall2 <- (wall-selection (id ?id2) (cost ?cost2) (description ?description2) (best ?best2))
   (test (> ?cost1 ?cost2))
   =>
   (modify ?wall1 (best no))  ; Change the more expensive toy's best status to FALSE
   (modify ?wall2 (best yes))   ; Change the cheaper toy's best status to TRUE
   (printout t crlf "-------" crlf "Updated best status: id " ?id2 " wall is the best option. " ?description2 crlf "-------" crlf)

)







