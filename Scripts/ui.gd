extends CanvasLayer

#Health and Stamina
var health = 100
var stamina = 100

#UI Bars
@onready var StaminaBar: TextureProgressBar = $StaminaBar
@onready var HealthBar: TextureProgressBar = $HealthBar

func _ready():
	health = 100
	stamina = 100

func _process(delta):
	print("Stamina:", StaminaBar)
	print("Health:", HealthBar)
	StaminaBar = $StaminaBar
	HealthBar = $HealthBar
	#StaminaBar.value = stamina
	#HealthBar.value = health
