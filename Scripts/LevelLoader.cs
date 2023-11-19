using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtentions;
using System.Threading.Tasks;

public static class LevelLoader
{
	static PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://Scenes/player.tscn");
	static PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://Scenes/time_label.tscn");
	static PackedScene packedCenterLabel = ResourceLoader.Load<PackedScene>("res://Scenes/main_label.tscn");

	static PackedScene packedGhostDisplay = ResourceLoader.Load<PackedScene>("res://Scenes/remaining_ghost_display.tscn");
	// static PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");
	static PackedScene packedGhost = ResourceLoader.Load<PackedScene>("res://Scenes/ghost.tscn");
	static PackedScene packedPit = ResourceLoader.Load<PackedScene>("res://Scenes/endless_pit.tscn");

	//levels
	static PackedScene packedTestLevel = ResourceLoader.Load<PackedScene>("res://Scenes/test_level.tscn");
	static PackedScene packedLevel_Tutorial = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_tutorial.tscn");

	static PackedScene packedLevel_Platforms = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_platforms.tscn");

	static PackedScene packedLevel_Tunnels = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_tunnels.tscn");

	public static Action<Main>[] LoadLevel = {
		LoadLevel_TestScene,
		LoadLevel_Tutorial,
		LoadLevel_Platforms,
		LoadLevel_Tunnels,
	
		};

	public static async void PlayerDisableDelay(Main _main, int milisecdelay)
	{
		//delay the activation just a little bit, to allow the camera to lock
		await Task.Delay(milisecdelay);
		_main.player.ProcessMode = Node.ProcessModeEnum.Disabled;
	}

	static void LoadLevel_TestScene(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(3730,810), 0);
		// _main.player.ProcessMode = Node.ProcessModeEnum.Disabled;

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		Node _testlevel = packedTestLevel.Instantiate(_main.World) as Node;

		Ghost _g = packedGhost.Instantiate(_main.World, new Vector2I(3600, -800), 0) as Ghost;
		// _g.BodyEntered += _main.GhostCollision;
		// _main.GhostCount += 1;
		_main.StartLevel(0);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Tutorial(Main _main)
	{
		List<Vector2I> ghostPositions = new List<Vector2I>(){
			new Vector2I(6*110, 4*110),
			new Vector2I(11*110, 0),
			new Vector2I(11*110, 5*110),
			new Vector2I(16*110, 4*110),
		};
		//rotating ghost positions
		//pathGhostPositions

		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(1*110,5*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Tutorial.Instantiate(_main.World);

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(_main.World, _gp, 0) as Ghost;
			// _g.BodyEntered += _main.GhostCollision;
			// _main.GhostCount += 1;
		}
		//like different ghost types will require special code. thats why the region ends below

		_main.StartLevel(1);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Platforms(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(1*110,-1*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Platforms.Instantiate(_main.World);

		_main.StartLevel(2);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Tunnels(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(8*110,-5*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Tunnels.Instantiate(_main.World);

		_main.StartLevel(3);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
}
