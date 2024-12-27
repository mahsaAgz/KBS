(defrule calculate-total-taxable-income
   (item (name EARNINGS) (value ?earnings))
   =>
   (assert (item (name total-taxable-income)(value 20000)))
)
