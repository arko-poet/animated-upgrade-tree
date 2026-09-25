class_name UpgradeNode
extends TextureButton

const _MAX_COLOR := Color(0.957, 0.89, 0.467, 1.0)
const _AFFORDABLE_COLOR := Color(0.424, 0.949, 0.502, 1.0)
const _UNAFFORDABLE_COLOR := Color(0.835, 0.278, 0.322, 1.0)

@export var data: UpgradeData
@onready var border: Panel = %Border


func _ready() -> void:
	if not data:
		return
	
	texture_normal = data.icon
	
	
func notify_money_change(money: int) -> void:
	var style_box: StyleBoxFlat = border.get_theme_stylebox(&"panel").duplicate()
	if data.cost <= money:
		style_box.border_color = _AFFORDABLE_COLOR
	else:
		style_box.border_color = _UNAFFORDABLE_COLOR
	border.add_theme_stylebox_override(&"panel", style_box)
