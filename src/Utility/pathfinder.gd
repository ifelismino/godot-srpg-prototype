const TURN_PENALTY = 1.25

static func calculate_move_possible(_actor: Actor, _level: IsometricLevel, _manager: BattleManager) -> Array:
	var _border = _actor.moveLimit + 1
	var _out = []
	var origin = Vector2(_border, _border)
	# Create the heightmap matrix with impassable tiles as 1000 height
	for i in range(-_border, _border + 1):
		_out.append([])
		for j in range(-_border, _border + 1):
			var u = _border + i
			var _distance = abs(i) + abs(j)

			# If the tile is on the border make impassable (above move limit)
			if abs(i) == _border or abs(j) == _border:
				_out[u].append(1000)

			# If the tile is out of bounds of the map make impassable
			elif _actor.coordinate.x + i < 0 or _actor.coordinate.x + i > _level.width - 1:
				_out[u].append(1000)
			elif _actor.coordinate.y + j < 0 or _actor.coordinate.y + j > _level.length - 1:
				_out[u].append(1000)

			# If the tile is where the character is, make passable
			elif i == 0 and j == 0:
				var height = _level.get_height(Vector2(_actor.coordinate.x + i, _actor.coordinate.y + j))
				_out[u].append(height)

			# If the tile is occupied, make impassable
			elif _manager.is_occupied(Vector2(_actor.coordinate.x + i, _actor.coordinate.y + j)):
				_out[u].append(1000)

			# If the tile is too far for the move limit, make impassable
			elif _actor.moveLimit < _distance:
				_out[u].append(1000)

			# Else output the height of the tile
			else:
				var height = _level.get_height(Vector2(_actor.coordinate.x + i, _actor.coordinate.y + j))
				_out[u].append(height)

	# Make areas not reachable by jump stat, or blocked by other characters impassable
	# Possible: add a teleportation flag to disable
	for k in range(2):
		for i in range(-_border, _border + 1):
			for j in range(-_border, _border + 1):
				if abs(i) == _border or abs(j) == _border:
					continue
				var u = _border + i
				var v = _border + j
				if _out[u][v] > 900:
					continue
				if origin == Vector2(u,v):
					continue
				var N = (_actor.jump < abs(_out[u][v-1] - _out[u][v]))
				var S = (_actor.jump < abs(_out[u][v+1] - _out[u][v]))
				var E = (_actor.jump < abs(_out[u+1][v] - _out[u][v]))
				var W = (_actor.jump < abs(_out[u-1][v] - _out[u][v]))
				if N and S and E and W:
					_out[u][v] = 1000
				var path = find_shortest_path(_out, Vector2(u, v), _actor)
				if path.size() == 1:
					_out[u][v] = 1000
				var total_distance = 0
				for _tiles in path:
					total_distance += _get_distance(_tiles.location, origin, _out)
				if total_distance > 900:
					_out[u][v] = 1000
	return _out

static func find_shortest_path(mapArray: Array, target: Vector2, _actor: Actor):
#	mapArray[0][0] = 0
	var flg_exists = false
	var target_reached = false
	var _border = _actor.moveLimit + 1
	var x = _border
	var y = _border
	var queue: Array = []
	var finished: Array = []
	var origin = mapTile.new()
	origin.location = Vector2(x, y)
	origin.distance = _get_distance(origin.location, target, mapArray)
	finished.append(origin)
	if origin.location == target:
		return finished
	while target_reached == false:
		for i in range(-1, 2):
			for j in range(-1, 2):
				var u = x + i
				var v = y + j
				if u > _border * 2 or u < 0:
					continue
				if v > _border * 2 or v < 0:
					continue
				if abs(i) > 0 and abs(j) > 0:
					continue
				if i == 0 and j == 0:
					continue
				var _Tile = mapTile.new()
				_Tile.location = Vector2(u, v)
				flg_exists = false
				for q in queue:
					if q.location == _Tile.location:
						flg_exists = true
				for f in finished:
					if f.location == _Tile.location:
						flg_exists = true
				if flg_exists == false:
					if (abs(mapArray[x][y] - mapArray[u][v]) > _actor.jump):
						_Tile.distance = 999999
					else:
						_Tile.distance = _get_distance(target, _Tile.location, mapArray)
						_Tile.distance += 0.5 * _get_distance(_Tile.location, origin.location, mapArray)
						# Penalize too much turning
						var _past = finished[finished.size() - 2].location
						if abs(_Tile.location.x - _past.x) > 0 and abs(_Tile.location.y - _past.y) > 0:
							_Tile.distance *= TURN_PENALTY
					queue.append(_Tile)
		queue.sort_custom(mapTile, "distance_comparison")
		x = queue[0].location.x
		y = queue[0].location.y
		finished.append(queue[0])
		if queue[0].distance > 900:
			return finished
		queue.remove(0)
		if target.x == x and target.y == y:
			target_reached = true
	return finished


static func realToArrayCoordinates(_vector: Vector2, _actor: Actor) -> Vector2:
	var _border = _actor.moveLimit + 1
	var u = _vector.x - _actor.coordinate.x + _border
	var v = _vector.y - _actor.coordinate.y + _border
	return Vector2(u, v)
	

static func _get_distance(a: Vector2, b: Vector2, mapArray: Array):
	var dist = sqrt(pow((a.x - b.x), 2) + pow((a.y - b.y), 2) + pow((mapArray[a.x][a.y] - mapArray[b.x][b.y]), 2))
	return dist

static func optimizePath(_path: Array) -> Array:
	_path.invert()
	var optim : Array = []
	for i in range(_path.size()):
		var nowTile : mapTile = _path[i]
		if i == 0:
			optim.append(nowTile)
		else:
			var lastTile : mapTile = optim.back()
			if abs(lastTile.location.distance_to(nowTile.location)) <= 1:
				optim.append(nowTile)
	optim.invert()
	return optim

class mapTile:
	var location: Vector2
	var distance: float
	static func distance_comparison(a, b):
		if a.distance < b.distance:
			return true
		return false
