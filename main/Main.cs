using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;
using System.Linq;

public partial class Main : Node
{
	TimeCounter _levelTime = new TimeCounter();

	public TimeCounter LevelTime { get { return _levelTime; } }

	TimeCounter getReadyTime = new TimeCounter();

	TimeCounter endTime = new TimeCounter();

	public Node World;
	public Node UI;

	public BackgroundMusic BackgroundMusic;

	// public Node2D player;

	int _ghostCount = 0;

	public Action OnLevelStart;

	public Action OnLevelSucceed;

	public Action OnLevelFail;

	public Action OnGhostCollision;

	public int GhostCount { get { return _ghostCount; } set { _ghostCount = value; } }

	public int Level { get; set; }

	public bool Failed { get; set; }

	public override void _Ready()
	{
		List<Node> children;

		if (this.TryGetChildren(out children))
		{
			World = children[0];
			UI = children[1];
			BackgroundMusic = children[2] as BackgroundMusic;

			// LevelLoader.LoadLevel(this, 0);
			// UILoader.LoadLevelSelector(this);
			UILoader.LoadMainMenu(this);
		}

		getReadyTime.OnStop += () =>
		{
			_levelTime.Start(599); //mission fails at 10min
			Player().ProcessMode = ProcessModeEnum.Inherit;
			// GD.Print("timer: "+Player().Name + Player().ProcessMode);
			OnLevelStart?.Invoke();
		};

		OnLevelSucceed += () => { endTime.Start(1); };
		OnLevelFail += () => { endTime.Start(1); };

		endTime.OnStop += EndLevel;

		InputAssistance.StoreProjectSettingsInputMap();

		LoadSettings();

		if (this.TryGetNestedChildren(out List<Button> _buttons))
			_buttons[2].GrabFocus();//select level select button
	}

	public override void _Process(double delta)
	{
		_levelTime.Update(delta);
		getReadyTime.Update(delta);
		endTime.Update(delta);
	}

	public void GhostCollision(Node2D node)
	{
		_ghostCount -= 1;
		OnGhostCollision?.Invoke();

		if (_ghostCount == 0)
		{
			SucceedLevel();
		}
	}

	public async void ClearScenes()
	{
		if (World.TryGetNestedChildren(out List<Ghost> ghosts))
		{
			foreach (var _g in ghosts)
			{
				_g.QueueFree(); //this loop is necessary because godots GetChildren() has difficulties with nested scenes
				_g.BodyEntered -= GhostCollision;
			}
		}

		foreach (var _c in World.GetChildren(true))
		{
			// GD.Print(_c.Name);
			_c.QueueFree();
		}

		foreach (var _c in UI.GetChildren(true))
		{
			_c.QueueFree();
		}

		// GD.Print("frame#: "+GetTree().GetFrame());
		await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
		// GD.Print("frame#: "+GetTree().GetFrame());
	}

	public void StartLevel(int lvl)
	{
		Level = lvl;
		GhostCount = 0;
		getReadyTime.Start(1);
		_levelTime.Start(-1);
		Player().ProcessMode = ProcessModeEnum.Disabled;
		// GD.Print("main player: "+Player().Name + Player().ProcessMode);

		if (World.TryGetNestedChildren(out List<Ghost> ghosts))
		{
			foreach (var _g in ghosts)
			{
				/*
				ok so before start level ClearScenes is called by Levelloader
				ClearScenes dequeues objects. so they still linger when the next level is loaded and the ghosts are counted
				one way is to exclude ghosts queed for deletion (solution below)
				the better solution would be to create a level script and attach it to each level and let them handle the ghost counting themselfs
				this is likely the result of this simple game becoming too complex already
				*/
				if (!_g.IsQueuedForDeletion())
				{
					_g.BodyEntered += GhostCollision;
					GhostCount += 1;
				}
			}
		}

		BackgroundMusic.FadeoutToPlay(BackgroundMusic.SongNames.labyrinthofdespair);
	}

	public void EndLevel()
	{
		// ClearScenes();
		// UILoader.LoadLevelSelector(this);
		UILoader.LoadRetryMenu(this);
		_levelTime.Reset();
	}

	public void SucceedLevel()
	{
		_levelTime.Pause();
		FileIO.Save(Level, _levelTime.Time);
		Player().ProcessMode = ProcessModeEnum.Disabled;
		OnLevelSucceed?.Invoke();
		Failed = false;
		FileIO.Save(EvaluateQuote());
	}

	public void FailLevel(CauseOfDeath causeOfDeath)
	{
		// GD.Print("Ori died to: "+causeOfDeath.ToString());
		FileIO.Save(causeOfDeath);
		_levelTime.Pause();
		Player().ProcessMode = ProcessModeEnum.Disabled;
		OnLevelFail?.Invoke();
		Failed = true;
		FileIO.Save(EvaluateQuote(causeOfDeath));
	}

	public CharacterBody2D Player()
	{
		if (this.TryGetNodeInTree("Player", out CharacterBody2D _player))
		{
			// GD.Print("main player: "+_player.Name);
			return _player;
		}

		throw new Exception("Player not found");
	}

	void LoadSettings()
	{
		FileIO.PlayerPrefs _playerPrefs = FileIO.LoadPlayerPrefs();

		VideoSettings.SetVsync(VideoSettings.VsyncOptions[_playerPrefs.VideoSettings[0]]);
		VideoSettings.SetWindowMode(VideoSettings.WindowOptions[_playerPrefs.VideoSettings[1]]);
		VideoSettings.SetWindowSize(VideoSettings.ResolutionOptions[_playerPrefs.VideoSettings[2]]);

		float _t = Mathf.Clamp((float)_playerPrefs.AudioSettings[0] * .01f, .001f, 1);
		AudioServer.SetBusVolumeDb(0, Mathf.LinearToDb(_t));
		_t = Mathf.Clamp((float)_playerPrefs.AudioSettings[1] * .01f, .001f, 1);
		AudioServer.SetBusVolumeDb(1, Mathf.LinearToDb(_t));
		_t = Mathf.Clamp((float)_playerPrefs.AudioSettings[2] * .01f, .001f, 1);
		AudioServer.SetBusVolumeDb(2, Mathf.LinearToDb(_t));
		_t = Mathf.Clamp((float)_playerPrefs.AudioSettings[3] * .01f, .001f, 1);
		AudioServer.SetBusVolumeDb(3, Mathf.LinearToDb(_t));

		InputAssistance.SetInputMap(_playerPrefs.ControlSettings);
	}
}
