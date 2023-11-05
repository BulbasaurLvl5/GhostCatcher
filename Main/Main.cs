using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class Main : Node
{
	TimeCounter _levelTime = new TimeCounter();

	public TimeCounter LevelTime {get{return _levelTime;}}

	TimeCounter getReadyTime = new TimeCounter();

	TimeCounter successTime = new TimeCounter();

	public Node World;
	public Node UI;

	public Node2D player;

	int _ghostCount = 0;

	public Action OnLevelStart;

	public Action OnLevelSuccess;

	public Action OnGhostTreeExit;

	public int GhostCount {get{return _ghostCount;} set{_ghostCount = value;}}

	int Level{ get; set; }
	
	public override void _Ready()
	{		
		List<Node> children;

		if(this.TryGetChildren(out children))
		{
			World = children[0];
			UI = children[1];

			// LevelLoader.LoadLevel(this, 0);
			UILoader.LoadLevelSelector(this);
		}

		getReadyTime.OnStop += () => {
			_levelTime.Start(599); //mission fails at 10min
			player.ProcessMode = ProcessModeEnum.Inherit;
			OnLevelStart?.Invoke();
		};

		OnLevelSuccess += () => {successTime.Start(2);};

		successTime.OnStop += () => {
			ClearScenes();
			UILoader.LoadLevelSelector(this);
			_levelTime.Reset();
		};
	}

	public override void _Process(double delta)
	{
		_levelTime.Update(delta);
		getReadyTime.Update(delta);
		successTime.Update(delta);
	}

	public void GhostTreeExit()
	{
		_ghostCount -= 1;
		OnGhostTreeExit?.Invoke();
		// GD.Print("ghostcount: "+_ghostCount);
		if(_ghostCount == 0)
		{
			_levelTime.Pause();
			FileIO.Save(Level, _levelTime.Time);
			player.ProcessMode = ProcessModeEnum.Disabled;
			OnLevelSuccess?.Invoke();
		}
	}

	public void ClearScenes()
	{
		foreach (var _c in World.GetChildren())
		{
			_c.QueueFree();
		}

		foreach (var _c in UI.GetChildren())
		{
			_c.QueueFree();
		}
	}

	public void StartLevel(int lvl)
	{
		Level = lvl;
		getReadyTime.Start(2);
		_levelTime.Start(-2);
	}
}
