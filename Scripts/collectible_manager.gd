extends Node

enum CollectibleType {COIN, GEM, ORB}

signal collectibles_updated

var collectibles : Dictionary[int, int]={}

var stored_collectibles : Array

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

func set_amount(type: CollectibleType, amount: int):
	if collectibles.has(type):
		collectibles[type] = amount
	
	respawn_stored_list()
	emit_signal("collectibles_updated")

func store_collectible(collectible):
	if not stored_collectibles.has(collectible):
		stored_collectibles.append(collectible)
	
	#print(stored_collectibles)

func reset_stored_list():
	if stored_collectibles != null:
		#print(stored_collectibles)
		for item in stored_collectibles:
			item.queue_free()
		stored_collectibles.clear()
	else:
		return

func respawn_stored_list():
	if stored_collectibles != null:
		#print(stored_collectibles)
		for item in stored_collectibles:
			item.show()
		stored_collectibles.clear()
	else:
		return
