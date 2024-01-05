class_name PlayerDataResource
extends Resource


@export var player_data_name_or_description : String


@export var run_speed = 800.0


@export var in_air_horizontal_speed: float = 800.0
@export var max_air_actions : int = 2
@export var gravity : int = 100
@export var max_fall_speed : int = 120
@export var hang_time_duration : float = 0.05
@export var distance_before_medium_landing : float = 500.0
@export var distance_before_heavy_landing : float = 1000.0


@export var jump_force : int = -1000
@export var jump_max_hold_time : float = 0.25
@export var jump_hold_multiplier : float = 2.7


@export var wall_jump_horizontal_force_multiplier : float = 1.5
@export var wall_jump_force_duration : float = 0.1
@export var wall_jump_hold_multiplier : float = 2.7


@export var dash_peak_speed : float = 500.0
@export var dash_time : float = 0.20
@export var dash_recovery_time : float = 0.1
@export var dash_hold_multiplier : float = 2.0
@export var ground_dash_cooldown : float = 2.0
@export var only_horizontal_dashing_allowed : bool = true


@export var wall_grab_resets_air_actions : bool = true
@export var wall_grab_allowed_while_ascending : bool = false
