;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Duplicate Fact Handling ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule delete_duplicate_facts
    (declare (salience 100))
    ?item1 <- (item (name ?n) (value ?value1))
    ?item2 <- (item (name ?n) (value ?value1))
    (test (neq ?item1 ?item2))  ; Ensure they are different facts.
    =>
    (retract ?item1)  ; Retract one of the duplicate facts.
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize Dependencies ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule initialize-dependencies
    (declare (salience 100))
  ?earnings <- (item (name EARNINGS))
  ?investment <- (item (name INVESTMENT-INCOME))
  ?property <- (item (name PROPERTY-TAXES))
  ?mortgage <- (item (name MORTGAGE-INTEREST-DEDUCTION))
  ?charity <- (item (name CHARITABLE-CONTRIBUTIONS))
  ?ira <- (item (name IRA-CONTRIBUTIONS))
  ?alimony <- (item (name ALIMONY))
  ?business <- (item (name BUSINESS-EXPENSES) )
  ?exemptions <- (item (name NUMBER-OF-EXEMPTIONS))
  =>
  ;; Set immediate dependencies
  (modify ?earnings (dependent-items total-taxable-income))  ; EARNINGS → total-taxable-income
  (modify ?investment (dependent-items total-taxable-income))  ; INVESTMENT-INCOME → total-taxable-income
  (modify ?ira (dependent-items adjustment-to-income))  ; IRA-CONTRIBUTIONS → adjustment-to-income
  (modify ?alimony (dependent-items adjustment-to-income))  ; ALIMONY → adjustment-to-income
  (modify ?business (dependent-items adjustment-to-income))  ; BUSINESS-EXPENSES → adjustment-to-income
  (modify ?property (dependent-items itemized-deductions))  ; PROPERTY-TAXES → itemized-deductions
  (modify ?mortgage (dependent-items itemized-deductions))  ; MORTGAGE-INTEREST → itemized-deductions
  (modify ?charity (dependent-items itemized-deductions))  ; CHARITABLE-CONTRIBUTIONS → itemized-deductions
  (modify ?exemptions (dependent-items personal-exemptions))  ; NUMBER-OF-EXEMPTIONS → personal-exemptions
  

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Change Detection ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Detect changes and mark dependencies for re-processing
(defrule detect-changes
    (not ?item <- (item (changed yes) (to-be-process yes)))
    ?item1 <- (item (name ?n) (value ?value1) (changed no) (processed no))
    ?item2 <- (item (name ?n) (value ?value2) (changed no) (processed no))
    (test (neq ?value1 ?value2))
    =>
    (printout t "Detected change for " ?n ": " ?value1 " -> " ?value2 crlf)
    (modify ?item1 (changed yes) (to-be-process yes))  ; Mark the new fact as changed
    (modify ?item2 (changed yes) (to-be-process no))   ; Mark the old fact as unchanged
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Total Taxable Income ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-total-taxable-income
    ?earn <- (item (name EARNINGS) (value ?ea) (processed no) (to-be-process yes))
  ?invest <- (item (name INVESTMENT-INCOME) (value ?ia) (processed no) (to-be-process yes))
  =>
  (modify ?earn (processed yes) (to-be-process no))
  (modify ?invest (processed yes) (to-be-process no))
  (bind ?total-taxable (+ ?ea ?ia))
  (printout t "-----------------" crlf)
  (printout t "Total Taxable Income: " ?total-taxable crlf)
  (assert (item (name total-taxable-income)(value ?total-taxable)(processed yes) (dependent-items adjusted-gross-income)))

)
(defrule recalculate-total-taxable-income
    ?total-taxable-income <- (item (name total-taxable-income) (to-be-process yes)(processed no))
    ?earn <- (item (name EARNINGS) (value ?ea) (changed ?earn_change))
  ?invest <- (item (name INVESTMENT-INCOME) (value ?ia) (changed ?invest_change))
  (test (or (= ?earn_change yes) (= ?invest_change yes)))
  =>
  (modify ?earn (processed yes) (to-be-process no)(changed no))
  (modify ?invest (processed yes) (to-be-process no)(changed no))
  (bind ?total-taxable (+ ?ea ?ia))
  (printout t "-----------------" crlf)
  (printout t "Modified Total Taxable Income: " ?total-taxable crlf)
  (modify ?total-taxable-income (value ?total-taxable) (changed yes) (processed yes))
;  (facts)
)

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Adjustment to Income ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-adjustments
  ?ira <- (item (name IRA-CONTRIBUTIONS) (value ?iraVal) (processed no) (to-be-process yes))
  ?alimony <- (item (name ALIMONY) (value ?alimonyVal) (processed no) (to-be-process yes))
  ?business <- (item (name BUSINESS-EXPENSES) (value ?businessVal) (processed no) (to-be-process yes))
  =>
  (modify ?ira (processed yes) (to-be-process no))
  (modify ?alimony (processed yes) (to-be-process no))
  (modify ?business (processed yes) (to-be-process no))
  (bind ?adjustment-total (+ ?iraVal ?alimonyVal ?businessVal))
  (printout t "-----------------" crlf)
  (printout t "Adjustment to Income: " ?adjustment-total crlf)
  (assert (item (name adjustment-to-income)(value ?adjustment-total)(processed yes)(dependent-items adjusted-gross-income)))
)


