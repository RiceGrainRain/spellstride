extends Node2D

class_name Map;

@export var diagonal_mode: AStarGrid2D.DiagonalMode = AStarGrid2D.DiagonalMode.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES;

@onready var hover_shader: ShaderMaterial = preload("res://hover.tres")

@onready var astar = AStarGrid2D.new();
@onready var ground: TileMapLayer = get_node("ground");
@onready var props: TileMapLayer = get_node("props");

func _ready() -> void:
	SignalBus.navigate.connect(_on_navigate);

	var topleft = ground.get_used_rect().position;
	var bottomright = ground.get_used_rect().end;
	var topright = Vector2(bottomright.x, topleft.y);
	var bottomleft = Vector2(topleft.x, bottomright.y);
	Globals.camera_constraint = Rect2(Vector2(map_to_global(bottomleft).x, map_to_global(topleft).y),
																		Vector2(map_to_global(topright).x, map_to_global(bottomright).y));
	get_node("../Camera2D").set_offset(Globals.camera_constraint.get_center());

	astar.set_diagonal_mode(diagonal_mode);
	astar.set_region(ground.get_used_rect());
	astar.update();

	for cell in props.get_used_cells():
		astar.set_point_solid(cell);

	for x in range(astar.region.position.x, astar.region.end.x):
		for y in range(astar.region.position.y, astar.region.end.y):
			var cell = Vector2(x, y);
			if ground.get_cell_source_id(cell) == -1:
				astar.set_point_solid(cell);

func _process(_delta: float) -> void:
	var hovered_cell = ground.local_to_map(get_local_mouse_position());
	var hovered_cell_global_coords = to_global(ground.map_to_local(hovered_cell));
	if astar.is_in_boundsv(hovered_cell) and astar.is_point_solid(hovered_cell):
		hover_shader.set_shader_parameter("reachable", 1.0);
	else:
		hover_shader.set_shader_parameter("reachable", 0.0);

	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell_global_coords);

	if Input.is_action_just_pressed("navigate_player"):
		navigate_entity.rpc(str(multiplayer.get_unique_id()), ground.local_to_map(get_local_mouse_position()));

func _on_navigate(entity_name: String, new_pos: Vector2) -> void:
	navigate_entity(entity_name, new_pos);

@rpc("any_peer", "call_local", "reliable")
func navigate_entity(entity_name: String, new_pos: Vector2) -> void:
	var e: Entity = get_node(entity_name);
	var path = astar.get_id_path(e.map_position, new_pos);
	if path.size() > 1:
		e.navigate(path);

func map_to_global(vec: Vector2) -> Vector2:
	return to_global(ground.map_to_local(vec));

@rpc("any_peer", "call_local", "reliable")
func set_reachable(pos: Vector2, reachable: bool = true) -> void:
	astar.set_point_solid(pos, !reachable);
