extends Interactable

@export var cutscene : Cutscene

func do_function():
	PlayerInfo.is_world_frozen = true
	cutscene.start()
	pass


func answer(choice : String):
	if choice == "Yes":
		heal()
	if choice == "No":
		await get_tree().create_timer(0.1).timeout
		PlayerInfo.is_world_frozen = false
	pass


func heal():
	print("Healing")
	PlayerInfo.is_world_frozen = true
	PlayerInfo.last_heal_position = player.position
	for character in PlayerInfo.party:
		character.hp = character.stats["health"]
		character.bp = character.stats["stamina"]
	PlayerInfo.current_overworld_scene = get_tree().current_scene.scene_file_path
	PlayerInfo.current_overworld_position = player.position
	for enemy in PlayerInfo.area_enemies:
		PlayerInfo.area_enemies[enemy] = true
	SceneLoader.load_scene(PlayerInfo.current_overworld_scene)
	pass
