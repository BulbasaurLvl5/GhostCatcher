using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class Dog : Area2D
{
	Node2D speech;

	public override void _Ready()
	{
		if(this.TryGetChildren(out List<Node2D> children))
		{
			GD.Print(children[3].Name);
			speech = children[3];
		}

		BodyEntered += (Node2D n) => {if (n is CharacterBody2D) {PlayerCollision(false);};};
		BodyExited += (Node2D n) => {if (n is CharacterBody2D) {PlayerCollision(true);};};
	}

	void PlayerCollision(bool hide)
	{
		if(hide == true)
			speech.Hide();
		else
			speech.Show();
	}
}
