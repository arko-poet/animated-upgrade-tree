class_name UpgradeTree
extends Node


var _is_dragging := false:
	set(value):
		_is_dragging = value
		set_process(_is_dragging)
		_last_mouse_position = get_viewport().get_mouse_position()
var _last_mouse_position: Vector2

@onready var _camera: Camera2D = %Camera


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	var next_mouse_position = get_viewport().get_mouse_position()
	_camera.position += _last_mouse_position - next_mouse_position
	_last_mouse_position = next_mouse_position


func _input(event: InputEvent) -> void:
	if event.is_action("drag"):
		_is_dragging = event.is_pressed()
