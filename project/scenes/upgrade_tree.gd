class_name UpgradeTree
extends Node


var _is_dragging := false
var _last_mouse_position: Vector2

@onready var camera: Camera2D = %Camera


func _process(_delta: float) -> void:
	_is_dragging =  Input.is_action_pressed("drag")
	
	if not _is_dragging:
		_last_mouse_position = get_viewport().get_mouse_position()
	else:
		var next_mouse_position = get_viewport().get_mouse_position()
		camera.position -= next_mouse_position - _last_mouse_position
		_last_mouse_position = next_mouse_position
