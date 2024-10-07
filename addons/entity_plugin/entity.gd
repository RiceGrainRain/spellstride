extends AnimatedSprite2D

class_name Entity;

@export var map_position: Vector2;
@export var speed: float = 3;
@export var max_health: int = 10;
@export var is_player: bool = false;

@onready var health: int = max_health;
@onready var player_id: String;

@onready var map: Map = get_parent();
var tween: Tween;

func _enter_tree():
	if is_player:
		set_multiplayer_authority(str(name).to_int());

func _ready():
	if is_player and not is_multiplayer_authority(): return;

	position = get_node("../ground").map_to_local(map_position);

func navigate(path):
	if is_player and not is_multiplayer_authority(): return;

	if tween and tween.is_running():
		tween.kill();

	tween = create_tween();
	for pos in path.slice(1):
		tween.tween_property(self, "position", get_parent().map_to_global(pos), 1.0 / speed);
		tween.tween_callback(func(): 
			map.set_reachable.rpc(map_position);
			map_position = pos;
			map.set_reachable.rpc(map_position, false);
		);
