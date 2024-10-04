extends TileMapLayer

@onready var hover_shader: ShaderMaterial = preload("res://hover.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var hovered_cell = to_global(map_to_local(local_to_map(get_local_mouse_position())));
	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell);
