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

	public int GhostCount {get{return _ghostCount;} set{_ghostCount = value;}}
	
	public override void _Ready()
	{		
		List<Node> children;

		if(this.TryGetChildren(out children))
		{
			World = children[0];
			UI = children[1];

			LevelLoader.LoadLevel_0(this);
		}
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
		// GD.Print("ghostcount: "+_ghostCount);
		if(_ghostCount == 0)
		{
			_levelTime.Pause();
			FileIO.Save(_levelTime.Time);
			player.ProcessMode = ProcessModeEnum.Disabled;
			OnLevelSuccess?.Invoke();
		}
	}

	void ClearScenes()
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

	public void SetupLevelLogic()
	{
		getReadyTime.OnStop += () => {
			_levelTime.Start(599); //mission fails at 10min
			player.ProcessMode = ProcessModeEnum.Inherit;
			OnLevelStart?.Invoke();
		};

		OnLevelSuccess += () => {successTime.Start(2);};
		successTime.OnStop += ClearScenes;

		getReadyTime.Start(2);
		_levelTime.Start(-2);
	}
}
