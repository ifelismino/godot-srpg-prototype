class_name NumberUtility
extends Node
# A class for functions involving numbers

const FLOAT_EPSILON_LAX = 1.0

static func compare_floats_lax(a: float, b: float, epsilon = FLOAT_EPSILON_LAX) -> bool:
	return abs(a - b) <= epsilon

static func coangle_of_360(a: int) -> bool:
	return int(abs(a + 360)) % 360 == 0

static func coangle_of_270(a: int) -> bool:
	return int(abs(a + 90)) % 360 == 0

static func coangle_of_180(a: int) -> bool:
	return int(abs(a + 180)) % 360 == 0

static func coangle_of_90(a: int) -> bool:
	return int(abs(a + 270)) % 360 == 0
