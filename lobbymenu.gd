extends PanelContainer


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		Lobby.load_game.rpc("res://level.tscn");
