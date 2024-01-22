class_name GiantGhostAI
extends FlyingMobAI


func Flip_Mob():
	facing_direction *= -1
	%AnimatedSprite2D.scale.x *= -1
