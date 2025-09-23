extends Node2D

const SEEDLING = 0
const SPROUT = 1
const GROWTHLING = 2
const FULLGROWN = 3

@onready var groundLayer: TileMapLayer = $GroundLayer	
@onready var player: Node2D = $Player
@onready var plantLayer: TileMapLayer = $PlantLayer
@onready var playerScript = load("res://Scenes/Entities/Player/Player.gd").new()

var FarmGroundTileSet: TileSet = null


func CheckDistanceToDesiredTile(originTile: Vector2, desiredTile: Vector2) -> Vector2:
	return originTile - desiredTile

func TillGround(tileLocation: Vector2): 
	var tileSetID: int = 0
	var tileSetAtlasLocation: Vector2 = Vector2(0, 0)
	groundLayer.set_cell(tileLocation, tileSetID, tileSetAtlasLocation)
		

func PlantSeed(tileLocation: Vector2):
	var tileSetID: int = 0
	var tileSetAtlasLocation: Vector2 = Vector2(SEEDLING, 0)
	
	plantLayer.set_cell(tileLocation, tileSetID, tileSetAtlasLocation)
	AddPlantGrowthTimer(tileLocation, SEEDLING)
	
func UpdatePlantStage(tileLocation: Vector2, currentGrowthStage: int):
	var tileSetID: int = 0
	var nextGrowthStage: int = -1
	var isFullyGrown: bool = false
	var tileSetAtlasLocation: Vector2 = Vector2(0,0)
	
	match currentGrowthStage:
		SEEDLING:
			nextGrowthStage = SPROUT
		SPROUT:
			nextGrowthStage = GROWTHLING
		GROWTHLING:
			nextGrowthStage = FULLGROWN
		FULLGROWN:
			isFullyGrown = true
			
	if nextGrowthStage != -1:
		tileSetAtlasLocation = Vector2(nextGrowthStage, 0)
	
	if not isFullyGrown:
		AddPlantGrowthTimer(tileLocation, nextGrowthStage)
		plantLayer.set_cell(tileLocation, tileSetID, tileSetAtlasLocation)
		

func AddPlantGrowthTimer(tileLocation: Vector2, nextGrowthStage: int):
	var PlantGrowthTimer: Timer = Timer.new()
	add_child(PlantGrowthTimer)
	
	PlantGrowthTimer.wait_time = 30
	PlantGrowthTimer.one_shot = true
	PlantGrowthTimer.autostart = false

	PlantGrowthTimer.timeout.connect(Callable(self, "UpdatePlantStage").bind(tileLocation, nextGrowthStage))
	PlantGrowthTimer.start()

#func _input(event):
	#if event is InputEventMouseButton:
		#
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#var mouseClickLocationOnMap: Vector2i  = groundLayer.local_to_map(groundLayer.get_local_mouse_position())
			#var tileData: TileData = groundLayer.get_cell_tile_data(mouseClickLocationOnMap)
			#var interactDistance: int = playerScript.GetInteractDistance()
			#var canInteract: bool = false
			#var distanceToTile: Vector2 = CheckDistanceToDesiredTile(playerLocationOnMap, mouseClickLocationOnMap)
			#if abs(distanceToTile.x) <= interactDistance and abs(distanceToTile.y) <= interactDistance:
				#canInteract = true
			#if tileData.get_custom_data("isGrass") and canInteract:
				#TillGround(mouseClickLocationOnMap)
			#if tileData.get_custom_data("isDirt") and canInteract:
				#PlantSeed(mouseClickLocationOnMap)

func OnPlayerClick(mouseClickLocation, playerGlobalLocation):
	var playerLocationOnMap: Vector2 = groundLayer.local_to_map(groundLayer.to_local(playerGlobalLocation))
	var mouseCanvasToGlobal: Vector2 = groundLayer.get_global_transform_with_canvas().affine_inverse() * mouseClickLocation
	var mouseClickLocationOnMap: Vector2i  = groundLayer.local_to_map(mouseCanvasToGlobal)
	var tileData: TileData = groundLayer.get_cell_tile_data(mouseClickLocationOnMap)
	if not tileData:
		return
	var interactDistance: int = playerScript.GetInteractDistance()
	var canInteract: bool = false
	var distanceToTile: Vector2 = CheckDistanceToDesiredTile(playerLocationOnMap, mouseClickLocationOnMap)
	if abs(distanceToTile.x) <= interactDistance and abs(distanceToTile.y) <= interactDistance:
		canInteract = true
	if tileData.get_custom_data("isGrass") and canInteract:
		TillGround(mouseClickLocationOnMap)
	if tileData.get_custom_data("isDirt") and canInteract:
		PlantSeed(mouseClickLocationOnMap)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FarmGroundTileSet = groundLayer.tile_set
	SignalManager.PlayerClicked.connect(OnPlayerClick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
