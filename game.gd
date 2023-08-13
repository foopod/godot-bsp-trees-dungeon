extends Node2D

var root_node: Branch
var tile_size: int =  16
var world_size = Vector2i(60,30)

var tilemap: TileMap
var paths: Array = []

func _draw():
	var rng = RandomNumberGenerator.new()
	for leaf in root_node.get_leaves():
		var padding = Vector4i(rng.randi_range(2,3),rng.randi_range(2,3),rng.randi_range(2,3),rng.randi_range(2,3))
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				if not is_inside_padding(x,y, leaf, padding) :
					tilemap.set_cell(0, Vector2i(x + leaf.position.x,y + leaf.position.y), 2, Vector2i(2, 2))
	for path in paths:
		if path['left'].y == path['right'].y:
			for i in range(path['right'].x - path['left'].x):
				tilemap.set_cell(0, Vector2i(path['left'].x+i,path['left'].y), 2, Vector2i(2, 2))
		else:
			for i in range(path['right'].y - path['left'].y):
				tilemap.set_cell(0, Vector2i(path['left'].x,path['left'].y+i), 2, Vector2i(2, 2))
func _ready():
	tilemap = get_node("TileMap")
	root_node  = Branch.new(Vector2i(0,0), world_size)
	root_node.split(2, paths)
	queue_redraw()
	pass 


func is_inside_padding(x, y, leaf, padding):
	return x <= padding.x or y <= padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
