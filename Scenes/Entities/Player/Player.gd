extends CharacterBody2D


const MOVESPEED = 300.0
const JUMP_VELOCITY = -400.0

var moveRight: bool = false
var moveLeft: bool = false
var moveUp: bool = false
var moveDown: bool = false

func _physics_process(_delta: float) -> void:
	#reset velocity in case it doesnt do it on its own
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("MoveUp"):
		moveUp = true
	if Input.is_action_pressed("MoveRight"):
		moveRight = true
	if Input.is_action_pressed("MoveDown"):
		moveDown = true
	if Input.is_action_pressed("MoveLeft"):
		moveLeft = true
	
	#movement keys released
	if Input.is_action_just_released("MoveUp"):
		moveUp = false
	if Input.is_action_just_released("MoveRight"):
		moveRight = false
	if Input.is_action_just_released("MoveDown"):
		moveDown = false
	if Input.is_action_just_released("MoveLeft"):
		moveLeft = false
	
	if moveRight == true:
		velocity.x += MOVESPEED
	elif moveLeft == true:
		velocity.x -= MOVESPEED
		
	if moveUp == true:
		velocity.y -= MOVESPEED
	elif moveDown == true:
		velocity.y += MOVESPEED

	move_and_slide()
