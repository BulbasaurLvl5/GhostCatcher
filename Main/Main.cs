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
	PackedScene timeLabel = ResourceLoader.Load<PackedScene>("res://Scenes/time_label.tscn");
	
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

			LoadMission();
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		levelTime.Update(delta);
	}

	void LoadMission()
	{
		//add some input to know which level will be loaded
		//add switch state that loads the respective JSON

		// timeLabel.Instantiate(UI, new Vector2(0,0), 0);
		TimeLabel _timeLabel = timeLabel.Instantiate<TimeLabel>();
		_timeLabel.Init(ref levelTime);
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		UI.AddChild(_timeLabel);

		//needs to know how many targets there are. likely also input and OnDestroy of each target -1
	}
}
