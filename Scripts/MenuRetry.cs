using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuRetry : Node
{
	public override void _Ready()
	{
		if(this.TryGetChildren(out List<Button> _buttons) && this.TryGetNodeInTree(out Main _main))
		{
			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				// await Task.Delay(1); //waiting 1ms so the QueueFree in ClearScenes can do its job
				LevelLoader.LoadLevel[_main.Level].Invoke(_main);
			};

			_buttons[1].Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadLevelSelector(_main);
			};

			_buttons[2].Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};

			_buttons[3].Pressed += () => {
				_main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
				_main.GetTree().Quit();
			};

			_buttons[0].GrabFocus();

			if(this.TryGetChildren(out List<Label> _labels))
			{
				if(_main.Failed)
					_labels[1].Text = "I am not mad, \ni am disappointed";
				else
					_labels[1].Text = "Its been about time";
			}
		}
	}
}
