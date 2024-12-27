(assert (goal (name calculate-total-taxable-income) (status inactive)))
(assert (goal (name calculate-adjustments-to-income) (status inactive)))
(assert (goal (name calculate-adjusted-gross-income) (status inactive)(subgoal_1  calculate-total-taxable-income)(subgoal_2  calculate-adjustments-to-income)))
(assert (goal (name calculate-total-deduction) (status inactive)))
(assert (goal (name calculate-exemptions) (status inactive)))
(assert (goal (name calculate-gross-taxble-income) (status inactive) (subgoal_1  calculate-adjusted-gross-income)(subgoal_2  calculate-total-deduction)))
(assert (goal (name calculate-net-taxble-income) (status inactive) (subgoal_1  calculate-gross-taxble-income)(subgoal_2  calculate-exemptions)))
 
 
;--------------------
(assert (income (earnings 66000) (investment-income 5000)))
(assert (adjustment (ira-contributions 3000) (alimony 1000) (business-expenses 2000)))
(assert (itemized-deduction (property-taxes 0) (mortgage-interest 2000) (charitable-contributions 1000)))
(assert (exemption (number 1) (value-per-exemption 1000)))  ; Using the specified number and value directly
