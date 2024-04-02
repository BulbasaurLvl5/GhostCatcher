class_name PlayerDataResource
extends Resource

@export_group("On the Ground")
@export var run_speed : float = 800.0
@export var coyote_time_ground : float = 0.1

@export_group("Grabbing Walls")
@export var wall_grab_resets_air_actions : bool = true
@export var coyote_time_wall : float = 0.25
@export var wall_jump_horizontal_force_multiplier : float = 1.5
@export var wall_jump_force_duration : float = 0.1
@export var wall_jump_hold_multiplier : float = 2.7

@export_group("In the Air")
@export var max_air_actions : int = 2
@export var in_air_horizontal_speed: float = 600.0
@export var gravity : int = 3000
@export var max_fall_speed : int = 2000
@export var hang_time_duration : float = 0.05
@export var distance_before_medium_landing : float = 500.0
@export var distance_before_heavy_landing : float = 1000.0

@export_group("Jumping")
@export var jump_force : int = -900
@export var jump_max_hold_time : float = 0.25
@export var jump_hold_multiplier : float = 2.7

@export_group("Dashing")
@export var dash_peak_speed : float = 280.0
@export var dash_time : float = 0.20
@export var dash_recovery_time : float = 0.1
@export var dash_hold_multiplier : float = 2.0
@export var ground_dash_cooldown : float = 2.0
