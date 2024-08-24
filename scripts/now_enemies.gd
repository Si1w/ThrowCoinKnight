extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn" )
@onready var timer = $Timer

var tileMap = null 
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	tileMap = get_tree().get_first_node_in_group("map")
	player = get_tree().get_first_node_in_group("Player")
	timer.wait_time -= (player.level) * 0.1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var ran = RandomNumberGenerator.new()
	var num = ran.randi_range(0, len(tileMap.get_used_cells(0)) - 1)
	var local_position = tileMap.map_to_local(tileMap.get_used_cells(0)[num])
	var enemyTemp = enemy.instantiate()
	enemyTemp.position = local_position * Vector2(6, 6)
	self.add_child(enemyTemp)
	pass # Replace with function body.
	
func delete_enemies():
	for n in self.get_children():
		if n.name != 'Timer':
			self.remove_child(n)
			n.queue_free()
	pass
