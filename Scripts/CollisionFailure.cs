using Godot;
using System;
using MyGodotExtentions;

public partial class CollisionFailure : Node
{
	public override void _Ready()
	{
		if(this.TryGetParent<Area2D>(out Area2D _parent) && this.TryGetNodeInTree<Main>(out Main _main))
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
