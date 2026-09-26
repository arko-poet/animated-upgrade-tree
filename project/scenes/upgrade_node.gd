class_name UpgradeNode
extends TextureButton

signal purchased(cost: int)
signal upgrade_unlocked(upgrade_ids: Array[int])

const _MAX_COLOR := Color(0.957, 0.89, 0.467, 1.0)
const _AFFORDABLE_COLOR := Color(0.424, 0.949, 0.502, 1.0)
const _UNAFFORDABLE_COLOR := Color(0.835, 0.278, 0.322, 1.0)
const _HOVER_TWEEN_DURATION := 0.05
const _HOVER_SCALE := Vector2(1.2, 1.2)

@export var data: UpgradeData

var upgrades_purchased: int

@onready var border: Panel = %Border
@onready var background: Panel = %Background


func _ready() -> void:
	assert(data, "%s is missing UpgradeData Resource" % name)

	texture_normal = data.icon


func notify_money_change(money: int) -> void:
	var style_box: StyleBoxFlat = border.get_theme_stylebox(&"panel").duplicate()
	disabled = upgrades_purchased == data.max_upgrades or data.cost > money
	if upgrades_purchased == data.max_upgrades:
		style_box.border_color = _MAX_COLOR
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	elif data.cost <= money:
		style_box.border_color = _AFFORDABLE_COLOR
	else:
		style_box.border_color = _UNAFFORDABLE_COLOR
	border.add_theme_stylebox_override(&"panel", style_box)


func _on_pressed() -> void:
	if upgrades_purchased < data.max_upgrades:
		upgrades_purchased += 1
		purchased.emit(data.cost)

		if upgrades_purchased == 1:
			for child in get_children():
				if child is Line2D:
					child.show()
			upgrade_unlocked.emit(data.unlocks)


func _on_mouse_entered() -> void:
	if upgrades_purchased == data.max_upgrades:
		return
	_animate_hover_scale(_HOVER_SCALE)


func _on_mouse_exited() -> void:
	_animate_hover_scale(Vector2.ONE)


func _animate_hover_scale(scale: Vector2) -> void:
	var tween := create_tween()
	tween.tween_property(border, ^"scale", scale, _HOVER_TWEEN_DURATION)
	tween.parallel()
	tween.tween_property(background, ^"scale", scale, _HOVER_TWEEN_DURATION)
