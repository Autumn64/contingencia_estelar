extends Node

var current_level: int = 1
const time_limit: float = 120.0
const points_factor = 125

var levels := {
	1: {
		"label": "Capítulo 1: ¿No regresarán  . . .   por mí?",
		"position": Vector2(15.0, 77.0),
		"completion_time": 0.0,
		"points": 0
	},
	2: {
		"label": "Capítulo 2: Debo regresar a casa .",
		"position": Vector2(3399.0, 79.0),
		"completion_time": 0.0,
		"points": 0
	},
	3: {
		"label": "Capítulo 3: No parece haber fin  . . .",
		"position": Vector2(6884.0, 15.0),
		"completion_time": 0.0,
		"points": 0
	},
}
