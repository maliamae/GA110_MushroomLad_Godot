extends CanvasLayer

@onready var total_label: Label = $TotalLabel
@onready var hud: CanvasLayer = $"../HUD"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	CollectibleManager.collectibles_updated.connect(win_screen)

func win_screen():
	#displays node when win condition is met
	var total_collected = CollectibleManager.get_amount(CollectibleManager.CollectibleType.ORB)
	if total_collected == 4:
		show()
		hud.hide()
