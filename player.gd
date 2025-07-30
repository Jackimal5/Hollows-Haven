extends CharacterBody3D

#Constants
const walking_speed = 5.0
const sprinting_speed = 7.0
const jump_velocity = 8
const friction = 18.0
const acceleration = 25.0

#States
var sprinting =  false

#Changables
@export var sensitivity = 0.5

#Declared Variables
@onready var camera_origin: Node3D = $PlayerCollider/CameraOrigin

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		camera_origin.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		camera_origin.rotation.x = clamp(camera_origin.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("sprint"):
		sprinting = true
	else:
		sprinting = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
