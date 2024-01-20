extends Node2D
##This node is overlayed over ? blocks to give them a specific item, upon collision with the player a variable will be set that will tell the player to spawn an item at the next block instead of getting a coin.

@export var item: int = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	#Turns the editor sprite's visibility off so it isn't shown in game.
	%EditorSprite.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_body_entered(body):
	body.State.block_item = item;
	print(body.State.block_item)

func _on_area_body_exited(body):
	body.State.block_item = 0;
