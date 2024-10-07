extends PanelContainer


func _ready() -> void:
	pass # Replace with function body.

func _on_host_button_pressed() -> void:
	Lobby.create_game()
	get_tree().change_scene_to_file("res://lobby.tscn")

func _on_join_button_pressed() -> void:
	# var address: String = $Menu/MarginContainer/MenuContainer/JoinContainer/AddressInput.get_text()

	Lobby.join_game("")
	get_tree().change_scene_to_file("res://lobby.tscn")
