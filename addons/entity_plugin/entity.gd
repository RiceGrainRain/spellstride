extends AnimatedSprite2D

class_name Entity;

@export var map_position: Vector2;
@export var speed: float = 4;

@onready var ground: TileMapLayer = get_parent().get_node("ground");
var tween: Tween;

func _ready():
	position = ground.map_to_local(map_position);

func navigate(path):
	if !tween or !tween.is_running():
		tween = create_tween();
		for pos in path.slice(1):
			tween.tween_property(self, "position", ground.map_to_local(pos), 1.0 / speed);
			tween.tween_callback(func(): map_position = pos);
