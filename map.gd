extends Node2D

@onready var hover_shader: ShaderMaterial = preload("res://hover.tres")

@onready var player: Entity = get_node("player");

@onready var astar = AStarGrid2D.new();
@onready var ground: TileMapLayer = get_node("ground");
@onready var props: TileMapLayer = get_node("props");

func _ready() -> void:
	SignalBus.navigate.connect(_on_navigate);

	astar.region = ground.get_used_rect();
	astar.update();

	for cell in props.get_used_cells():
		astar.set_point_solid(cell);

func _process(_delta: float) -> void:
	var hovered_cell = to_global(ground.map_to_local(ground.local_to_map(get_local_mouse_position())));
	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell);

	if Input.is_action_just_pressed("navigate_player"):
		navigate_entity(player, ground.local_to_map(get_local_mouse_position()));

func _on_navigate(idx: int, new_pos: Vector2) -> void:
	navigate_entity(get_child(idx), new_pos);

func navigate_entity(e: Entity, new_pos: Vector2) -> void:
	var path = astar.get_id_path(e.map_position, new_pos);
	if path.size() > 1:
		e.navigate(path);
