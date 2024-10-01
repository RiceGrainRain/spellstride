extends CharacterBody2D
@onready var tile_map = $".."
@onready var sprite_2d = $Sprite2D
@onready var player_sprite = $AnimatedSprite2D
var is_moving = false
var indicator_offset = 16  

func _physics_process(delta):

	if not is_moving:
		return
	
	if global_position == tile_map.map_to_local(tile_map.local_to_map(global_position)):
		is_moving = false

func _process(_delta):
	if is_moving:
		return 

	update_indicator() 

	
	if Input.is_action_just_pressed("ui_up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("ui_down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("ui_left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		move(Vector2.RIGHT)


func update_indicator():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	

	if abs(direction.x) > abs(direction.y): 
		if direction.x > 0:
			sprite_2d.play("right")
			player_sprite.flip_h = true
			sprite_2d.global_position = global_position + Vector2(indicator_offset, -indicator_offset) 
		else:
			sprite_2d.play("left")
			player_sprite.flip_h = false
			sprite_2d.global_position = global_position + Vector2(-indicator_offset, indicator_offset);  
	else:
		if direction.y > 0:
			sprite_2d.play("down")
			sprite_2d.global_position = global_position + Vector2(indicator_offset, indicator_offset); 
		else:
			sprite_2d.play("up")
			sprite_2d.global_position = global_position + Vector2(-indicator_offset, -indicator_offset);  

func move(direction: Vector2):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	

	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	
	is_moving = true
	global_position = tile_map.map_to_local(target_tile) 


