extends Camera2D

var dir = Vector2(0, 0);
var old_parent = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent().global_position
	offset.y = -parent.y + 1064;
#	if sign(dir.x) == -1:
	#	offset.x = -get_parent().position.x;
	dir = parent - old_parent;
	old_parent = parent;
