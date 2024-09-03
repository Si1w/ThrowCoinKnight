extends CanvasLayer

@onready var hp_value_bar = %HP_value_bar
@onready var exp_value_bar = %EXP_value_bar
@onready var fruit = %fruit
@onready var now_round = $count_down/now_round
@onready var time_show = $count_down/time_show
@onready var timer = $count_down/Timer

var player
var now_round_num = 0:
	set(val):
		now_round_num = val
		now_round.text = 'Round ' + str(val)
var round_time = 0:
	set(val):
		round_time = val
		time_show.text = str(val)
		
signal round_end

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	init_round()
	pass # Replace with function body.

func init_round():
	now_round_num += 1
	round_time = 30
	timer.start()
	pass

# Restart the current round
func restart_round():
	round_time = 30
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hp_value_bar.max_value = player.max_hp
	hp_value_bar.value = player.now_hp
	hp_value_bar.get_node("Label").text = str(player.now_hp) + '/' + str(player.max_hp)
	exp_value_bar.max_value = player.max_exp
	exp_value_bar.value = player.now_exp
	exp_value_bar.get_node("Label").text = 'LV.' + str(player.level)
	fruit.text = str(player.fruit)
	pass


func _on_timer_timeout():
	round_time -= 1
	if round_time <= 0:
		timer.stop()
		emit_signal("round_end")
	pass # Replace with function body.
	
func timer_stop():
	timer.stop()
	
func timer_start():
	timer.start()
