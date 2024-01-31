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
	static PackedScene packedLevel_Tutorial = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_tutorial.tscn");
	static PackedScene packedLevel_Platforms = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_platforms.tscn");
	static PackedScene packedLevel_Tunnels = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_tunnels.tscn");
	static PackedScene packedLevel_cliff = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_cliff.tscn");
	static PackedScene packedLevel_spikes = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_spikes.tscn");
	static PackedScene packedLevel_MountainSide = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_MountainSide.tscn");
	static PackedScene packedLevel_Kaktee = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_Kaktee.tscn");
	static PackedScene packedLevel_Vertical = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_Vertical.tscn");
	static PackedScene packedLevel_DeepPit = ResourceLoader.Load<PackedScene>("res://Scenes/level/Level_DeepPit.tscn");
	static PackedScene packedLevel_Columns = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_columns.tscn");
	static PackedScene packedLevel_Treeson = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_treeson.tscn");
	static PackedScene packedLevel_ShakyGround = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_shaky_ground.tscn");
	static PackedScene packedLevel_Breakthrough = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_breakthrough.tscn");
	static PackedScene packedLevel_Caves = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_caves.tscn");
	static PackedScene packedLevel_FactoryYard = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_factory_yard.tscn");
	static PackedScene packedLevel_Forest = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_forest.tscn");
	static PackedScene packedLevel_NewGround = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_new_ground.tscn");
	static PackedScene packedLevel_RingOfFire = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_ring_of_fire.tscn");
	static PackedScene packedLevel_SkullCap = ResourceLoader.Load<PackedScene>("res://Scenes/level/level_skull_cap.tscn");
	
	public static Action<Main>[] LoadLevel = {
		LoadLevel_Tutorial,
		LoadLevel_Platforms,
		LoadLevel_Tunnels,
		LoadLevel_Cliff,
		LoadLevel_Spikes,
		LoadLevel_MountainSide,
		LoadLevel_Kaktee,
		LoadLevel_Vertical,
		LoadLevel_DeepPit,
		LoadLevel_Columns,
		LoadLevel_Treeson,
		LoadLevel_ShakyGround,
		LoadLevel_Breakthrough,
		LoadLevel_Caves,
		LoadLevel_FactoryYard,
		LoadLevel_Forest,
		LoadLevel_NewGround,
		LoadLevel_RingOfFire,
		LoadLevel_SkullCap
		};

	public static async void PlayerDisableDelay(Main _main, int milisecdelay)
	{
		//delay the activation just a little bit, to allow the camera to lock
		await Task.Delay(milisecdelay);
		_main.player.ProcessMode = Node.ProcessModeEnum.Disabled;
	}

	static void LoadLevel_Tutorial(Main _main)
	{
		List<Vector2I> ghostPositions = new List<Vector2I>(){
			new Vector2I(-5*110, -3*110),
			new Vector2I(0*110, -7*110),
			new Vector2I(0*110, -2*110),
			new Vector2I(5*110, -3*110),
		};
		//rotating ghost positions
		//pathGhostPositions

		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-9*110,-3*110), 0);

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

		_main.StartLevel(0);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		FileIO.SaveGame _save = FileIO.Load();
		if(_save.LastTimes[0] == 0)
			UILoader.LoadIntroMenu(_main);

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

		_main.StartLevel(1);

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

		_main.StartLevel(2);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Cliff(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0*110,0*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_cliff.Instantiate(_main.World);

		_main.StartLevel(3);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	
	static void LoadLevel_Spikes(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0*110,-1*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_spikes.Instantiate(_main.World);

		_main.StartLevel(4);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_MountainSide(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-1*110,-1*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_MountainSide.Instantiate(_main.World);

		_main.StartLevel(5);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Kaktee(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0*110,0*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Kaktee.Instantiate(_main.World);

		_main.StartLevel(6);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Vertical(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-165,-385), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Vertical.Instantiate(_main.World);

		_main.StartLevel(7);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_DeepPit(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0,0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_DeepPit.Instantiate(_main.World);

		_main.StartLevel(8);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
	static void LoadLevel_Columns(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, -6500), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Columns.Instantiate(_main.World);

		_main.StartLevel(9);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
	static void LoadLevel_Treeson(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-5300, -100), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Treeson.Instantiate(_main.World);

		_main.StartLevel(10);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
		static void LoadLevel_ShakyGround(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-900, -170), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_ShakyGround.Instantiate(_main.World);

		_main.StartLevel(11);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

		static void LoadLevel_Breakthrough(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, -220), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Breakthrough.Instantiate(_main.World);

		_main.StartLevel(12);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

		static void LoadLevel_Caves(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Caves.Instantiate(_main.World);

		_main.StartLevel(13);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

		static void LoadLevel_FactoryYard(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_FactoryYard.Instantiate(_main.World);

		_main.StartLevel(14);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

		static void LoadLevel_Forest(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Forest.Instantiate(_main.World);

		_main.StartLevel(15);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
		static void LoadLevel_NewGround(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_NewGround.Instantiate(_main.World);

		_main.StartLevel(16);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
		static void LoadLevel_RingOfFire(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_RingOfFire.Instantiate(_main.World);

		_main.StartLevel(17);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
		static void LoadLevel_SkullCap(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(0, 0), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_SkullCap.Instantiate(_main.World);

		_main.StartLevel(18);

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
}
