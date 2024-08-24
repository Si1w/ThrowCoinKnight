extends CanvasLayer

@onready var item_choose = $item_choose
@onready var item_template = $item_choose/item_template
@onready var attr_list = $Panel/MarginContainer/ScrollContainer/attr_list
@onready var attr_template = $Panel/MarginContainer/ScrollContainer/attr_list/attr_template
@onready var refresh = $refresh
@onready var continue_btn = $continue
@onready var update = $update

var player
signal continue_game

const attr_group = {
	"attack": {
		"name": "Attack",
		"type1": {
			"name": "basic_dmg",
			"img": "res://assets/IconGodotNode/node_2D/basic_dmg.png"
		},
		"type2": {
			"name": "basic_dmg_multiple",
			"img": "res://assets/IconGodotNode/node_2D/basic_dmg.png"
		},
	},
	"speed":{
		"name": "Speed",
		"type1": {
			"name": "speed",
			"img": "res://assets/IconGodotNode/node_2D/speed.png"
		}
	},
	"HP":{
		"name": "HP",
		"type1": {
			"name": "max_hp",
			"img": "res://assets/IconGodotNode/node_2D/max_hp.png"
		}
	},
	"Get_add": {
		"name": "Gain",
		"type1": {
			"name": "fruit_get",
			"img": "res://assets/IconGodotNode/node_2D/fruit_get.png"
		},
		"type2": {
			"name": "exp_get",
			"img": "res://assets/IconGodotNode/node_2D/exp_get.png"
		}
	}
}

const attr_data = {
	"basic_dmg": {
		"group": attr_group.attack,
		"type": "type1",
		"range": "1-5"
	},
	"basic_dmg_multiple": {
		"group": attr_group.attack,
		"type": "type2",
		"range": "2-4"
	},
	"speed": {
		"group": attr_group.speed,
		"type": "type1",
		"range": "50-200"
	},
	"max_hp": {
		"group": attr_group.HP,
		"type": "type1",
		"range": "1-10"		
	},
	"fruit_get": {
		"group": attr_group.Get_add,
		"type": "type1",
		"range": "1-5"		
	},
	"exp_get": {
		"group": attr_group.Get_add,
		"type": "type2",
		"range": "1-5"		
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	item_template.hide()
	attr_template.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init():
	self.show()
	
	item_choose.show()
	refresh.show()
	update.show()
	continue_btn.show()
	
	if player.level_up_num > 0:
		gen_attr_choose()
		continue_btn.hide()
	else:
		item_choose.hide()
		refresh.hide()
		update.hide()
	
	gen_attr_choose()
	load_player_attr()
	pass
	
func gen_attr_choose():
	for item in item_choose.get_children():
		if item.is_visible():
			item_choose.remove_child(item)
			item.queue_free()
	for i in range(4):
		var attr_item = item_template.duplicate()
		attr_item.show()
		
		var keys = attr_data.keys()
		var num = randi_range(0, keys.size() - 1)
		
		attr_item.get_node("MarginContainer/HBoxContainer/TextureRect").texture = load(attr_data[keys[num]].group[attr_data[keys[num]].type].img)
		attr_item.get_node("MarginContainer/HBoxContainer/VBoxContainer/Label").text = attr_data[keys[num]].group.name
		
		var range = attr_data[keys[num]].range.split("-")
		var attr_val = randi_range(int(range[0]), int(range[1]))
		attr_item.get_node("RichTextLabel").text = "[color=green]+" + str(attr_val) + "[/color] " + attr_data[keys[num]].group[attr_data[keys[num]].type].name
		
		attr_item.get_node("Button").pressed.connect(choose_attr.bind({
			"key": keys[num],
			"attr": attr_data[keys[num]],
			"val": attr_val
		}))
		
		item_choose.add_child(attr_item)
	pass
	
func choose_attr(attr_info):
	player[attr_info.key] += attr_info.val
	
	player.level_up_num -= 1
	if player.level_up_num > 0:
		gen_attr_choose()
	else:
		item_choose.hide()
		refresh.hide()
		continue_btn.show()
	load_player_attr()
	pass
	
func load_player_attr():
	for item in attr_list.get_children():
		if item.is_visible():
			attr_list.remove_child(item)
			item.queue_free()
	var prop_list = player.get_script().get_base_script().get_script_property_list()
	for prop in prop_list:
		if prop.name.rfind(".gd") == -1:
			var attr_item = attr_template.duplicate()
			attr_item.show()
			
			attr_item.get_node("name").text = prop.name
			attr_item.get_node("value").text = str(player[prop.name])
			
			attr_list.add_child(attr_item)
	pass


func _on_refresh_pressed():
	if player.fruit >= 2:
		gen_attr_choose()
		player.fruit -= 2
	pass # Replace with function body.

func _on_continue_pressed():
	emit_signal("continue_game")
	pass # Replace with function body.