(defrule recalculate-adjustments
    ?adjustment-to-income <- (item (name adjustment-to-income)(to-be-process yes)(processed no))
    ?ira <- (item (name IRA-CONTRIBUTIONS) (value ?iraVal) (changed ?ira_change))
    ?alimony <- (item (name ALIMONY) (value ?alimonyVal) (changed ?alm_change))
    ?business <- (item (name BUSINESS-EXPENSES) (value ?businessVal)(changed ?bus_change))
  (test (or (= ?ira_change yes) (= ?alm_change yes) (= ?bus_change yes) ))
  =>
  (modify ?ira (processed yes) (to-be-process no))
  (modify ?alimony (processed yes) (to-be-process no)(changed no))
  (modify ?business (processed yes) (to-be-process no)(changed no))
  (bind ?adjustment-total (+ ?iraVal ?alimonyVal ?businessVal))
  (printout t "-----------------" crlf)
  (printout t "Modified Adjustment to Income: " ?adjustment-total crlf)
  (modify ?adjustment-to-income (value ?adjustment-total) (changed yes) (processed yes))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Adjusted Gross Income ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule calculate-adjusted-gross-income
    ?totalTaxable <- (item (name total-taxable-income) (value ?totalTaxableVal) (processed yes) (to-be-process yes))
    ?adjustments <- (item (name adjustment-to-income) (value ?adjustmentVal) (processed yes) (to-be-process yes))
    =>
    (bind ?adjusted-gross (- ?totalTaxableVal ?adjustmentVal))
    (printout t "-----------------" crlf)
    (printout t "Adjusted Gross Income: " ?adjusted-gross crlf)
    (modify ?totalTaxable (to-be-process no))
    (modify ?adjustments (to-be-process no))
    (assert (item (name adjusted-gross-income) (value ?adjusted-gross) (changed no) (processed yes)
                  (dependent-items gross-taxable-income)))
)

(defrule recalculate-adjusted-gross-income
    ?adjusted-gross-income <- (item (name adjusted-gross-income)(to-be-process yes)(processed no))
    ?totalTaxable <- (item (name total-taxable-income) (value ?totalTaxableVal) (processed yes) (changed ?total_tax_change))
    ?adjustments <- (item (name adjustment-to-income) (value ?adjustmentVal) (processed yes) (changed ?adj_change))
    (test (or (= ?total_tax_change yes) (= ?adj_change yes)))
    =>
    (bind ?adjusted-gross (- ?totalTaxableVal ?adjustmentVal))
    (printout t "-----------------" crlf)
    (printout t "Modified Adjusted Gross Income: " ?adjusted-gross crlf)
    (modify ?totalTaxable (to-be-process no)(changed no))
    (modify ?adjustments (to-be-process no)(changed no))
    (modify ?adjusted-gross-income (value ?adjusted-gross) (changed yes) (processed yes))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Itemized Deductions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-itemized-deductions
  ?property <- (item (name PROPERTY-TAXES) (value ?propertyVal) (processed no) (to-be-process yes))
  ?mortgage <- (item (name MORTGAGE-INTEREST-DEDUCTION) (value ?mortgageVal) (processed no) (to-be-process yes))
  ?charity <- (item (name CHARITABLE-CONTRIBUTIONS) (value ?charityVal) (processed no) (to-be-process yes))
  =>
  (modify ?property (processed yes) (to-be-process no))
  (modify ?mortgage (processed yes) (to-be-process no))
  (modify ?charity (processed yes) (to-be-process no))
  (bind ?deductions-total (+ ?propertyVal ?mortgageVal ?charityVal))
  (bind ?final-deduction 0)

  (if (> ?deductions-total 2300)
      (printout t"HEEEY")
    (bind ?final-deduction (- ?deductions-total 2300))
    
  )
  
  (printout t "-----------------" crlf)
  (printout t "Final Deduction: " ?final-deduction crlf)
  (assert (item (name itemized-deductions) (value ?final-deduction) (changed no) (processed yes)
                (dependent-items gross-taxable-income)))
)


