extends TileMapLayer

@onready var player: Node2D = $"../Player"

var FarmGroundTileSet: TileSet = tile_set

func TillGround(tileLocation: Vector2):
	var playerLocationOnMap: Vector2 = local_to_map(player.position) 
	var tileSetID: int = 0
	var tileSetAtlasLocation: Vector2 = Vector2(0, 0)
	
	set_cell(tileLocation, tileSetID, tileSetAtlasLocation)
		

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouseClickLocationOnMap: Vector2i  = local_to_map(get_local_mouse_position())
			var tileData: TileData = get_cell_tile_data(mouseClickLocationOnMap)
			
			if tileData.get_custom_data("isGrass"):
				TillGround(mouseClickLocationOnMap)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
