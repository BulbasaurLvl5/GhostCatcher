using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class Main : Node
{
	TimeCounter levelTime = new TimeCounter();

	TimeCounter getReadyTime = new TimeCounter();

	Node World;
	Node UI;

	[Export]
	PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://Scenes/time_label.tscn");

	[Export]
	PackedScene packedCenterLabel = ResourceLoader.Load<PackedScene>("res://Scenes/center_label.tscn");

	Label _center_label;

	[Export]
	PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");

	[Export]
	PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://Scenes/player.tscn");

	[Export]
	PackedScene packedGhost = ResourceLoader.Load<PackedScene>("res://Scenes/ghost.tscn");

	int _ghostCount = 0;

	public int GhostCount {get{return _ghostCount;}}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Main Ready");

		getReadyTime.OnStop += () => {
			//set stop to 9min 59s 9999 and then end mission
			// levelTime.Start(0);
			_center_label.Visible = false;
		};

		// levelTime.Start(0);
		// levelTime.Pause();

		getReadyTime.Start(2);
		levelTime.Start(-2);
		
		List<Node> children;

		if(this.TryGetChildren(out children))
		{
			World = children[0];
			UI = children[1];

			LoadMission(0);
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		levelTime.Update(delta);
		getReadyTime.Update(delta);
	}

	public void GhostTreeExit()
	{
		_ghostCount -= 1;
		GD.Print("ghostcount: "+_ghostCount);

		if(_ghostCount == 0)
		{
			levelTime.Pause();
			FileIO.Save(levelTime.Time);

			_center_label.Visible=true;
			_center_label.Text = "SUCCESS!";
		}
	}

	void LoadMission(int level)
	{
		//add some input to know which level will be loaded
		//also move code somewhere else. some kind of leveloader class / script. statik class?

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_timeLabel.Init(ref levelTime);
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		UI.AddChild(_timeLabel);

		_center_label = packedCenterLabel.Instantiate<Label>();
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		UI.AddChild(_center_label);
		_center_label.Text = "Get READY!";

		TileMap platforms = packedPlatforms.Instantiate(World) as TileMap;

		List<Vector2I> tilepositions = new List<Vector2I>()
		{
			new Vector2I(3, 8),
			new Vector2I(4, 8),
			new Vector2I(5, 8),
			new Vector2I(6, 8),
			new Vector2I(7, 8),
			new Vector2I(8, 8),
			new Vector2I(9, 8),
			new Vector2I(10, 8),
			new Vector2I(11, 8),
			new Vector2I(12, 8),
			new Vector2I(13, 8),
			new Vector2I(14, 8),
			new Vector2I(15, 8),
			new Vector2I(16, 8),
			new Vector2I(17, 8),

			new Vector2I(5, 5),
			new Vector2I(6, 5),
			new Vector2I(7, 5),

			new Vector2I(10, 2),
			new Vector2I(11, 2),
			new Vector2I(12, 2),

			new Vector2I(15, 5),
			new Vector2I(16, 5),
			new Vector2I(17, 5),
		};

		foreach (var _tp in tilepositions)
		{
			platforms.SetCell(0, _tp, 0, new Vector2I(3,3));
		}
		// platforms.SetCellsTerrainConnect(0, tilepositions, 0, 0); //has to be godot collection. but when done looks like it does not require the foreach loop

		packedPlayer.Instantiate(World, new Vector2(4*128,7*128), 0);

		List<Vector2I> ghostPositions = new List<Vector2I>()
		{
			new Vector2I(6*128, 4*128),
			new Vector2I(11*128, 0),
			new Vector2I(11*128, 5*128),
			new Vector2I(16*128, 4*128),
		};

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(World, _gp, 0) as Ghost;
			_g.TreeExited += GhostTreeExit;
			_ghostCount += 1;
		}
	}
}
