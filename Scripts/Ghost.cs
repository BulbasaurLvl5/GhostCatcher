using Godot;
using System;

public partial class Ghost : Area2D
{
	public override void _Ready()
	{
		BodyEntered += PlayerCollision;
	}

	void PlayerCollision(Node2D player)
	{
		// GD.Print("test from Ghost");
		QueueFree();
	}
}
