using Godot;
using System;
using MyGodotExtensions;

public partial class MenuIntro : Node
{
	public override void _Ready()
	{
		GetTree().Paused = true;

		if(this.TryGetChild(out Button startbutton))
		{
			startbutton.GrabFocus();
			startbutton.Pressed += () => {
				GetTree().Paused = false;
				QueueFree();
			};
		}
	}
}
