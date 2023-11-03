using Godot;
using System;

public partial class Ghost : Area2D
{
	//This extra code isn't needed for now, because there's only one animation.
	//It will come in handy if we add a second animation and want to switch from this script.
	//private AnimatedSprite2D Anim;
		
	public override void _Ready()
	{
		BodyEntered += PlayerCollision;
		//Anim = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		//Anim.Play();
	}

	void PlayerCollision(Node2D player)
	{
		// GD.Print("test from Ghost");
		QueueFree();
	}
}
