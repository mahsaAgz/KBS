(deftemplate item
  (slot name (type SYMBOL))
  (slot value (type INTEGER))
  (slot to-be-process(type SYMBOL)(default yes))
  (slot processed (type SYMBOL) (default no))
  (slot changed (type SYMBOL) (default no))
  (slot dependent-items (type SYMBOL) (default nil))
)

(deftemplate process-state
  (slot done (type SYMBOL) (default no))  ; Slot to track if processing is completed
)