(defrule recalculate-itemized-deductions
  ?itemized-deductions <- (item (name itemized-deductions)(to-be-process yes)(processed no))
  ?property <- (item (name PROPERTY-TAXES) (value ?propertyVal) (processed yes) (changed ?prop_change))
  ?mortgage <- (item (name MORTGAGE-INTEREST-DEDUCTION) (value ?mortgageVal) (processed yes) (changed ?mort_change))
  ?charity <- (item (name CHARITABLE-CONTRIBUTIONS) (value ?charityVal) (processed yes) (changed ?charity_change))
  (test (or (= ?prop_change yes) (= ?mort_change yes) (= ?charity_change yes)))
  =>
  (modify ?property (to-be-process no) (changed no))
  (modify ?mortgage (to-be-process no) (changed no))
  (modify ?charity (to-be-process no) (changed no))
  (bind ?deductions-total (+ ?propertyVal ?mortgageVal ?charityVal))
  (bind ?final-deduction (if (> ?deductions-total 2300)
                           (- ?deductions-total 2300)
                           0))
  (printout t "-----------------" crlf)

  (printout t "Modified Final Deduction: " ?final-deduction crlf)
  (modify ?itemized-deductions (value ?final-deduction) (changed yes) (processed yes))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gross Taxable Income ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-gross-taxable-income
  ?adjustedGross <- (item (name adjusted-gross-income) (value ?adjustedGrossVal) (processed yes) (to-be-process yes))
  ?itemizedDeductions <- (item (name itemized-deductions) (value ?itemizedDeductionsVal) (processed yes) (to-be-process yes))
 

  =>
  
  (bind ?grossTaxable (- ?adjustedGrossVal ?itemizedDeductionsVal))
  (printout t "-----------------" crlf)
  (printout t "Gross Taxable Income: " ?grossTaxable crlf)
  (modify ?adjustedGross (to-be-process no))
  (modify ?itemizedDeductions (to-be-process no))
  (assert (item (name gross-taxable-income) (value ?grossTaxable) (changed no) (processed yes) (dependent-items net-taxable-income)))
)

(defrule recalculate-gross-taxable-income
  ?grossTaxableIncome <- (item (name gross-taxable-income) (processed no) (to-be-process yes))
  ?adjustedGross <- (item (name adjusted-gross-income) (value ?adjustedGrossVal) (processed yes) (changed ?gross_change))
  ?itemizedDeductions <- (item (name itemized-deductions) (value ?itemizedDeductionsVal) (processed yes) (changed ?deductions_change))
  (test (or (= ?gross_change yes) (= ?deductions_change yes)))
  
  =>
  (bind ?grossTaxable (- ?adjustedGrossVal ?itemizedDeductionsVal))
  (printout t "-----------------" crlf)
  (printout t "Modified Gross Taxable Income: " ?grossTaxable crlf)
  (modify ?adjustedGross (to-be-process no) (changed no))
  (modify ?itemizedDeductions (to-be-process no) (changed no))
  (modify ?grossTaxableIncome (value ?grossTaxable) (changed yes) (processed yes))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Personal Exemptions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-personal-exemptions
  ?exemptions <- (item (name NUMBER-OF-EXEMPTIONS) (value ?numExemptions) (processed no) (to-be-process yes))
  =>
  (modify ?exemptions (processed yes) (to-be-process no))
  (bind ?exemption-value (* ?numExemptions 1000))  ; Each exemption is worth 1000
  (printout t "-----------------" crlf)
  (printout t "Personal Exemptions: " ?exemption-value crlf)
  (assert (item (name personal-exemptions) (value ?exemption-value) (changed no) (processed yes)
                (dependent-items net-taxable-income)))
)

