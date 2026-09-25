class_name UpgradeTree
extends Node

const _LINE_WIDTH := 2
const _UPGRADE_NODE_SIZE := Vector2(32, 32)

var _is_dragging := false:
	set(value):
		_is_dragging = value
		set_process(_is_dragging)
		_last_mouse_position = get_viewport().get_mouse_position()
var _last_mouse_position: Vector2
var _money := 0:
	set(value):
		_money = value
		_money_label.text = "$%s" % _money

		for child in _upgrade_nodes_map.values():
			child.notify_money_change(_money)
var _upgrade_nodes_map: Dictionary[int, UpgradeNode]

@onready var _camera: Camera2D = %Camera
@onready var _money_label: Label = %MoneyLabel
@onready var _upgrades_nodes: Control = %UpgradesNodes


func _ready() -> void:
	set_process(false)

	for child in _upgrades_nodes.get_children():
		if child is UpgradeNode:
			child.purchased.connect(_on_upgrade_purchased)
			child.upgrade_unlocked.connect(_on_upgrades_unlocked)
			child.hide()

			var id: int = child.data.id
			assert(not _upgrade_nodes_map.has(id), "Duplicate Upgrade IDs: %s" % id)
			_upgrade_nodes_map[id] = child

	_draw_node_connections()

	_upgrade_nodes_map.get(0).show()

	_money = _money


func _process(_delta: float) -> void:
	var next_mouse_position = get_viewport().get_mouse_position()
	_camera.position += _last_mouse_position - next_mouse_position
	_last_mouse_position = next_mouse_position


func _input(event: InputEvent) -> void:
	if event.is_action("drag"):
		_is_dragging = event.is_pressed()


func _on_add_money_button_pressed() -> void:
	_money += 1


func _on_remove_money_button_pressed() -> void:
	_money -= 1


func _draw_node_connections() -> void:
	for node in _upgrade_nodes_map.values():
		for upgrade_id in node.data.unlocks:
			var target_node := _upgrade_nodes_map[upgrade_id]
			var line := Line2D.new()
			line.z_as_relative = false
			line.width = _LINE_WIDTH
			line.points = [
				_UPGRADE_NODE_SIZE / 2,
				target_node.position - node.position + _UPGRADE_NODE_SIZE / 2,
			]
			line.hide()
			node.add_child(line)


func _on_upgrade_purchased(cost: int) -> void:
	_money -= cost


func _on_upgrades_unlocked(upgrade_ids: Array[int]) -> void:
	for upgrade_id in upgrade_ids:
		var upgrade_node := _upgrade_nodes_map[upgrade_id]
		upgrade_node.show()
