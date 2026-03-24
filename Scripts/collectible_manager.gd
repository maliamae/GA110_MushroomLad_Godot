extends Node

enum CollectibleType {COIN, GEM, ORB}

signal collectibles_updated

var collectibles : Dictionary[int, int]={}

func _ready() -> void:
	reset()

func reset():
	collectibles.clear()
	for type in CollectibleType.values():
		collectibles[type] = 0
		emit_signal("collectibles_updated")

func add_collectible(type: CollectibleType, amount :=1):
	if not collectibles.has(type):
		collectibles[type] = 0
	
	collectibles[type] += amount
	print(CollectibleType.keys()[type], ": ", collectibles[type])
	emit_signal("collectibles_updated")

func get_amount(type: CollectibleType)-> int:
	return collectibles.get(type, 0)
