extends CharacterBody3D

#Constants
const walking_speed = 5.0
const sprinting_speed = 7.0
const jump_velocity = 8
const friction = 18.0
const acceleration = 25.0
const regular_gravity = 9.8
const released_gravity = 23.0

#States
var sprinting =  false
var jumped = false
var released_jump = false

#Changables
@export var sensitivity = 0.5

#Declared Nodes
@onready var camera_origin: Node3D = $PlayerCollider/CameraOrigin
@onready var animation_player = $PlayerAnimations


#func _ready():
	#Captures Mouse
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	#Camera Movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		camera_origin.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		camera_origin.rotation.x = clamp(camera_origin.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
func _physics_process(delta: float) -> void:
	#Adds Gravity
	if not is_on_floor():
		if !jumped:
			velocity.y += -regular_gravity * delta
		else:
			if !released_jump:
				if Input.is_action_pressed("jump"):
					velocity.y += -regular_gravity * delta
				else:
					velocity.y += -released_gravity * delta
					released_jump = true
			else:
				velocity.y += -released_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		released_jump = false
		jumped = true
	
	#Exit Game
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	
	#Handels Sprinting Logic
	if Input.is_action_pressed("sprint"):
		sprinting = true
	else:
		sprinting = false
	
	#Sword Attack 
	if Input.is_action_just_pressed("left_click"):
		animation_player.speed_scale = 1.5
		animation_player.play("swing")
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Moves the Player
	if direction:
		if sprinting:
			velocity.x = move_toward(velocity.x, direction.x * sprinting_speed, acceleration * delta)
			velocity.z = move_toward(velocity.z, direction.z * sprinting_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction.x * walking_speed, acceleration * delta)
			velocity.z = move_toward(velocity.z, direction.z * walking_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	move_and_slide()
