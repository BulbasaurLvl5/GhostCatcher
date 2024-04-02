using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Runtime.CompilerServices;

public partial class MenuRetry : Node
{
	CancellationTokenSource source = new CancellationTokenSource();
	CancellationToken token;
	public override void _Ready()
	{
		this.TryGetNodeInTree(out Main _main);

		token = source.Token;
			
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
			// GD.Print(_textures[0].Name); death
			// GD.Print(_main.LevelTime.Time);
			// GD.Print(_main.Level);

			int score = LevelTimesData.ReturnScore(_main.Level, _main.LevelTime.Time);

			if(!_main.Failed)
			{
				DisplayScore(score, 333, _textures, token);
			}

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

	public static async void DisplayScore(int score, int milisecdelay, List<TextureRect> _textures, CancellationToken token)
	{
		for (int i = 0; i < score; i++)
		{
			try
			{
				await Task.Delay(milisecdelay, token);
				if(token.IsCancellationRequested)
					return;

				_textures[i+2].Show(); //i+1 because first image in scene is death
			}
			catch(OperationCanceledException)
			{
				return;
			}
		}
	}

	public override void _ExitTree()
	{
		source.Cancel();
		base._ExitTree();
	}
}
