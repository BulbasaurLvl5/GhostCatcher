using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class Level : TileMap
{
	public int GhostCount { get; set;}

	Main _main;

	public override void _Ready()
	{
		this.TryGetNodeInTree(out _main);

		if(this.TryGetNestedChildren(out List<Ghost> ghosts))
		{
			foreach (var _g in ghosts)
			{
				GhostCount += 1;
			}
		}

		GD.Print("Level counted: "+GhostCount);
	}

	public override void _Process(double delta)
	{
		if (Input.IsActionPressed("Pause"))
		{
			// GetTree().Paused = true;
			UILoader.LoadPauseMenu(_main);
			// GD.Print("pause");
		}
	}

}
