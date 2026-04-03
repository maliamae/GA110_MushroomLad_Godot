extends CanvasLayer

@onready var total_label: Label = $TotalLabel
@onready var hud: CanvasLayer = $"../HUD"
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	CollectibleManager.collectibles_updated.connect(win_screen)

func win_screen():
	#displays node when win condition is met
	var total_collected = CollectibleManager.get_amount(CollectibleManager.CollectibleType.ORB)
	if total_collected == 4:
		show()
		animation_player.play("pop_up")
		print("achievment")
		await get_tree().create_timer(4).timeout
		animation_player.play("pop_down")
		await get_tree().create_timer(1.5).timeout
		hide();
		#hud.hide()
