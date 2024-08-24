extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var dir = 0
var speed = 300
var target = null
var hp = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_first_node_in_group("Player")
	hp += (target.level -1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		dir = (target.global_position - self.global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	pass
	
func enemy_hurt(hurt):
	self.hp -= ((hurt + target.basic_dmg) * target.basic_dmg_multiple)
	animated_sprite.play("hurt")
	#GameManager.animation_scene_obj.run_animation({
	#	"box": GameManager.duplicated_node,
	#	"ani_name": "enemy_hurt",
	#	"position": self.global_position ,
	#	"scale": Vector2(1,1)
	#})
	await get_tree().create_timer(0.2).timeout
	if self.hp <= 0:
		animated_sprite.play("dead")
		await get_tree().create_timer(0.2).timeout
		enemy_dead()
	else:
		animated_sprite.play("default")
	pass

func enemy_dead():
#	GameManager.animation_scene_obj.run_animation({
#	"box": GameManager.duplicated_node,
#	"ani_name": "enemy_dead",
#	"position": self.global_position ,
#	"scale": Vector2(1,1)
#	})
	GameManager.drop_item_scene_obj.gen_drop_item({
	"box": GameManager.duplicated_node,
	"ani_name": "fruit",
	"position": self.global_position ,
	"scale": Vector2(1.5,1.5)
	})
	self.queue_free()
	pass
	
