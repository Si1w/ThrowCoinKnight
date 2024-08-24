extends CharacterBody2D

var dir = Vector2.ZERO
var speed = 2000
var dmg = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = dir * speed
	
	move_and_slide() 
	pass


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	if body.is_in_group("enemy"):
		body.enemy_hurt(dmg)
		self.queue_free()
	
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(2, coords)
		var isWall = tile_data.get_custom_data("isWall")
		if isWall:
			self.queue_free()
	pass # Replace with function body.
