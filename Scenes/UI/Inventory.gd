extends Node2D

const INVENTORY_SIZE: int = 50

var inventoryContents: Array = []
var isInvOpen: bool = false

func AddItemToInv(newItem):
	if inventoryContents.size() < 50:
		inventoryContents.append(newItem)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
