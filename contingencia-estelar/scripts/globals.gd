extends Node

var current_level: int = 1
const time_limit: float = 30.0
const points_factor = 125

var levels := {
	1: {
		"label": "Capítulo 1: ¿?",
		"position": Vector2(2770.0, 54.0),
		"completion_time": 0.0,
		"points": 0
	},
	2: {
		"label": "Capítulo 2:",
		"position": Vector2(820.0, 95.0),
		"completion_time": 0.0,
		"points": 0
	},
	3: {
		"label": "Capítulo 3:",
		"position": Vector2(1903.0, -2.0),
		"completion_time": 0.0,
		"points": 0
	},
}
