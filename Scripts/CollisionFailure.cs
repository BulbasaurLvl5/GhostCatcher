using Godot;
using System;
using MyGodotExtentions;

public partial class CollisionFailure : Node
{
	public override void _Ready()
	{
		Area2D _parent;
		Main _main;

		if(this.TryGetParent<Area2D>(out _parent) && this.TryGetNodeInTree<Main>(out _main))
		{
			// alternative identifier
			// GDScript MyGDScript = GD.Load<GDScript>("res://scenes/levels/TestBody.gd");
			// GD.Print(body.GetScript().As<GDScript>() == MyGDScript);
			_parent.BodyEntered += (Node2D n) => {if (n is CharacterBody2D) {_main.FailLevel();} };
		}
		else
		{
			GD.Print("CollisionFailure was unable to find its needed nodes.");
		}
	}
}
