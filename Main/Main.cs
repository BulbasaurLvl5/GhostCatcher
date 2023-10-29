using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class Main : Node
{
	// [Export]
	// PackedScene testScene = ResourceLoader.Load<PackedScene>("res://Scenes/test_level.tscn");
	// 	testScene.Instantiate(this, new Vector2(0,0), 0);

	List<Node> children = new List<Node>();

	TimeCounter levelTime = new TimeCounter();

	Node World;
	Node UI;

	[Export]
	PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://Scenes/time_label.tscn");

	[Export]
	PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");

	[Export]
	PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://Scenes/player.tscn");
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Main Ready");

		// timer should start with delay. some READY! SET! GO! stuff (better: READY! GO!)
		//set stop to 9min 59s 9999 and then end mission
		levelTime.Start(0); 

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

		if (Input.IsActionPressed("Jump"))
		{
			FileIO.Save(levelTime.Time);
		}
	}

	void LoadMission(int level)
	{
		//add some input to know which level will be loaded
		//add switch state that loads the respective JSON

		// timeLabel.Instantiate(UI, new Vector2(0,0), 0);
		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_timeLabel.Init(ref levelTime);
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		UI.AddChild(_timeLabel);

		TileMap platforms = packedPlatforms.Instantiate(World)as TileMap;

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

		packedPlayer.Instantiate(World, new Vector2(3,7), 0);

		//needs to know how many targets there are. likely also input and OnDestroy of each target -1
	}
}
