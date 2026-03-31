extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var next_scene_path = ""

signal scene_changed(scene_path)



func fade_to_scene(scene_path):
	next_scene_path = scene_path
	#Hide HUD scene
	#var hud = get_tree().get_first_node_in_group("hud")
	#if hud:
		#hud.visible = false
	print("fading out")
	animation_player.play("fade_out")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		await get_tree().create_timer(1.0).timeout #wait 1 sec
		get_tree().change_scene_to_file(next_scene_path)
		emit_signal("scene_changed", next_scene_path)
		animation_player.play("fade_in")
