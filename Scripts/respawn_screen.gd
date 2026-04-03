extends CanvasLayer

@onready var hud: CanvasLayer = $"../HUD"
@onready var orb_label: Label = $OrbLabel


signal respawn_selected

func _ready() -> void:
	hide()
	respawn_selected.connect(RespawnManager.respawn_player)
	RespawnManager.player_died.connect(show_screen)

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_respawn_button_pressed() -> void:
	hide()
	hud.show()
	emit_signal("respawn_selected")
	#respawn player

func show_screen():
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	hud.hide()
	
	var total_collected = CollectibleManager.get_amount(CollectibleManager.CollectibleType.ORB)
	orb_label.text = str(total_collected) + "/4"
