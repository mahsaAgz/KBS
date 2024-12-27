; Corrected assert statements for goals
(assert (goal (name "goal:get-initial-data") (follows nil)))
(assert (goal (name "goal:place-sink") (follows nil)))
(assert (goal (name "goal:place-dishwasher") (follows "goal:place-sink")))
(assert (goal (name "goal:place-refrigerator") (follows "goal:place-dishwasher")))
(assert (goal (name "goal:place-stove") (follows "goal:place-refrigerator")))
(assert (goal (name "goal:place-island") (follows "goal:place-stove")))
(assert (goal (name "goal:evaluate-and-print") (follows "goal:place-island")))

; Corrected assert statements for kitchen and walls
(assert (kitchen (x-dimension 12) (y-dimension 12)))
(assert (wall (name N) (width 10) (opposite S) (adjacent-right E) (adjacent-left W)))
(assert (wall (name S) (width 10) (opposite N) (adjacent-right W) (adjacent-left E)))
(assert (wall (name E) (width 12) (opposite W) (adjacent-right S) (adjacent-left N)))
(assert (wall (name W) (width 12) (opposite E) (adjacent-right N) (adjacent-left S)))

; Corrected assert statements for openings
(assert (opening (type window) (wall-location N) (distance-from-origin 4) (width 3) (clearance 3)))
(assert (opening (type door) (wall-location S) (distance-from-origin 4) (width 3) (clearance 3)))

; Corrected assert statements for kitchen components
(assert (kitchen-component (id 1) (type sink) (width 4) (depth 3) (clearance 3)))
(assert (kitchen-component (id 2) (type stove) (width 3) (depth 3) (clearance 3)))
(assert (kitchen-component (id 3) (type refrigerator) (width 3) (depth 3) (clearance 3)))
(assert (kitchen-component (id 4) (type dishwasher) (width 2) (depth 3) (clearance 3)))
