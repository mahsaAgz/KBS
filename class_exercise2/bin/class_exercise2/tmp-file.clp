(deftemplate goal
    (slot name (type SYMBOL) (default none))
    (slot status (type SYMBOL) (default inactive))
    (slot subgoal-of (type SYMBOL) (default none))
    (slot follows (type SYMBOL) (default none))
)

(deftemplate kitchen
    (slot x-dimension (type INTEGER) (default 0))
    (slot y-dimension (type INTEGER) (default 0))
)

(deftemplate wall
    (slot name (type SYMBOL) (default none))
    (slot width (type INTEGER) (default 0))
    (slot opposite (type SYMBOL) (default none))
    (slot adjacent-right (type SYMBOL) (default none))
    (slot adjacent-left (type SYMBOL) (default none))
)

(deftemplate opening
    (slot type (type SYMBOL) (default none))
    (slot wall-location (type SYMBOL) (default none))
    (slot clearance (type INTEGER) (default 0))
    (slot distance-from-origin (type INTEGER) (default 0))
    (slot width (type INTEGER) (default 0))
)

(deftemplate kitchen-component
    (slot id (type INTEGER) (default 0))
    (slot type (type SYMBOL) (default none))
    (slot width (type INTEGER) (default 0))
    (slot depth (type INTEGER) (default 0))
    (slot clearance (type INTEGER) (default 0))
)

(deftemplate component-location
    (slot component-id (type INTEGER) (default 0))
    (slot wall-location (type SYMBOL) (default none))
    (slot distance-from-origin (type INTEGER) (default 0))
)
