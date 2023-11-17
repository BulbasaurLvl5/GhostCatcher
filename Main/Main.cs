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

	public Node2D player;

	int _ghostCount = 0;

	public Action OnLevelStart;

	public Action OnLevelSucceed;

	public Action OnLevelFail;

	public Action OnGhostCollision;

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

		OnLevelSucceed += () => {endTime.Start(2);};
		OnLevelFail += () => {endTime.Start(2);};

		endTime.OnStop += EndLevel;
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
		GhostCount = 0;
		getReadyTime.Start(2);
		_levelTime.Start(-2);

		if(World.TryGetAllChildren(out List<Ghost> ghosts))
		{
			foreach (var _g in ghosts)
			{
				_g.BodyEntered += GhostCollision;
				GhostCount += 1;
			}
		}
	}

	public void EndLevel()
	{
		ClearScenes();
		UILoader.LoadLevelSelector(this);
		_levelTime.Reset();
	}

	public void SucceedLevel()
	{
		_levelTime.Pause();
		FileIO.Save(Level, _levelTime.Time);
		player.ProcessMode = ProcessModeEnum.Disabled;
		OnLevelSucceed?.Invoke();
	}

	public void FailLevel()
	{
		_levelTime.Pause();
		player.ProcessMode = ProcessModeEnum.Disabled;
		OnLevelFail?.Invoke();
	}
}
