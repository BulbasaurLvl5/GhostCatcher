using Godot;
using System;
using MyGodotExtentions;

public partial class RemainingGhostDisplay : HBoxContainer
{
	public override void _Ready()
	{
		TextureRect _ghosticon;
		this.TryGetChild(out _ghosticon);

		if(this.TryGetNodeInTree<Main>(out Main _main))
		{
			int _g = _main.GhostCount;
			for (int i = 1; i < _g; i++)
			{
				AddChild(_ghosticon.Duplicate());
			}

			_main.OnGhostCollision += DeleteIcon;

			TreeExited += () => {
				_main.OnGhostCollision -= DeleteIcon;
			};
		}
	}

	void DeleteIcon()
	{
		TextureRect _ghosticon;
		this.TryGetChild(out _ghosticon);
		_ghosticon.QueueFree();
	}
}
