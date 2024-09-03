extends Node2D

var animation_scene = preload("res://scenes/animations.tscn")
var animation_scene_obj = null

var drop_item_scene = preload("res://scenes/drop_items.tscn")
var drop_item_scene_obj = null

var duplicated_node = null



# Called when the node enters the scene tree for the first time.
func _ready():
	init_duplicated_node()
	animation_scene_obj = animation_scene.instantiate()
	drop_item_scene_obj = drop_item_scene.instantiate()
	

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init_duplicated_node():
	if duplicated_node != null:
		duplicated_node.queue_free()
	var node2d = Node2D.new()
	node2d.name = "duplicated_node"
	get_window().add_child.call_deferred(node2d)
	duplicated_node = node2d 

func _on_game_ui_round_end():
	get_tree().paused = true
	$level_up.init()
	pass # Replace with function body.

func _on_level_up_continue_game():
	get_tree().paused = false
	$level_up.hide()
	$Player.now_hp = $Player.max_hp
	$GameUI.init_round()
	var drop_items = get_tree().get_nodes_in_group("drop_item")
	for drop_item in drop_items:
		if drop_item.get_collision_layer_value(5):
			self.remove_child(drop_item)
			drop_item.queue_free()
	$now_enemies.delete_enemies()
	pass # Replace with function body.


## When the player is dead
func _on_player_dead():
	get_tree().paused = true
	$GameUI.timer_stop()
	$Dead.init()
	

## restart the game
func _on_dead_restart_game():
	get_tree().paused = false
	$Dead.hide()
	$now_enemies.delete_enemies()
	$Player.respawn_player()
	$GameUI.restart_round()
	var drop_items = get_tree().get_nodes_in_group("drop_item")
	for drop_item in drop_items:
		if drop_item.get_collision_layer_value(5):
			self.remove_child(drop_item)
			drop_item.queue_free()
	
	

