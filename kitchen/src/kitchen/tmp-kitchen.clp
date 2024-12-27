(deftemplate goal
	(slot name (type SYMBOL) (default none))
	(slot status (type SYMBOL) (default inactive))
	(slot subgoal-of (type SYMBOL) (default none))
	(slot follows (type SYMBOL) (default none))
)

