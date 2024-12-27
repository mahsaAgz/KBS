(deftemplate goal
    (slot name (type SYMBOL))
    (slot status (type SYMBOL) (default inactive))
    (slot subgoal_1 (type SYMBOL)(default nil))
    (slot subgoal_2 (type SYMBOL)(default nil))
)

(deftemplate income
    (slot earnings (type INTEGER))
    (slot investment-income (type INTEGER))
)

(deftemplate adjustment
    (slot ira-contributions (type INTEGER))
    (slot alimony (type INTEGER))
    (slot business-expenses (type INTEGER))
)

(deftemplate itemized-deduction
    (slot property-taxes (type INTEGER) (default 0))
    (slot mortgage-interest (type INTEGER) (default 0))
    (slot charitable-contributions (type INTEGER) (default 0))
    (slot standard (type INTEGER) (default 2300))
)

(deftemplate exemption
    (slot number (type INTEGER))
    (slot value-per-exemption (type INTEGER) (default 1000))
)
