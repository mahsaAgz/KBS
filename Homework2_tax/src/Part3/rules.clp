;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; General Control Rules ;;;;;;;;;;;;;;;;;;;;;;
(defrule start-system-rule
    ?goal <- (goal (name ?goal-name)(subgoal_1 nil) (subgoal_2 nil) (status inactive))
    =>
    (modify ?goal (status active))
)

(defrule activate-main-goal
    ?main_goal <- (goal (name ?goal-name) (status inactive) (subgoal_1 ?subgoal1-name) (subgoal_2 ?subgoal2-name))
    (goal (name ?subgoal1-name) (status complete))
    (goal (name ?subgoal2-name) (status complete))
    =>
    (modify ?main_goal (status active))
)


; ********************** level 1 hierarachy ****************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Calculate Total Taxable Income ;;;;;;;;;;;;;;;;

(defrule calculate-total-taxable-income
    ?goal <- (goal (name calculate-total-taxable-income) (status active))
    (income (earnings ?earnings) (investment-income ?investment))
    =>
    (bind ?total-income (+ ?earnings ?investment))
    (assert (total-income ?total-income))
)

(defrule calculate-total-taxable-income-completion-rule
    ?goal <- (goal (name calculate-total-taxable-income) (status active))
    (total-income ?total-income)
    =>
    (modify ?goal (status complete))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Calculate Total Taxable Income ;;;;;;;;;;;;;;;;

(defrule calculate-adjustments-to-income
    ?goal <- (goal (name calculate-adjustments-to-income) (status active))
    (adjustment (ira-contributions ?ira) (alimony ?alimony) (business-expenses ?business))
    =>
    (bind ?total-adjustments (+ ?ira ?alimony ?business))
    (assert (adjustment-to-income ?total-adjustments))
)

(defrule calculate-adjustments-to-income-completion-rule
    ?goal <- (goal (name calculate-adjustments-to-income) (status active))
    (adjustment-to-income ?adjustments)
    =>
    (modify ?goal (status complete))
    
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; Calculate Deduction ;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule calculate-total-deduction
    ?goal <- (goal (name calculate-total-deduction) (status active))
    (itemized-deduction (property-taxes ?pt) (mortgage-interest ?mi) (charitable-contributions ?cc) (standard ?std))
    =>
    (bind ?total-sum (+ ?pt ?mi ?cc))
    (if (> ?total-sum ?std)
        then
            (bind ?deduction (- ?total-sum ?std))
        else
            (bind ?deduction 0))
    (assert (total-deduction ?deduction))
)


(defrule calculate-total-deduction-completion-rule
    ?goal <- (goal (name calculate-total-deduction) (status active))
    ?deduction-fact <- (total-deduction ?deduction)
    =>
    (modify ?goal (status complete))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; Calculate Exemptions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-exemptions
    ?goal <- (goal (name calculate-exemptions) (status active))
    (exemption (number ?num) (value-per-exemption ?val))
    =>
    (bind ?total-exemptions (* ?num ?val))
    (assert (total-exemptions ?total-exemptions))
)

(defrule calculate-exemptions-completion-rule
    ?goal <- (goal (name calculate-exemptions) (status active))
    ?exemptions <- (total-exemptions ?exemptions)
    =>
    (modify ?goal (status complete))
;    (printout t "Completion confirmed: Total exemptions are " ?exemptions crlf)
)


; ********************** level 2 hierarachy ****************************************************


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Calculate Adjusted Gross Income ;;;;;;;;;;;;;;;;;;;

(defrule calculate-adjusted-gross-income
    ?goal <- (goal (name calculate-adjusted-gross-income) (status active))
    (total-income ?total-income)
    (adjustment-to-income ?adjustments)
    =>
    (bind ?adjusted-gross-income (- ?total-income ?adjustments))
    (assert (adjusted-gross-income ?adjusted-gross-income))
    
)

(defrule calculate-adjusted-gross-income-completion-rule
    ?goal <- (goal (name calculate-adjusted-gross-income) (status active))
    (adjusted-gross-income ?agi)
    =>
    (modify ?goal (status complete))
)
; ********************** level 3 hierarachy ****************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Calculate Gross Taxable Income ;;;;;;;;;;;;;;;;;;;;
(defrule calculate-gross-taxble-income
    ?goal <- (goal (name calculate-gross-taxble-income) (status active))
    (adjusted-gross-income ?adjusted-gross-income)
    (total-deduction ?total-deduction)
    =>
    (bind ?gross-taxble-income (- ?adjusted-gross-income ?total-deduction))
    (assert (gross-taxble-income ?gross-taxble-income))
    
)

(defrule calculate-gross-taxble-income-completion-rule
    ?goal <- (goal (name calculate-gross-taxble-income) (status active))
    (gross-taxble-income ?gti)
    =>
    (modify ?goal (status complete))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Calculate Net Taxable Income ;;;;;;;;;;;;;;;;;;;

(defrule calculate-net-taxble-income
    ?goal <- (goal (name calculate-net-taxble-income) (status active))
    (gross-taxble-income ?gross-taxble-income)
    (total-exemptions ?total-exemptions)
    =>
    (bind ?net-taxble-income (- ?gross-taxble-income ?total-exemptions))
    (assert (net-taxble-income ?net-taxble-income))
)

(defrule calculate-net-taxble-income-completion-rule
    ?goal <- (goal (name calculate-net-taxble-income) (status active))
    (net-taxble-income ?nti)
    =>
    (modify ?goal (status complete))

)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Printing Results ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule print-all-values
    ?g1 <- (goal (name calculate-total-taxable-income) (status complete))
    ?g2 <- (goal (name calculate-adjustments-to-income) (status complete))
    ?g3 <- (goal (name calculate-adjusted-gross-income) (status complete))
    ?g4 <- (goal (name calculate-total-deduction) (status complete))
    ?g5 <- (goal (name calculate-exemptions) (status complete))
    ?g6 <- (goal (name calculate-gross-taxble-income) (status complete))
    ?g7 <- (goal (name calculate-net-taxble-income) (status complete))
    (total-income ?total-income)
    (adjustment-to-income ?adjustments)
    (adjusted-gross-income ?agi)
    (total-deduction ?deduction)
    (total-exemptions ?exemptions)
    (gross-taxble-income ?gti)
    (net-taxble-income ?nti)
    =>
    (printout t "======= Final Results =========" crlf)
    (printout t "Summary of Calculations:" crlf crlf)
    (printout t "Total Taxable Income: " ?total-income crlf)
    (printout t "Total Adjustments: " ?adjustments crlf)
    (printout t "Adjusted Gross Income: " ?total-income " - " ?adjustments " = " ?agi crlf)
    (printout t "----------- " crlf)
    (printout t "Total Deduction: " ?deduction crlf)
    (printout t "----------- " crlf)
    (printout t "Gross Taxable Income: " ?agi " - "  ?deduction " = " ?gti crlf)
    (printout t "Total Exemptions: " ?exemptions crlf)
    (printout t "----------- " crlf)
    (printout t "Net Taxable Income: " ?gti " - "  ?exemptions " = " ?nti crlf)
    (printout t crlf "End of Calculations." crlf)
    (printout t "====================================" crlf)
)

