@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Entity", "AnimatedSprite2D", preload("entity.gd"), preload("icon.svg"));

func _exit_tree() -> void:
	remove_custom_type("Entity");
