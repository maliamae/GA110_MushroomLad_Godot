extends CanvasLayer

@onready var coin_label: Label = %CoinLabel


var CT = CollectibleManager.CollectibleType

func _ready():
	CollectibleManager.collectibles_updated.connect(update_ui)
	update_ui()

func update_ui():
	coin_label.text = "Coins: " + str(CollectibleManager.get_amount(CT.COIN))
	
