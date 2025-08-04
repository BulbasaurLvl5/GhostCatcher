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

	Control buttons;
	Control rating;
	public override void _Ready()
	{
		this.TryGetNodeInTree(out Main _main);

		//_main.player.Reparent(this); //exclude oritte from fading behind the black
		token = source.Token;

		if (this.TryGetChildren(out List<Control> _controls))
		{
			// for (int i = 0; i < _controls.Count; i++)
			// 	GD.Print("i:", i, " name:", _controls[i].Name);

			buttons = _controls[0];
			rating = _controls[1];
		}

		//button set up
		if (buttons.TryGetChildren(out List<Button> _buttons))
		{
			// for (int i = 0; i < _buttons.Count; i++)
			// 	GD.Print("i:", i, " name:", _buttons[i].Name);

			_buttons[0].Pressed += () =>
			{
				_main.ClearScenes();
				// await Task.Delay(1); //waiting 1ms so the QueueFree in ClearScenes can do its job
				// Wait(1);
				LevelLoader.Levels[_main.Level].Load.Invoke(_main);
			};

			_buttons[1].Pressed += () =>
			{
				_main.ClearScenes();
				UILoader.LoadLevelSelector(_main);
			};

			_buttons[2].Pressed += () =>
			{
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};

			_buttons[3].Pressed += () =>
			{
				_main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
				_main.GetTree().Quit();
			};

			_buttons[0].GrabFocus();
		}

		//rating
		if (rating.TryGetChildren(out List<TextureRect> _stars))
		{
			int score = LevelLoader.Levels[_main.Level].ReturnScore(_main.LevelTime.Time);

			if (!_main.Failed)
				DisplayScore(score, 333, _stars, token);

			//deaths comment
			// if(this.TryGetChildren(out List<Label> _labels))
			// {
			// 	if(_main.Failed)
			// 		_labels[1].Text = "I am not mad, \ni am disappointed";
			// 	else
			// 		_labels[1].Text = "Its been about time";
			// }
		}

		if (rating.TryGetChildren(out List<Label> _times))
		{
			// for (int i = 0; i < _times.Count; i++)
			// 	GD.Print("i:", i, " name:", _times[i].Name);

			_times[0].Text = TimeCounter.TimeToClock(_main.LevelTime.Time);

			FileIO.SaveGame _save = FileIO.Load();
			_times[1].Text = TimeCounter.TimeToClock(_save.BestTimes[_main.Level]);
		}

		// this block of code moves the player character to center of the screen		
		CharacterBody2D _player = _main.Player();
		Vector2 screenPos = _player.GetGlobalTransformWithCanvas().Origin;
		_player.Reparent(this, true);
		_player.GlobalPosition = screenPos;

		Vector2 _center = GetViewport().GetVisibleRect().Size * .5f;
		
		Tween tween = GetTree().CreateTween();
		tween.TweenProperty(
            _player, 
            "position", 
            new Vector2(_center.X, _center.Y+220),
            1.0f // duration in seconds
        ).SetTrans(Tween.TransitionType.Sine).SetEase(Tween.EaseType.InOut);
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

				_textures[i+1].Show();
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

	// static async void Wait(int milisecdelay)
	// {
	// 	await Task.Delay(milisecdelay);
	// }
}
