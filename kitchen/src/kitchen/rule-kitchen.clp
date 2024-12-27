; System Initialization: It kick-starts the system by activating the initial
; goals that do not depend on any prerequisites. This is crucial in systems where
; the flow of tasks must be controlled strictly by the completion of preceding tasks.

; Flexibility and Scalability: As the system grows or changes, new goals that also have no dependencies
; (i.e., their follows slot is nil) can be seamlessly integrated and activated without requiring manual
; intervention, thus maintaining system scalability and flexibility.

(defrule start-system-rule
        ?goal <- (goal (follows nil)(status inactive))
        =>
        (modify ?goal (status active))
)

(defrule activate-next-goal
    (goal (name ?active-goal) (status complete)) ;look for all the goals that are completed and save their name in active goal
    ? new-goal <- (goal (name ?inactive-goal) (follows ?active-goal) (status inactive)) ;finds all other goals that have the follows this goal
    =>
    (modify ?newgoal (status active))
)

(defrule halt-system-rule
    ?goal <- (goal (name ?active-goal)(status complete)) ; get all completed goals
    (not (goal (follows ?active-goal))) ; there are no other goals that are waiting for this goal to be completed
    =>
    (halt) ;
)



;PLACE-SINK-RULE-1
;This rule tries to place the sink in front of any window not
;on a wall
;opposite the door.
(defrule place-sink-rule-1
    (goal (name goal: place-sink) (status active))
    ?sink <- (kitchen-component (type sink) (id ?sink-id)(width ?sink-width))
    (not (component-location (component-id ?sink-id)))
    (opening (type window) (wall-location ?wall) (distance-from-origin ?dfo)(width ?win-width))
    (test (>= (+ ?dfo (/ ?win-width 2)) (/ ?sink-width 2)))
    (not (opening (type door) (wall-location ?wall)))
    (wall (name ?wall) (opposite ?opposite-wall))
    (not (opening (type door) (wall-location ?opposite-wall)))
    =>
    (bind ?location-for-sink (- ?dfo (/ (- ?sink-width ?win-width) 2)))
    (assert ( component-location(component-id ?sink-id) (wall-location ?wall)
    (distance-from-origin ?location-for-sink)))
)
;PLACE-SINK-RULE-2
;This rule tries to place the sink in front of any window
;without concern for the door location. This rule should be fired only if rule-1 cannot fire

(defrule place-sink-rule-2
(declare (salience -5))
(goal (name goal:place-sink) (status active))
