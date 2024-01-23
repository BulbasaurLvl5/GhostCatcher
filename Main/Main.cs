using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class Main : Node
{
	TimeCounter _levelTime = new TimeCounter();

	public TimeCounter LevelTime {get{return _levelTime;}}

	TimeCounter getReadyTime = new TimeCounter();

	TimeCounter endTime = new TimeCounter();

	public Node World;
	public Node UI;

	public BackgroundMusic BackgroundMusic;

	public Node2D player;

	int _ghostCount = 0;

	public Action OnLevelStart;

	public Action OnLevelSucceed;

	public Action OnLevelFail;

	public Action OnGhostCollision;

	public int GhostCount {get{return _ghostCount;} set{_ghostCount = value;}}

	public int Level{ get; set; }

	public bool Failed {get; set;}
	
	public override void _Ready()
	{
		List<Node> children;

		if(this.TryGetChildren(out children))
		{
			World = children[0];
			UI = children[1];
			BackgroundMusic = children[2] as BackgroundMusic;

			// LevelLoader.LoadLevel(this, 0);
			// UILoader.LoadLevelSelector(this);
			UILoader.LoadMainMenu(this);
		}

		getReadyTime.OnStop += () => {
			_levelTime.Start(599); //mission fails at 10min
			player.ProcessMode = ProcessModeEnum.Inherit;
			OnLevelStart?.Invoke();
		};

		OnLevelSucceed += () => {endTime.Start(1);};
		OnLevelFail += () => {endTime.Start(1);};

		endTime.OnStop += EndLevel;

		//load video settings
		FileIO.PlayerPrefs _playerPrefs = FileIO.LoadPlayerPrefs();
		VideoSettings.SetVsync(VideoSettings.VsyncOptions[_playerPrefs.VideoSettings[0]]);
		VideoSettings.SetWindowMode(VideoSettings.WindowOptions[_playerPrefs.VideoSettings[1]]);
		VideoSettings.SetWindowSize(VideoSettings.ResolutionOptions[_playerPrefs.VideoSettings[2]]);

		//load input settings
		//because of the set up (GDS+C# + how remap button works) we have to quickly load the whole menu...
		Node _optionsmenu = UILoader.LoadOptionsMenu(this);
		_optionsmenu.QueueFree();
		if(this.TryGetNestedChildren(out List<Button> _buttons)){ _buttons[2].GrabFocus(); } //select level select button
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

		if(_ghostCount == 0)
		{
			SucceedLevel();
		}
	}

	public void ClearScenes()
	{
		if(World.TryGetNestedChildren(out List<Ghost> ghosts))
		{
			foreach (var _g in ghosts)
			{
				_g.QueueFree(); //this loop is necessary because godots GetChildren() has difficulties with nested scenes
				_g.BodyEntered -= GhostCollision;
			}
		}

		foreach (var _c in World.GetChildren(true))
		{
			GD.Print(_c.Name);
			_c.QueueFree();
		}

		foreach (var _c in UI.GetChildren(true))
		{
			_c.QueueFree();
		}
	}

	public void StartLevel(int lvl)
	{
		Level = lvl;
		GhostCount = 0;
		getReadyTime.Start(2);
		_levelTime.Start(-2);

		if(World.TryGetNestedChildren(out List<Ghost> ghosts))
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
				if(!_g.IsQueuedForDeletion())
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
		player.ProcessMode = ProcessModeEnum.Disabled;
		OnLevelSucceed?.Invoke();
		Failed = false;
	}

	public void FailLevel()
	{
		_levelTime.Pause();
		player.ProcessMode = ProcessModeEnum.Disabled;
		OnLevelFail?.Invoke();
		Failed = true;
	}
}
