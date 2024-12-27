(defrule calculate-total-taxable-income
   (item (name EARNINGS) (value ?earnings))
   (item (name INVESTMENT-INCOME) (value ?investment-income))
   =>
   (assert (item (name total-taxable-income)(value (+ ?earnings ?investment-income)))))

(defrule calculate-itemized-deductions
   (item (name PROPERTY-TAXES) (value ?property-taxes))
   (item (name MORTGAGE-INTEREST-DEDUCTION) (value ?mortgage-interest))
   (item (name CHARITABLE-CONTRIBUTIONS) (value ?charitable-contributions))
   =>
   (assert (item (name itemized-deductions)(value (+ ?property-taxes ?mortgage-interest ?charitable-contributions)))))

(defrule calculate-adjustments-to-income
   (item (name IRA-CONTRIBUTIONS) (value ?ira-contributions))
   (item (name ALIMONY) (value ?alimony))
   (item (name BUSINESS-EXPENSES) (value ?business-expenses))
   =>
   (assert (item (name adjustments-to-income)(value (+ ?ira-contributions ?alimony ?business-expenses)))))

(defrule calculate-adjusted-gross-income
    (item (name total-taxable-income) (value ?total-taxable-income))
    (item (name adjustments-to-income) (value ?adjustments))
    =>
    (assert (item (name adjusted-gross-income)(value (- ?total-taxable-income ?adjustments))))
)

(defrule calculate-deduction
    (item (name itemized-deductions) (value ?itemized-deductions))
    =>
    (if (> ?itemized-deductions 2300)
        then (assert (item (name deduction) (value (- ?itemized-deductions 2300))))
        else (assert (item (name deduction) (value 0))))
)

(defrule calculate-gross-taxable-income
    (item (name adjusted-gross-income) (value ?agi))
    (item (name deduction) (value ?deduction))
    =>
    (assert (item (name gross-taxable-income)(value (- ?agi ?deduction))))
)

(defrule calculate-personal-exemptions
    (item (name NUMBER-OF-EXEMPTIONS) (value ?num-exemptions))
    =>
    (assert (item (name personal-exemptions)(value (* ?num-exemptions 1000))))
)

(defrule calculate-net-taxable-income
    (item (name gross-taxable-income) (value ?gross-income))
    (item (name personal-exemptions) (value ?exemptions))
    =>
    (assert (item (name net-taxable-income)(value (- ?gross-income ?exemptions))))
)
 
(defrule handle-duplicate-items
  ?newer <- (item (name ?name) (value ?new-value))
  ?older <- (item (name ?name) (value ?old-value&~?new-value))
  =>
  (printout t "Change detected in item '" ?name "': " ?old-value " updated to " ?new-value crlf)
  (retract ?older)
)

(defrule print-all-values
    ?item <- (item (name ?name) (value ?value))
    =>
    (printout t  ?name ": " ?value crlf)
)
