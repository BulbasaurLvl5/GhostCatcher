using Godot;
using System;
using MyGodotExtentions;

public partial class Main : Node
{
	// [Export]
	// bool debug_mode = true;

	// [Export]
	// PackedScene testScene = ResourceLoader.Load<PackedScene>("res://Scenes/test_level.tscn");

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// if(debug_mode)
		// {
		// 	testScene.Instantiate(this, new Vector2(0,0), 0);
		// }
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
