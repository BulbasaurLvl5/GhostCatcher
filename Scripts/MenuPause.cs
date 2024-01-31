using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuPause : Node
{
	public override void _Ready()
	{
		if(this.TryGetChildren(out List<Button> _buttons) && this.TryGetNodeInTree(out Main _main))
		{
			// GetParent().RemoveChild(this);
			// _main.UI.AddChild(this); // it calls AddChild thus is added a second time to the tree while the old version lingers and this now messes with the button sounds
			this.Reparent(_main.UI);

			GetTree().Paused = true;

			//resume
			_buttons[0].Pressed += () => {
				GetTree().Paused = false;
				this.QueueFree();
			};
			
			//retry
			_buttons[1].Pressed += () => {
				GetTree().Paused = false;
				_main.ClearScenes();
				LevelLoader.LoadLevel[_main.Level].Invoke(_main);
			};

			//level
			_buttons[2].Pressed += () => {
				GetTree().Paused = false;
				_main.ClearScenes();
				UILoader.LoadLevelSelector(_main);
			};

			//menu
			_buttons[3].Pressed += () => {
				GetTree().Paused = false;
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};

			//quit
			_buttons[4].Pressed += () => {
				_main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
				_main.GetTree().Quit();
			};

			_buttons[0].GrabFocus();
		}
	}
}
