extends CharacterBody2D

#Everything is multiplied by 9 for the sprite upscaling, then another 60 so that it is per frame instead of per second.
const WALK_SPEED = 1.5625*9*60;
const WALK_ACCEL = 0.037109375*9*60;

const RUN_SPEED = 2.5625*9*60;
const RUN_ACCEL = 0.0556640625*9*60;

const LEVEL_ENTRY = 0.8125*9*60;
#For some reason in the original if you jump with a certain amount of speed or higher, you will turn around faster...?
const JUMP_TURN = 1.8125*9*60;
const SKID_ACCEL = 0.1015625*9*60;
const STOP_ACCEL = 0.05078125*9*60;
const MIN_VELOC = 0.07421875*9;
const JUMP_VELOCITY = -1200.0


var State = {
	IsJumping = false,
	IsSkidding = false,
	IsRunning = false,
	direction = 1,
	#The speed you were traveling at when you jump, updated every frame when you're on the ground, otherwise is kept the same.
	jump_speed = 0,
}

var Counters = {
	run_stop = 0,
}
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		State.IsJumping = false;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		State.IsJumping = true;

	#Get an axis dirived from the input map.
	var xinput = Input.get_axis("left", "right")
	
	#Creates a variable that tracks if the player is holding the run button.
	var rinput = Input.is_action_pressed("run");
	#Check if the player is pressing any horizontal input.
	if xinput && is_on_floor():
		#Check if you're not turning.
		if xinput == sign(velocity.x) || velocity.x == 0:
			if !rinput && Counters.run_stop == 0:
				#Check if the player is under max walking speed, and if so accelerate by the walking acceleration each frame in the direction they're holding.
				if abs(velocity.x) < WALK_SPEED: velocity.x += WALK_ACCEL*xinput;
				#If they're above or at max speed, set their speed to max speed to make sure they don't go over.
				else: velocity.x = WALK_SPEED*xinput;
			if rinput:
				#Check if the player is under max walking speed, and if so accelerate by the walking acceleration each frame in the direction they're holding.
				if abs(velocity.x) < RUN_SPEED: velocity.x += RUN_ACCEL*xinput;
				#If they're above or at max speed, set their speed to max speed to make sure they don't go over.
				else: velocity.x = RUN_SPEED*xinput;
				#Makes it so that 10 frames have to pass after not running for mario to walk, so that you can fireball without stopping running.
				Counters.run_stop = 10;
			State.IsSkidding = false;
		#If the player is turning.
		else:
			#Check if their not stopped, and if so decelerate them every frame in the way they're holding.
			if abs(velocity.x) > SKID_ACCEL: velocity.x += SKID_ACCEL*-sign(velocity.x);
			else: velocity.x = 0;
			State.IsSkidding = true;
		#Tracks what speed you're running at for when you jump.
		State.jump_speed = velocity.x;
	#If you are moving in the air.
	elif xinput && !is_on_floor():
		#If you are holding forward
		if xinput == sign(velocity.x) || velocity.x == 0:
			#If you are under walking speed?
			if abs(velocity.x) < WALK_SPEED:
				#Use your walk acceleration
				velocity.x += WALK_ACCEL;
			else:
				#Otherwise use your running acceleration.
				velocity.x += RUN_ACCEL;
			if State.jump_speed <= WALK_SPEED:
				if velocity.x > WALK_SPEED: velocity.x = WALK_SPEED;
			else:
				if velocity.x > RUN_SPEED: velocity.x = RUN_SPEED;
		#If you are holding backwards.
		else:
			if velocity.x >= WALK_SPEED:
				velocity.x += RUN_ACCEL*xinput;
			elif State.jump_speed >= JUMP_TURN:
				velocity.x += LEVEL_ENTRY*xinput;
			else:
				velocity.x += WALK_ACCEL*xinput;
	elif is_on_floor():
		#Checks if you're still moving.
		if velocity.x != 0:
			#Checks if you're not skidding.
			if State.IsSkidding == false:
				#Decrease your speed by your stopping deceleration every frame.
				if abs(velocity.x) > STOP_ACCEL: velocity.x += STOP_ACCEL*-sign(velocity.x);
				else: velocity.x = 0;
			#If you are still skidding, keep skidding normally.
			else:		
				if abs(velocity.x) > SKID_ACCEL: velocity.x += SKID_ACCEL*-sign(velocity.x);
				else: velocity.x = 0;
		
	if (Input.is_action_just_pressed("left") && State.direction == 1 || Input.is_action_just_pressed("right") && State.direction == -1):
		scale.x = -9;
		State.direction *= -1;
	
	if Counters.run_stop > 0 && !rinput:
		Counters.run_stop -= 1;
	print(Counters.run_stop);
	if is_on_floor():
		if velocity.x != 0:
			if State.IsSkidding == false: %SpriteSmall.play("run", velocity.x/900);
			else: %SpriteSmall.play("turn");
		else:
			%SpriteSmall.play("idle");
	else:
		if State.IsJumping == true:
			%SpriteSmall.play("jump");
		else:
			%SpriteSmall.play("run", 0);
	
	move_and_slide()
