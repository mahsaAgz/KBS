; WALL-REQUIREMENT
;
; This fact will store the users' performance requirements for
; the wall section to be selected.
;
(deftemplate wall-requirements
	(slot project-name 				; string used to identify project     
		(type STRING)
	)
	(slot fire-resistance 			; units in hours
		(type NUMBER)
	)
	(slot thermal-resistance		; units in deg.F/BTU/h/ft^2
		(type NUMBER)
	)
	(slot condensation-risk
		(type SYMBOL)
	)
	(slot sound-transmission-loss	; units in dB
		(type NUMBER)
	)
	(slot exterior-material  		
        (type SYMBOL)               
    )  
    (slot best  		
        (type SYMBOL)               
    )      
)

; WALL-SECTION
;
;	The wall section template is used to store information about
;	the composition and performance of multi-layered wall sections.
;
(deftemplate wall-section
	(slot id 				; the number corresponding
		(type INTEGER)			; to the id # in paper by Mattar et al.
	)
	(slot description			; string describing wall
		(type STRING)
	)
	(slot fire-resistance 		; units in hours
		(type NUMBER)
	)
	(slot thermal-resistance	; units in deg.F/BTU/h/ft^2
		(type NUMBER)
	)
	(slot condensation-risk
		(type SYMBOL)
	)
	(slot sound-transmission-loss	; units in dB
		(type NUMBER)
	)
	(slot cost		; units in $/sq.ft.
		(type NUMBER)
	)
	(slot exterior-material  		
        (type SYMBOL)               
    ) 
)

; WALL-SELECTION
;
;	The wall selection template is used to identify viable alternatives for wall sections that satisfy
;	all performance requirements.
;
(deftemplate wall-selection
	(slot id 			; the number corresponding
		(type INTEGER)	; to the id # in paper by Mattar et al.
	)
	(slot description			; string describing wall
		(type STRING)
	)
	(slot cost			; units in $/sq.ft.
		(type NUMBER)
	)
	(slot best     ; Attribute for marking the best option
        (type SYMBOL)    
        (default no)      
    )
)
