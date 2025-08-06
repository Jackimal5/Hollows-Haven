extends CanvasLayer

#Health and Stamina
var health = 100
var stamina = 100

#UI Bars
@onready var StaminaBar: TextureProgressBar = $StaminaBar
@onready var HealthBar: TextureProgressBar = $HealthBar

func _process(delta):
	print(stamina)
	if HealthBar != null and StaminaBar != null and stamina != 100:
		StaminaBar.value = stamina
		HealthBar.value = health