(defrule recalculate-personal-exemptions
  ?personal-exemptions <- (item (name personal-exemptions) (processed no) (to-be-process yes))
  ?exemptions <- (item (name NUMBER-OF-EXEMPTIONS) (value ?numExemptions) (processed yes) (changed ?num_change))
  (test (= ?num_change yes))
  =>
  
  (modify ?exemptions (to-be-process no) (changed no))
  (bind ?exemption-value (* ?numExemptions 1000))  ; Each exemption is worth 1000
  (printout t "-----------------" crlf)
  (printout t "Modified Personal Exemptions: " ?exemption-value crlf)
  (modify ?personal-exemptions (value ?exemption-value) (changed yes) (processed yes))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Net Taxable Income ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calculate-net-taxable-income
  ?grossTaxable <- (item (name gross-taxable-income) (value ?grossTaxableVal) (processed yes) (to-be-process yes))
  ?personalExemptions <- (item (name personal-exemptions) (value ?exemptionsVal) (processed yes) (to-be-process yes))
  =>
  (bind ?net-taxable (- ?grossTaxableVal ?exemptionsVal))
  (printout t "-----------------" crlf)
  (printout t "Net Taxable Income: " ?net-taxable crlf)
  (modify ?grossTaxable (to-be-process no))
  (modify ?personalExemptions (to-be-process no))
  (assert (item (name net-taxable-income) (value ?net-taxable) (changed no) (processed yes)))
  ; (facts)  ; Uncomment for debugging
)

(defrule recalculate-net-taxable-income
  ?net-taxable-income <- (item (name net-taxable-income) (processed no) (to-be-process yes))
  ?grossTaxable <- (item (name gross-taxable-income) (value ?grossTaxableVal) (processed yes) (changed ?gross_change))
  ?personalExemptions <- (item (name personal-exemptions) (value ?exemptionsVal) (processed yes) (changed ?exemptions_change))
  (test (or (= ?gross_change yes) (= ?exemptions_change yes)))
  =>
  (bind ?net-taxable (- ?grossTaxableVal ?exemptionsVal))
  (printout t "-----------------" crlf)
  (printout t "Modified Net Taxable Income: " ?net-taxable crlf)
  (modify ?grossTaxable (to-be-process no) (changed no))
  (modify ?personalExemptions (to-be-process no) (changed no))
  (modify ?net-taxable-income (value ?net-taxable) (processed yes))
  
  ; (facts)  ; Uncomment for debugging
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Process State Management ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule completed-without-change
    ?last <- (item (name net-taxable-income)(processed yes))
    ?ps <- (process-state (done no))
    (not (item (changed yes)))
    =>
    (printout t crlf "*********** DONE *************** "  crlf)
    (modify ?ps (done yes))
)

;
; When the entire process is completed
(defrule completed-with-change
    ?ps <- (process-state (done yes))
    ?main_changed_fact <- (item (changed yes) (processed yes))
    ?changedTo <- (item (name ?name) (changed yes) (to-be-process no)(processed no))
    
    =>
;    (facts)
    (retract ?main_changed_fact)
    (modify ?changedTo (processed no) (to-be-process yes)(changed yes))
;    (modify ?ps (done yes))  ; Reset the `done` flag to allow re-processing
    (printout t crlf"************************** "  crlf)
    (printout t "After applying Change: " ?name crlf)
    (printout t "************************** "  crlf crlf)
    (modify ?ps (done no))
;    (facts)
   
)


(defrule propagate-unprocessed
    ?ps <- (process-state (done no))
    ?item <- (item (to-be-process yes) (dependent-items ?dependent) (changed yes))
    ?dependentItem <- (item (name ?dependent))
    =>
    (printout t "Propagating change to " ?dependent crlf)
    (modify ?dependentItem (processed no) (to-be-process yes) (changed yes))
)

;
;(defrule propagate-unprocessed
;    ?changedFact <- (item (changed yes) (processed no)(dependent-items ?dependent))
;    ?item2<- (item (name ?name)(processed yes))
;    ?ps <- (process-state)
;    (test (eq ?name ?dependent))
;  =>
;  (printout t "######################" crlf)
;  (modify ?changedFact (changed no) (processed no) (to-be-process yes))
;  (modify ?item2 (changed yes) (processed no) (to-be-process yes) (value nil))
;  (modify ?ps (done no))
;  (printout t "Processed and to-be-process values updated for dependent item: " ?name "." crlf)
;
;)
