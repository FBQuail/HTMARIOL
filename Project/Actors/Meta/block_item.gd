extends Node2D
##This node is overlayed over ? blocks to give them a specific item, upon collision with the player a variable will be set that will tell the player to spawn an item at the next block instead of getting a coin.

@export var item: int = 0;

var cell = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	#Turns the editor sprite's visibility off so it isn't shown in game.
	%EditorSprite.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_body_entered(body):
	#If the closest tile the player is in is occupied by this tile, set the block that the player will get from the next block they hit to the item set in this node.
	#0 for coin, 1 for scaling powerup, 2 for mushroom, 3 for fireflower, 4 for star, 5 for 1up, 6 for timer coin blocks.
	body.Tile_Collision.block_item = self;
	body.State.block_item = item;
	body.State.block = self;
	print(cell);	
	

func _on_area_body_exited(body):
	body.State.block_item = 0;
