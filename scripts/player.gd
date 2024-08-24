extends Player

@onready var playerAni  = $AnimatedSprite2D

var direction = Vector2.ZERO
var flip = false
var canMove = true
var stop = false
var level_up_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init_attr():
	speed = 600
	now_hp = 10
	max_hp = 10
	now_exp = 0
	max_exp = 5
	level = 1
	fruit = 0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var self_pos = position
	
	if mouse_pos.x >= self_pos.x:
		flip = false
	else:
		flip = true 
		
	playerAni.flip_h = flip
	
	if canMove and !stop:
		direction = (mouse_pos - self_pos).normalized()
		velocity = direction * speed
		move_and_slide()
	pass
	
# 鼠标左键长按停止移动，松开开始移动
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed:
		canMove = !canMove
	pass

func _on_stop_mouse_entered():
	stop = true
	pass # Replace with function body.
	
func _on_stop_mouse_exited():
	stop = false
	pass # Replace with function body.
	
func _on_drop_item_area_body_entered(body):
	if body.is_in_group("drop_item"):
		self.fruit += (1 + self.fruit_get)
		self.now_exp += (1 + self.exp_get)
		if self.now_exp >= self.max_exp:
			self.level += 1
			self.now_exp = 0
			self.level_up_num += 1
			self.max_exp += (self.level - 1)
		body.canMove = true
	pass # Replace with function body.

func _on_stop_body_entered(body):
	if body.is_in_group("drop_item"):
		body.queue_free()
	if body.is_in_group("enemy"):
		self.now_hp -= 1
		if now_hp <= 0:
			get_tree().reload_current_scene()
	pass # Replace with function body.
