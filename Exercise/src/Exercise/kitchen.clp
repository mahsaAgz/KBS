; ---- template
(deftemplate goal
    (slot name (type SYMBOL) (default nil))
    (slot status (type SYMBOL) (default inactive))
    (slot subgoal-of (type SYMBOL) (default nil))
    (slot follows (type SYMBOL) (default nil))
)

(deftemplate kitchen
    (slot x-dimension (type INTEGER) (default 0))
    (slot y-dimension (type INTEGER) (default 0))
)

(deftemplate wall
    (slot name (type SYMBOL) (default nil))
    (slot width (type INTEGER) (default 0))
    (slot opposite (type SYMBOL) (default nil))
    (slot adjacent-right (type SYMBOL) (default nil))
    (slot adjacent-left (type SYMBOL) (default nil))
)

(deftemplate opening
    (slot type (type SYMBOL) (default nil))
    (slot wall-location (type SYMBOL) (default nil))
    (slot clearance (type INTEGER) (default 0))
    (slot distance-from-origin (type INTEGER) (default 0))
    (slot width (type INTEGER) (default 0))
)

(deftemplate kitchen-component
    (slot id (type INTEGER) (default 0))
    (slot type (type SYMBOL) (default nil))
    (slot width (type INTEGER) (default 0))
    (slot depth (type INTEGER) (default 0))
    (slot clearance (type INTEGER) (default 0))
)

(deftemplate component-location
    (slot component-id (type INTEGER) (default 0))
    (slot wall-location (type SYMBOL) (default nil))
    (slot distance-from-origin (type INTEGER) (default 0))
)


; ----- data

(assert (goal (name "goal:get-initial-data") (follows nil)))
(assert (goal (name "goal:place-sink") (follows nil)))
(assert (goal (name "goal:place-dishwasher") (follows "goal:place-sink")))
(assert (goal (name "goal:place-refrigerator") (follows "goal:place-dishwasher")))
(assert (goal (name "goal:place-stove") (follows "goal:place-refrigerator")))
(assert (goal (name "goal:place-island") (follows "goal:place-stove")))
(assert (goal (name "goal:evaluate-and-print") (follows "goal:place-island")))

(assert (kitchen (x-dimension 12) (y-dimension 12)))
(assert (wall (name N) (width 10) (opposite S) (adjacent-right E) (adjacent-left W)))
(assert (wall (name S) (width 10) (opposite N) (adjacent-right W) (adjacent-left E)))
(assert (wall (name E) (width 12) (opposite W) (adjacent-right S) (adjacent-left N)))
(assert (wall (name W) (width 12) (opposite E) (adjacent-right N) (adjacent-left S)))

(assert (opening (type window) (wall-location N) (distance-from-origin 4) (width 3) (clearance 3)))
(assert (opening (type door) (wall-location S) (distance-from-origin 4) (width 3) (clearance 3)))

; Corrected assert statements for kitchen components
(assert (kitchen-component (id 1) (type sink) (width 4) (depth 3) (clearance 3)))
(assert (kitchen-component (id 2) (type stove) (width 3) (depth 3) (clearance 3)))
(assert (kitchen-component (id 3) (type refrigerator) (width 3) (depth 3) (clearance 3)))
(assert (kitchen-component (id 4) (type dishwasher) (width 2) (depth 3) (clearance 3)))




; ----- rules

; ======= General Control rules ======
(defrule start-system-rule
    ?goal <- (goal (follows nil) (status inactive))
    =>
    (modify ?goal (status active))
)
(defrule activate-next-goal
    (goal (name ?active-goal) (status complete))
    ?new-goal <- (goal (name ?inactive-goal) (follows ?active-goal) (status inactive))
    =>
    (modify ?new-goal (status active))
)
(defrule halt-system-rule
    ?goal <- (goal (name ?active-goal) (status complete))
    (not (goal (follows ?active-goal)))
    =>
    (halt)
)

; ======= Place Sink rules ======
; Places the sink in front of a window, avoiding walls opposite the door.

(defrule place-sink-rule1
    (goal (name goal:place-sink) (status active))
    (?sink <- kitchen-component (id ?sink-id) (type sink) (width ?width) (depth ?depth) (clearance ?clearance))
    (not (component-location (component-id ?sink-id)))   ; if has not already been placed
    
    (opening (type window) (wall-location ?wall) (distance-from-origin ?dfo) (width ?win-width))
    
    ; calculate the middle of window and see if there is enough space to put sink
    (test (>=
        (+ ?dfo(/ ?win-width 2))
        (/ ?sink-width 2)
    ))
    (not (opening (type door) (wall-location ?wall)))
    (wall (name ?wall) (opposite ?opposite-wall))
    (not (opening (type door) (wall-location ?opposite-wall)))
    
    =>
    (bind ?location-for-sink (- ?dfo (/ (- ?sink-width ?win-width) 2)))
    (assert (component-location (component-id ?sink-id) (wall-location ?wall) (distance-from-origin ?location-for-sink)))
    )
    
)

