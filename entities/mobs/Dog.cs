using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class Dog : Area2D
{
	Node2D speech;
	AudioStreamPlayer2D bark;
	AudioStreamPlayer2D whining;

	public override void _Ready()
	{
		if(this.TryGetChildren(out List<Node2D> children))
		{
			// GD.Print(children[3].Name);
			speech = children[3];
			bark = children[4] as AudioStreamPlayer2D;
			whining = children[5] as AudioStreamPlayer2D;
		}

		BodyEntered += (Node2D n) => {if (n is CharacterBody2D) {PlayerCollision(false);};};
		BodyExited += (Node2D n) => {if (n is CharacterBody2D) {PlayerCollision(true);};};
	}

	void PlayerCollision(bool hide)
	{
		if(hide == true)
		{
			speech.Hide();
			bark.Play();
			whining.StreamPaused = true;
		}
		else
		{
			speech.Show();
			bark.StreamPaused = true;
			whining.Play();
		}
	}
}
