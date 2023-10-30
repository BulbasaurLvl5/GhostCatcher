class_name PlayerDataResource
extends Resource

@export var walk_speed : float = 150.0
@export var run_speed = 420.0

@export var in_air_horizontal_speed: float = 350
@export var max_air_actions : int = 2
@export var hang_time_duration : float = 0.10
@export var fall_gravity_multiplier : float = 5
@export var distance_before_medium_landing : float = 500
@export var distance_before_heavy_landing : float = 1000
@export var distance_before_dying : float = 2000

@export var jump_height: float = 150
@export var jump_time_to_peak: float = 0.2
@export var jump_hold_multiplier: float = 2.7

@export var wall_jump_height: float = 150
@export var wall_jump_time_to_peak: float = 0.2
@export var wall_jump_force_duration: float = 0.1
@export var wall_jump_hold_multiplier: float = 2.7

@export var dash_distance : float = 125
@export var dash_time : float = 0.2
@export var dash_hold_multiplier = 2.7

@export var wall_grab_resets_air_actions : bool = true

