extends CanvasLayer

@onready var orb_label: Label = %CoinLabel


var CT = CollectibleManager.CollectibleType

func _ready():
	CollectibleManager.collectibles_updated.connect(update_ui)
	update_ui()

func update_ui():
	orb_label.text = "Orbs: " + str(CollectibleManager.get_amount(CT.ORB))
	
