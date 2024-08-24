extends TileMap

@onready var tilemap = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	random_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func random_map():
	tilemap.clear_layer(1)
	var backgroundCells = tilemap.get_used_cells(0)
	var ran = RandomNumberGenerator.new()
	var type = RandomNumberGenerator.new()
	for cell_pos in backgroundCells:
		var num = ran.randi_range(0, 100)
		var dec = type.randi_range(0, 2)
		if num <= 5:
			tilemap.set_cell(1, cell_pos, 0, Vector2i(dec, 5))
	pass


func _on_button_pressed():
	random_map()
	pass # Replace with function body.
