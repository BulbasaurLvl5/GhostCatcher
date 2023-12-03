class_name PlayerWallGrabState
extends PlayerState


@onready var wall_direction : int
@onready var wall : Node
#@onready var wall_is_moving : bool = false

func Enter():
	$"../../PlayerAnimatedSprite2D".offset.x += 40
	anim.play("wall_grab")
	$"../../PlayerAnimatedSprite2D/StickyGroundCheckFront".force_raycast_update()	
	$"../../PlayerAnimatedSprite2D/StickyGroundCheckBack".force_raycast_update() 
	if $"../../PlayerAnimatedSprite2D/StickyWallCheck1".is_colliding():
		player.link_to_moving_platform($"../../PlayerAnimatedSprite2D/StickyWallCheck1".get_collider())
	elif $"../../PlayerAnimatedSprite2D/StickyWallCheck2".is_colliding():
		player.link_to_moving_platform($"../../PlayerAnimatedSprite2D/StickyWallCheck2".get_collider())
	elif player.is_on_moving_platform:
		player.unlink_from_moving_platform()
		
	wall_direction = player.facing_direction
	player.velocity = Vector2.ZERO
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if Input.is_action_pressed("Jump") && player.jump_button_reset:
		$"../../PlayerAnimatedSprite2D".offset.x -= 40
		Transitioned.emit(self,"WallJump")
	elif player.x_input != wall_direction || !player.is_facing_wall:
		if player.x_input == player.facing_direction * -1:
			player.facing_direction *= -1
			$"../../PlayerAnimatedSprite2D".scale.x *= -1
		$"../../CoyoteTime".start()
		player.last_touched_wall = true
		$"../../PlayerAnimatedSprite2D".offset.x -= 40
		Transitioned.emit(self,"InAir")	
		
		
func Physics_Update(_delta):
	player.move_and_collide(player.movement_adjustment)
	player.movement_adjustment = Vector2.ZERO		


func Flip_Player():
	#cannot flip while grabbing wall
	pass
