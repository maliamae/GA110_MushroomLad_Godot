extends Node

enum CollectibleType {COIN, GEM, ORB}

signal collectibles_updated
signal collectible_added(type)

var collectibles : Dictionary[int, int]={}
#list to store collectibles collected since last checkpoint
var stored_collectibles : Array

func _ready() -> void:
	#ensures players start from 0 collectibles
	reset()

func reset():
	#reset collectible values to 0 and upadtes UI
	collectibles.clear()
	for type in CollectibleType.values():
		collectibles[type] = 0
		emit_signal("collectibles_updated")

func add_collectible(type: CollectibleType, amount :=1):
	#adds amount of collectibles collected to stored variable according to type
	if not collectibles.has(type):
		collectibles[type] = 0
	
	collectibles[type] += amount
	#print(CollectibleType.keys()[type], ": ", collectibles[type])
	
	#sends signal to UI
	emit_signal("collectibles_updated")
	emit_signal("collectible_added", type)

func get_amount(type: CollectibleType)-> int:
	#returns amount of collectible type
	return collectibles.get(type, 0)

func set_amount(type: CollectibleType, amount: int):
	#sets amount of collectible type
	if collectibles.has(type):
		collectibles[type] = amount
	
	#respawns any stored collectibles in list that are not visible
	respawn_stored_list()
	#update UI
	emit_signal("collectibles_updated")

func store_collectible(collectible):
	#adds collectible to list when collected
	if not stored_collectibles.has(collectible):
		stored_collectibles.append(collectible)
	
	#print(stored_collectibles)

func reset_stored_list():
	#destroys each collectible in stored list and clears list
	#called when new checkpoint is reached
	if stored_collectibles != null:
		#print(stored_collectibles)
		for item in stored_collectibles:
			if is_instance_valid(item):
				item.queue_free()
				item = null
		stored_collectibles.clear()
	else:
		return

func respawn_stored_list():
	#shows invisible collectibles from list and removes them from the list
	#when player is respawned
	if stored_collectibles != null:
		#print(stored_collectibles)
		for item in stored_collectibles:
			if is_instance_valid(item):
				item.show()
		stored_collectibles.clear()
	else:
		return
