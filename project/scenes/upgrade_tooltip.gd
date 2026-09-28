class_name UpgradeTooltip
extends PanelContainer


var _upgrade_data: UpgradeData
var _upgrades_purchased: int

@onready var _title_label: Label = %TitleLabel
@onready var _cost_label: Label = %CostLabel
@onready var _upgrades_label: Label = %UpgradesLabel


func set_text(upgrade_data: UpgradeData, upgrades_purchased: int) -> void:
	_upgrade_data = upgrade_data
	_upgrades_purchased = upgrades_purchased


func _ready() -> void:
	_title_label.text = _upgrade_data.name
	_cost_label.text = "$%s" % _upgrade_data.cost
	_upgrades_label.text = "%s/%s" % [_upgrades_purchased, _upgrade_data.max_upgrades]
	
	scale = Vector2(1, 0)
	
	var tween := create_tween()
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.2)
