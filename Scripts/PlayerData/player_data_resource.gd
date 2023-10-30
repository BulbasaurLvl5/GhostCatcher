class_name PlayerDataResource
extends Resource

@export var player_data_name_or_description : String

@export var walk_speed : float = 150.0
@export var run_speed = 420.0

@export var in_air_horizontal_speed: float = 350.0
@export var max_air_actions : int = 2
@export var hang_time_duration : float = 0.05
@export var fall_gravity_multiplier : float = 20.0
@export var distance_before_medium_landing : float = 500.0
@export var distance_before_heavy_landing : float = 1000.0
@export var distance_before_dying : float = 2000.0

@export var jump_height: float = 150.0
@export var jump_time_to_peak: float = 0.2
@export var jump_hold_multiplier: float = 2.7

@export var wall_jump_height: float = 150.0
@export var wall_jump_time_to_peak: float = 0.2
@export var wall_jump_force_duration: float = 0.2
@export var wall_jump_hold_multiplier: float = 2.7

@export var dash_peak_speed : float = 280.0
@export var dash_time : float = 0.25
@export var dash_hold_multiplier = 2.7

@export var wall_grab_resets_air_actions : bool = true

