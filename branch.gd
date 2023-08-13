extends Node

class_name Branch

var left_child:  Branch
var right_child:  Branch
var position: Vector2i
var size: Vector2i

func _init(starting_position, starting_size):
	self.position = starting_position
	self.size = starting_size

func split(remaining, paths: Array):
	var rng = RandomNumberGenerator.new()
	var split_percent = rng.randf_range(0.3,0.7)
	var split_horizontal = size.y >= size.x
	
	# split current leaf
	if(split_horizontal):
		var left_height = int(size.y * split_percent)
		left_child = Branch.new(position, Vector2i(size.x, left_height))
		right_child = Branch.new(
			Vector2i(position.x,position.y + left_height), 
			Vector2i(size.x,size.y - left_height)
		)
	else:
		var left_width = int(size.x * split_percent)
		left_child = Branch.new(position, Vector2i(left_width,size.y))
		right_child = Branch.new(
			Vector2i(position.x + left_width,position.y), 
			Vector2i(size.x - left_width,size.y)
		)
	
	paths.push_back({'left': left_child.get_center(), 'right': right_child.get_center()})
	
	if(remaining > 0):
		left_child.split(remaining - 1, paths)
		right_child.split(remaining - 1, paths)
		
	pass
	
func get_leaves():
	if not (left_child && right_child):
		return [self]
	else:
		return left_child.get_leaves() + right_child.get_leaves()
		
func get_center():
	return Vector2i(position.x + size.x / 2, position.y + size.y / 2)
