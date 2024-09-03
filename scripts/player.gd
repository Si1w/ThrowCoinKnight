extends Player

@onready var playerAni  = $AnimatedSprite2D

var direction = Vector2.ZERO
var flip = false
var canMove = true
var stop = false
var level_up_num = 0

signal player_dead

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
			now_hp = 0
			emit_signal("player_dead")
	pass # Replace with function body.
	
## revert the player status to the start of the round
func respawn_player():
	now_exp = temp_now_exp   # clear the exp
	max_exp = temp_max_exp
	max_hp = temp_max_hp  # reset the hp
	now_hp = max_hp  
	fruit = temp_fruit
	level = temp_level
	basic_dmg = temp_basic_dmg
	basic_dmg_multiple = temp_basic_dmg_multiple
	fruit_get = temp_fruit_get
	speed = temp_speed
	exp_get = temp_exp_get


func mem_player_state():
	temp_speed = speed
	temp_now_hp = now_hp
	temp_max_hp = max_hp
	temp_now_exp = now_exp
	temp_max_exp = max_exp
	temp_exp_get = exp_get
	temp_level = level
	temp_fruit = fruit
	temp_fruit_get = fruit_get
	temp_basic_dmg = basic_dmg
	temp_basic_dmg_multiple = basic_dmg_multiple
	
	
