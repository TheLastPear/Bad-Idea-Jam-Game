extends Interactable


func do_function():
	print("Healing")
	player.locked_movement = true
	for character in PlayerInfo.party:
		character.hp = character.stats["health"]
		character.bp = character.stats["stamina"]
	PlayerInfo.current_overworld_scene = get_tree().current_scene.scene_file_path
	PlayerInfo.current_overworld_position = player.position
	for enemy in PlayerInfo.area_enemies:
		PlayerInfo.area_enemies[enemy] = true
	SceneLoader.load_scene(PlayerInfo.current_overworld_scene)
	pass
