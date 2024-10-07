extends Camera2D


func _ready() -> void:
	set_offset(Globals.camera_constraint.get_center());


func _process(_delta: float) -> void:
	var x: float = Input.get_action_strength("pan_right") - Input.get_action_strength("pan_left");
	var y: float = Input.get_action_strength("pan_down") - Input.get_action_strength("pan_up");
	var speed: float = 1.4;

	var target: Vector2 = offset + (speed * Vector2(x, y)) ;
	if Globals.camera_constraint.has_point(target):
		set_offset(target);
	
