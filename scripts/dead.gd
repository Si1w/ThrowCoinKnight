extends CanvasLayer

@onready var dead_label = $dead_label
@onready var restart_btn = $restart_btn

signal respawn
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init():
	self.show()
	dead_label.show()
	restart_btn.show()

func _on_restart_pressed():
	emit_signal("respawn")

