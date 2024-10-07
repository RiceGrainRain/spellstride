extends Node


const PLAYER = preload("res://player.tscn")
@onready var map: Map = get_node("map");

func _ready() -> void:
	add_player.rpc(multiplayer.get_unique_id())

@rpc("any_peer", "call_local", "reliable")
func add_player(peer_id):
	var player = PLAYER.instantiate();
	player.name = str(peer_id);
	player.is_player = true;
	player.map_position = Vector2(1, 3);

	map.set_reachable(player.map_position, false);
	map.add_child(player);
