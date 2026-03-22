extends Node

var windows : Array[Control]
var previous_status : Array[Array] = [[0, 0], [0, 0], [0, 0], [0, 0]]
var first_update = true


func _ready() -> void:
	for child in get_children():
		if child is Control:
			windows.append(child)
	
	update_status()
	pass


func update_status() -> void:
	var i = 0
	while i < windows.size():
		if i < PlayerInfo.party.size():
			var hp_bar = windows[i].get_child(-1).get_node("HP Bar") as ProgressBar
			var sp_bar = windows[i].get_child(-1).get_node("SP Bar") as ProgressBar
			var assigned_char = PlayerInfo.party[i]
			var sprite = windows[i].get_node("TextureRect") as TextureRect
			
			hp_bar.max_value = assigned_char.stats["health"]
			hp_bar.value = assigned_char.hp
			if !first_update:
				if hp_bar.value < previous_status[i][0]:
					damage(sprite)
				elif hp_bar.value > previous_status[i][0]:
					heal(sprite)
			previous_status[i][0] = hp_bar.value
			
			sp_bar.max_value = assigned_char.stats["stamina"]
			sp_bar.value = assigned_char.bp
			previous_status[i][1] = sp_bar.value
			
			if hp_bar.value == 0:
				sprite.modulate = Color.DIM_GRAY
		else:
			windows[i].hide()
		
		i += 1
		pass
	first_update = false
	pass


func damage(sprite : TextureRect):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	var start_position = sprite.position.x
	var t = 0.8
	var dir = 1
	tween.chain().tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.chain().tween_property(sprite, "modulate", Color.WHITE, 0.2)
	while t > 0:
		sprite.position.x = start_position + 4 * t * dir
		dir *= -1
		t -= 0.1
		await get_tree().create_timer(0.1).timeout
	sprite.position.x = start_position
	pass


func heal(sprite : TextureRect):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.GREEN, 0.3)
	tween.chain().tween_property(sprite, "modulate", Color.GREEN, 0.2)
	tween.chain().tween_property(sprite, "modulate", Color.WHITE, 0.3)
	pass
