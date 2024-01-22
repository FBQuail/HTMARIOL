extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
var State = {
	direction = 1,
}
var Counters = {
	wall_time = 0,
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = 0.78125*9*60*State.direction;
	if !is_on_floor(): velocity.y = 1.5625*9*60;
	move_and_slide();
	if is_on_wall():
		if Counters.wall_time == 0:
			State.direction *= -1;
			global_position.x -= 16*sign(velocity.x);
		Counters.wall_time += 1;
	else:
		Counters.wall_time = 0;



func _on_area_body_entered(body):
	if body.State.power < 1: body.State.power += 1;
	#Makes the player play the powerup sound.
	body.Sounds.powerup = true;
	queue_free();
	pass # Replace with function body.
