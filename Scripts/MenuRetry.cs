using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuRetry : Node
{
	public override void _Ready()
	{
		this.TryGetNodeInTree(out Main _main);
			
		//button set up
		if(this.TryGetChildren(out List<Button> _buttons))
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
		}

		//rating
		if(this.TryGetChildren(out List<TextureRect> _textures))
		{
			GD.Print(_textures[2].Name); //rating image

			AtlasTexture _rating = _textures[2].Texture as AtlasTexture;
			// GD.Print(_rating.Region);
			// GD.Print(_main.LevelTime.Time);

			double _time = _main.LevelTime.Time;
			Vector2I _size = new Vector2I(254, 254);

			if(_time < 5)
				_rating.Region = new Rect2(new Vector2I(508, 0), _size);
			else if(_time < 10)
				_rating.Region = new Rect2(new Vector2I(254, 0), _size);
			else
				_rating.Region = new Rect2(new Vector2I(0, 0), _size);

			//deaths comment
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
