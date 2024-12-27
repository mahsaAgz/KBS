; KITCHEN CONFIGURATION SYSTEM
; This file contains rules for configuring kitchen components.

; === GENERAL CONTROL RULES ===

; START SYSTEM RULE
; Activates the first goal if no goals are active.
(defrule start-system-rule
    ?goal <- (goal (follows nil) (status inactive))
    =>
    (modify ?goal (status active))
)

; ACTIVATE NEXT GOAL RULE
; Activates the goal that follows the most recently completed goal.
(defrule activate-next-goal
    (goal (name ?active-goal) (status complete))
    ?new-goal <- (goal (name ?inactive-goal) (follows ?active-goal) (status inactive))
    =>
    (modify ?new-goal (status active))
)

; HALT SYSTEM RULE
; Halts the system when all goals are complete.
(defrule halt-system-rule
    ?goal <- (goal (name ?active-goal) (status complete))
    (not (goal (follows ?active-goal)))
    =>
    (halt)
)

; === RULES FOR GOAL: PLACE-SINK ===

; PLACE-SINK-RULE-1
; Places the sink in front of a window, avoiding walls opposite the door.
(defrule place-sink-rule-1
    (goal (name goal:place-sink) (status active))
    ?sink <- (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (not (component-location (component-id ?sink-id)))
    (opening (type window) (wall-location ?wall) (distance-from-origin ?dfo) (width ?win-width))
    (test (>= 
    		(+ ?dfo 
    			(/ ?win-width 2)) (/ ?sink-width 2)
    		)
    		
    	)
    (not (opening (type door) (wall-location ?wall)))
    (wall (name ?wall) (opposite ?opposite-wall))
    (not (opening (type door) (wall-location ?opposite-wall)))
    =>
    (bind ?location-for-sink (- ?dfo (/ (- ?sink-width ?win-width) 2)))
    (assert (component-location (component-id ?sink-id) (wall-location ?wall) (distance-from-origin ?location-for-sink)))
)

; PLACE-SINK-RULE-2
; Places the sink in front of any window, ignoring door locations.
(defrule place-sink-rule-2
    (declare (salience -5))
    (goal (name goal:place-sink) (status active))
    ?sink <- (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (not (component-location (component-id ?sink-id)))
    (opening (type window) (wall-location ?wall) (distance-from-origin ?dfo) (width ?win-width))
    (test (>= (+ ?dfo (/ ?win-width 2)) (/ ?sink-width 2)))
    =>
    (bind ?location-for-sink (- ?dfo (/ (- ?sink-width ?win-width) 2)))
    (assert (component-location (component-id ?sink-id) (wall-location ?wall) (distance-from-origin ?location-for-sink)))
)

; PLACE-SINK-RULE-3
; Places the sink in the middle of a wall not opposite a door.
(defrule place-sink-rule-3
    (declare (salience -10))
    (goal (name goal:place-sink) (status active))
    ?sink <- (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (not (component-location (component-id ?sink-id)))
    (wall (name ?wall) (opposite ?opposite-wall))
    (not (opening (type door) (wall-location ?wall)))
    (not (opening (type door) (wall-location ?opposite-wall)))
    (test (>= ?wall-width ?sink-width))
    =>
    (bind ?location-for-sink (/ (- ?wall-width ?sink-width) 2))
    (assert (component-location (component-id ?sink-id) (wall-location ?wall) (distance-from-origin ?location-for-sink)))
)

; PLACE-SINK-RULE-4
; Places the sink in the middle of the North (N) wall as a last resort.
(defrule place-sink-rule-4
    (declare (salience -15))
    (goal (name goal:place-sink) (status active))
    ?sink <- (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (not (component-location (component-id ?sink-id)))
    (wall (name N) (width ?wall-width))
    (test (>= ?wall-width ?sink-width))
    (not (opening (type door) (wall-location N)))
    =>
    (bind ?location-for-sink (/ (- ?wall-width ?sink-width) 2))
    (assert (component-location (component-id ?sink-id) (wall-location N) (distance-from-origin ?location-for-sink)))
)

; PLACE-SINK-COMPLETION-RULE
; Marks the sink placement goal as complete once a location is assigned.
(defrule place-sink-completion-rule
    ?goal <- (goal (name goal:place-sink) (status active))
    (kitchen-component (type sink) (id ?sink-id))
    (component-location (component-id ?sink-id))
    =>
    (modify ?goal (status complete))
)

; === RULES FOR GOAL: PLACE-DISHWASHER ===

; PLACE-DW-RULE-1
; Places the dishwasher to the left of the sink.
(defrule place-dw-rule-1
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-left ?left-wall))
    (wall (name ?left-wall) (width ?left-wall-width))
    (test (>= ?sink-dfo ?dw-width))
    (not (opening (wall-location ?left-wall) (width ?open-width) (distance-from-origin ?open-dfo)
                  (test (> (+ ?open-dfo ?open-width) (- ?left-wall-width ?dw-depth)))))
    =>
    (bind ?location-for-dw (- ?sink-dfo ?dw-width))
    (assert (component-location (component-id ?dw-id) (wall-location ?sink-wall) (distance-from-origin ?location-for-dw)))
)
; === RULES FOR GOAL: PLACE-DISHWASHER ===

; PLACE-DW-RULE-2
; Places the dishwasher to the right of the sink if it doesn't fit on the left.
(defrule place-dw-rule-2
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-right ?right-wall))
    (wall (name ?right-wall) (width ?right-wall-width))
    (test (>= (- ?right-wall-width ?sink-dfo ?sink-width) ?dw-width))
    (not (opening (wall-location ?right-wall) (distance-from-origin ?open-dfo) (width ?open-width)
                  (test (< ?open-dfo ?dw-width))))
    =>
    (bind ?location-for-dw (+ ?sink-dfo ?sink-width))
    (assert (component-location (component-id ?dw-id) (wall-location ?sink-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-RULE-3
; Places the dishwasher on the left adjacent wall of the sink if there is enough clearance.
(defrule place-dw-rule-3
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-left ?left-wall))
    (wall (name ?left-wall) (width ?left-wall-width))
    (test (>= (- ?sink-dfo ?dw-width) 0))
    (not (opening (wall-location ?left-wall)))
    =>
    (bind ?location-for-dw (- ?sink-dfo ?dw-width))
    (assert (component-location (component-id ?dw-id) (wall-location ?left-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-RULE-4
; Places the dishwasher on the right adjacent wall if there is enough clearance.
(defrule place-dw-rule-4
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-right ?right-wall))
    (wall (name ?right-wall) (width ?right-wall-width))
    (test (>= (- ?right-wall-width ?dw-width ?sink-depth) 0))
    (not (opening (wall-location ?right-wall)))
    =>
    (bind ?location-for-dw (- ?right-wall-width ?dw-width))
    (assert (component-location (component-id ?dw-id) (wall-location ?right-wall) (distance-from-origin ?location-for-dw)))
)
; PLACE-DW-RULE-5
; Places the dishwasher on the left adjacent wall of the sink, ensuring enough clearance.
; This rule applies when there is not enough room to place the dishwasher immediately near the sink.
(defrule place-dw-rule-5
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth) (clearance ?sink-clearance))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-left ?left-wall))
    (wall (name ?left-wall) (width ?left-wall-width))
    (test (< ?sink-dfo ?dw-depth))
    (test (>= (- ?left-wall-width ?sink-depth ?sink-clearance) ?dw-width))
    (not (opening (wall-location ?left-wall)))
    =>
    (bind ?location-for-dw (- ?left-wall-width (+ ?dw-width ?sink-depth ?sink-clearance)))
    (assert (component-location (component-id ?dw-id) (wall-location ?left-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-RULE-6
; Places the dishwasher on the right adjacent wall of the sink, ensuring enough clearance.
; This rule applies when there is not enough room to place the dishwasher immediately near the sink.
(defrule place-dw-rule-6
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth) (clearance ?sink-clearance))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-right ?right-wall))
    (wall (name ?right-wall) (width ?right-wall-width))
    (test (< (- ?right-wall-width ?sink-dfo ?sink-width) ?dw-depth))
    (test (>= (- ?right-wall-width ?sink-depth ?sink-clearance) ?dw-width))
    (not (opening (wall-location ?right-wall)))
    =>
    (bind ?location-for-dw (+ ?sink-depth ?sink-clearance))
    (assert (component-location (component-id ?dw-id) (wall-location ?right-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-COMPLETION_RULE-1
; Marks the dishwasher placement goal as complete when the dishwasher has been placed.
(defrule place-dw-completion-rule-1
    ?goal <- (goal (name goal:place-dishwasher) (status active))
    (kitchen-component (type dishwasher) (id ?dw-id))
    (component-location (component-id ?dw-id))
    =>
    (modify ?goal (status complete))
)

; PLACE-DW-COMPLETION_RULE-2
; Handles cases where the dishwasher cannot be placed.
(defrule place-dw-completion-rule-2
    (declare (salience -20))
    ?goal <- (goal (name goal:place-dishwasher) (status active))
    (kitchen-component (type dishwasher) (id ?dw-id))
    (not (component-location (component-id ?dw-id)))
    =>
    (format t "%nCannot place the dishwasher with known rules.%n")
    (modify ?goal (status suspended))
)


; PLACE-DW-RULE-5
; Places the dishwasher on the left adjacent wall of the sink, ensuring enough clearance.
; This rule applies when there is not enough room to place the dishwasher immediately near the sink.
(defrule place-dw-rule-5
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth) (clearance ?sink-clearance))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-left ?left-wall))
    (wall (name ?left-wall) (width ?left-wall-width))
    (test (< ?sink-dfo ?dw-depth))
    (test (>= (- ?left-wall-width ?sink-depth ?sink-clearance) ?dw-width))
    (not (opening (wall-location ?left-wall)))
    =>
    (bind ?location-for-dw (- ?left-wall-width (+ ?dw-width ?sink-depth ?sink-clearance)))
    (assert (component-location (component-id ?dw-id) (wall-location ?left-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-RULE-6
; Places the dishwasher on the right adjacent wall of the sink, ensuring enough clearance.
; This rule applies when there is not enough room to place the dishwasher immediately near the sink.
(defrule place-dw-rule-6
    (declare (salience -5))
    (goal (name goal:place-dishwasher) (status active))
    ?dw <- (kitchen-component (type dishwasher) (id ?dw-id) (depth ?dw-depth) (width ?dw-width))
    (not (component-location (component-id ?dw-id)))
    (kitchen-component (type sink) (id ?sink-id) (width ?sink-width) (depth ?sink-depth) (clearance ?sink-clearance))
    (component-location (component-id ?sink-id) (wall-location ?sink-wall) (distance-from-origin ?sink-dfo))
    (wall (name ?sink-wall) (adjacent-right ?right-wall))
    (wall (name ?right-wall) (width ?right-wall-width))
    (test (< (- ?right-wall-width ?sink-dfo ?sink-width) ?dw-depth))
    (test (>= (- ?right-wall-width ?sink-depth ?sink-clearance) ?dw-width))
    (not (opening (wall-location ?right-wall)))
    =>
    (bind ?location-for-dw (+ ?sink-depth ?sink-clearance))
    (assert (component-location (component-id ?dw-id) (wall-location ?right-wall) (distance-from-origin ?location-for-dw)))
)

; PLACE-DW-COMPLETION_RULE-1
; Marks the dishwasher placement goal as complete when the dishwasher has been placed.
(defrule place-dw-completion-rule-1
    ?goal <- (goal (name goal:place-dishwasher) (status active))
    (kitchen-component (type dishwasher) (id ?dw-id))
    (component-location (component-id ?dw-id))
    =>
    (modify ?goal (status complete))
)

; PLACE-DW-COMPLETION_RULE-2
; Handles cases where the dishwasher cannot be placed.
(defrule place-dw-completion-rule-2
    (declare (salience -20))
    ?goal <- (goal (name goal:place-dishwasher) (status active))
    (kitchen-component (type dishwasher) (id ?dw-id))
    (not (component-location (component-id ?dw-id)))
    =>
    (format t "%nCannot place the dishwasher with known rules.%n")
    (modify ?goal (status suspended))
)
