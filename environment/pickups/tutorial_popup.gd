@tool
class_name TutorialPopUp
extends Node2D


@export var description : String  #The message that appears at the top of the pop-up
@export var actions : Array[String]  #The action/s for which controls are shown
@export var popup_fades : bool = true  #Determines if the message fades when the player leaves the area
@export var fade_delay : float = 10.0  #Delays the fade (if any) on the popup
@export var max_appearances : int = 99999  #Maximum number of times the popup will appear during a level run

@export var scale_area2d : Vector2 = Vector2.ONE:  #Adjusts the size of the Area2D that triggers the popup
	set(value):
		scale_area2d.x = max(scale_area2d.x, 0)
		scale_area2d.y = max(scale_area2d.y, 0)
		if scale_area2d == value:
			return
		scale_area2d = value
		update_area2d()
		
@export var popup_offset : Vector2 = Vector2(0, -4.2):  #Adjusts the popup position, measured in tiles
	set(value):
		if popup_offset == value:
			return
		popup_offset = value
		update_popup()

var appearances : int = 0
var player_detected : bool = false:
	set(value):
		if player_detected == value:
			return
		player_detected = value
		if player_detected && can_activate_popup():
			popup.visible = true
			appearances += 1
			if timer && popup_fades:
				timer.start(fade_delay)

@onready var area2d : Area2D = %Area2D 
@onready var popup : Control = %PopUp
@onready var timer : Timer = %Timer


func _ready():
	update_area2d()

func update_area2d():
	if area2d:
		area2d.scale = scale_area2d
	else:
		print(self.name, " cannot find its area2d")
		
func update_popup():
	if !popup:
		print(self.name, " cannot find its popup control node")
		return
	popup.position.x = (popup.size.x * -0.5) + (popup_offset.x * 110.0)
	popup.position.y = (popup.size.y * -0.5) + (popup_offset.y * 110.0)


func can_activate_popup() -> bool:
	if appearances >= max_appearances:
		return false 
	if popup.visible:
		return false
	return true
	
	
func _on_area_2d_body_entered(body):
	if body is Player:
		player_detected = true
		

		




func _on_area_2d_body_exited(body):
	if body is Player:
		player_detected = false


func _on_timer_timeout():
	popup.visible = false
