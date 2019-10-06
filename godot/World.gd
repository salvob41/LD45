extends Node2D

export var grid_size: Vector2 = Vector2(8, 8)
export var PIECE_DEF_JSON : String

var tile_size = 64
var grid = []
var list_pieces: Array = []
var piece_defs : Dictionary = {}

func _ready():
	randomize()
	# list characters
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	# load the piece definition
	piece_defs = load_JSON(PIECE_DEF_JSON)
	for k in piece_defs.keys():
		if k != "king":
			list_pieces.append(k)
			
	print(list_pieces)
	
	get_legal_moves("king", get_grid_pos($Player))

func _process(delta: float) -> void:
	get_grid_pos($Player)

func load_JSON(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	var dict : Dictionary = {}
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	dict = parse_json(text)
	file.close()
	return dict
	
func get_legal_moves(piece, current_grid_pos):
	#return the cells where the piece can move
	var piece_moves = []
	var valid_moves = []
	piece_moves = get_moves(piece)

	for move in piece_moves:
		if move.get("repeat"):
			while current_grid_pos < target_grid_pos:
				if is_cell_vacant(move["step"], current_grid_pos):
					pass
		else:
			print("no repeat")
		if is_cell_vacant(move["step"], current_grid_pos):
			valid_moves.append(move["step"])
	return valid_moves #placeholder

func is_cell_vacant(move, current_grid_pos) -> bool:
	#check if the cell where the piece wants to move is empty or not
	var next_grid_pos = []
	next_grid_pos.append(current_grid_pos[0] + move[0])
	next_grid_pos.append(current_grid_pos[1] + move[1])
	if grid[next_grid_pos[0]][next_grid_pos[1]] != null:
		return false
	return true

func get_moves(piece):
	#return an array of dictionaries containing the moves of the parameter piece
	return piece_defs[piece]["moves"]

func get_grid_pos(piece):
	#return the position's array of the piece
	return [ceil(piece.position.x / tile_size), ceil(piece.position.y / tile_size)]







