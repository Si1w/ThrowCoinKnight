extends CharacterBody2D

var canMove = false
var speed = 1500
var dir = 0
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	player = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove:
		dir = (player.global_position - self.global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	pass

'''
options.box 掉落物父级
options.ani_name 掉落物名称
options.position 掉落物生成坐标
options.scale 掉落物缩放等级
'''
func gen_drop_item(options):
	if !options.has("box"):
		options.box = GameManager.duplicated_node
	var ani_temp = self.duplicate()
	options.box.add_child(ani_temp)
	ani_temp.show()
	ani_temp.set_collision_layer_value.call_deferred(5, true)
	ani_temp.scale = options.scale if options.has("scale") else Vector2(1,1)
	ani_temp.position = options.position
	ani_temp.get_node("items").play(options.ani_name)
	pass 
	
