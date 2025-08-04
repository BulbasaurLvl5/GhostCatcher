using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class MenuPause : Node
{
	public override void _Ready()
	{
		if (this.TryGetChildren(out List<Button> _buttons) && this.TryGetNodeInTree(out Main _main))
		{
			// GetParent().RemoveChild(this);
			//_main.UI.AddChild(this); // it calls AddChild thus is added a second time to the tree while the old version lingers and this now messes with the button sounds
			// this.Reparent(_main.UI);

			GetTree().Paused = true;
			AnimationPlayer _camera_animation = _main.Player().TryGetChild<Camera2D>().TryGetChild<AnimationPlayer>();

			//resume
			_buttons[0].Pressed += () =>
			{
				GetTree().Paused = false;
				_camera_animation.Play("zoom_in");
				this.QueueFree();
			};

			//retry
			_buttons[1].Pressed += () =>
			{
				GetTree().Paused = false;
				_main.ClearScenes();
				LevelLoader.Levels[_main.Level].Load.Invoke(_main);
			};

			//level
			_buttons[2].Pressed += () =>
			{
				GetTree().Paused = false;
				_main.ClearScenes();
				UILoader.LoadLevelSelector(_main);
			};

			//menu
			_buttons[3].Pressed += () =>
			{
				GetTree().Paused = false;
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};

			//quit
			_buttons[4].Pressed += () =>
			{
				_main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
				_main.GetTree().Quit();
			};

			_buttons[0].GrabFocus();

			// get player from main
			// grab camera animationplayer
			// zoom out
			// zoom in in _ExitTree
			GD.Print(_main.Player().Position);

			_camera_animation.Play("zoom_out");
		}
	}
}
