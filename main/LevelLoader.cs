using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtensions;
using System.Threading.Tasks;
using System.Runtime.CompilerServices;
using System.Reflection.Metadata.Ecma335;

public static class LevelLoader
{
	static PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://entities/player/player.tscn");
	static PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://ui/time_label.tscn");
	static PackedScene packedCenterLabel = ResourceLoader.Load<PackedScene>("res://ui/main_label.tscn");

	static PackedScene packedGhostDisplay = ResourceLoader.Load<PackedScene>("res://ui/remaining_ghost_display.tscn");
	// static PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");
	static PackedScene packedGhost = ResourceLoader.Load<PackedScene>("res://entities/mobs/ghost.tscn");
	static PackedScene packedPit = ResourceLoader.Load<PackedScene>("res://environment/endless_pit.tscn");

	//levels
	static PackedScene packedLevel_Tutorial = ResourceLoader.Load<PackedScene>("res://levels/tutorial.tscn");
	static PackedScene packedLevel_Platforms = ResourceLoader.Load<PackedScene>("res://levels/platforms.tscn");
	static PackedScene packedLevel_Tunnels = ResourceLoader.Load<PackedScene>("res://levels/tunnels.tscn");
	static PackedScene packedLevel_cliff = ResourceLoader.Load<PackedScene>("res://levels/cliff.tscn");
	static PackedScene packedLevel_spikes = ResourceLoader.Load<PackedScene>("res://levels/spikes.tscn");
	static PackedScene packedLevel_MountainSide = ResourceLoader.Load<PackedScene>("res://levels/mountainside.tscn");
	static PackedScene packedLevel_Kaktee = ResourceLoader.Load<PackedScene>("res://levels/kaktee.tscn");
	static PackedScene packedLevel_Vertical = ResourceLoader.Load<PackedScene>("res://levels/vertical.tscn");
	static PackedScene packedLevel_DeepPit = ResourceLoader.Load<PackedScene>("res://levels/deep_pit.tscn");
	static PackedScene packedLevel_Columns = ResourceLoader.Load<PackedScene>("res://levels/columns.tscn");
	static PackedScene packedLevel_Treeson = ResourceLoader.Load<PackedScene>("res://levels/treeson.tscn");
	static PackedScene packedLevel_ShakyGround = ResourceLoader.Load<PackedScene>("res://levels/shaky_ground.tscn");
	static PackedScene packedLevel_Breakthrough = ResourceLoader.Load<PackedScene>("res://levels/breakthrough.tscn");
	static PackedScene packedLevel_Caves = ResourceLoader.Load<PackedScene>("res://levels/caves.tscn");
	static PackedScene packedLevel_FactoryYard = ResourceLoader.Load<PackedScene>("res://levels/factory_yard.tscn");
	static PackedScene packedLevel_Forest = ResourceLoader.Load<PackedScene>("res://levels/forest.tscn");
	static PackedScene packedLevel_NewGround = ResourceLoader.Load<PackedScene>("res://levels/new_ground.tscn");
	static PackedScene packedLevel_RingOfFire = ResourceLoader.Load<PackedScene>("res://levels/ring_of_fire.tscn");
	static PackedScene packedLevel_SkullCap = ResourceLoader.Load<PackedScene>("res://levels/skull_cap.tscn");
	static PackedScene packedLevel_blocks = ResourceLoader.Load<PackedScene>("res://levels/blocks.tscn");

	public class Level
	{
		public string Name {get;}
		public float[] StarTimes{get;}

		public Action<Main> Load {get;}

		public Level(string name, float[] starTimes, Action<Main> loadfunction)
		{
			this.Name = name;
			this.StarTimes = starTimes;
			this.Load = loadfunction;
		}

		public int ReturnScore(double time)
		{
			if(time == 0)
				return 0; //case for being called via MenuLevel after unlock

			for (int i = 0; i < StarTimes.Length; i++)
			{
				if(time < StarTimes[i])
					return StarTimes.Length-i; //higher rating is better
			}
			return 0;        
		}
	}

	public static Level[] Levels = {
	// collectible ghosts, endless pit
		new Level("tutorial", new float[]{5,6,7,8,9}, LoadLevel_Tutorial),
		new Level("tunnels", new float[]{}, LoadLevel_Tunnels),
		new Level("vertical", new float[]{}, LoadLevel_Vertical),
		new Level("treeson", new float[]{}, LoadLevel_Treeson),
		new Level("cliff", new float[]{}, LoadLevel_Cliff),

    // moving platforms
		new Level("blocks", new float[]{}, LoadLevel_blocks),
    // 1st enemy type (ghosts)
    // spikes
		new Level("spikes", new float[]{}, LoadLevel_Spikes),
		new Level("mountain", new float[]{}, LoadLevel_MountainSide),
		new Level("cactee", new float[]{}, LoadLevel_Kaktee),
		new Level("deeppit", new float[]{}, LoadLevel_DeepPit),
		new Level("columns", new float[]{}, LoadLevel_Columns),
    // 2nd enemy type (skulls)
		new Level("skulls", new float[]{}, LoadLevel_Platforms),
    // falling platforms
		new Level("shaky", new float[]{}, LoadLevel_ShakyGround),
    // 3rd enemy type (???)
    // extra air
	// unasigned
		new Level("break", new float[]{}, LoadLevel_Breakthrough),
		new Level("caves", new float[]{}, LoadLevel_Caves),
		new Level("factory", new float[]{}, LoadLevel_FactoryYard),
		new Level("forest", new float[]{}, LoadLevel_Forest),
		new Level("firering", new float[]{}, LoadLevel_RingOfFire),
		new Level("newground", new float[]{}, LoadLevel_NewGround),
		new Level("skullcap", new float[]{}, LoadLevel_SkullCap),
	};

	public static async void PlayerDisableDelay(Main _main, int milisecdelay)
	{
		//delay the activation just a little bit, to allow the camera to lock
		await Task.Delay(milisecdelay);
		_main.player.ProcessMode = Node.ProcessModeEnum.Disabled;
	}

	static int LevelID(Action<Main> action)
	{
		foreach (var _level in Levels)
			if (_level.Load == action)
				return Array.IndexOf(Levels, _level);
		return 0;
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

		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-23*110,-1*110), 0);

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

		_main.StartLevel(LevelID(LoadLevel_Tutorial));

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

		_main.StartLevel(LevelID(LoadLevel_Platforms));

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

		_main.StartLevel(LevelID(LoadLevel_Tunnels));

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Cliff(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-10*110,-5*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_cliff.Instantiate(_main.World);

		_main.StartLevel(LevelID(LoadLevel_Cliff));

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_blocks(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-10*110,-5*110), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_blocks.Instantiate(_main.World);

		_main.StartLevel(LevelID(LoadLevel_blocks));

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

		_main.StartLevel(LevelID(LoadLevel_Spikes));

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

		_main.StartLevel(LevelID(LoadLevel_MountainSide));

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

		_main.StartLevel(LevelID(LoadLevel_Kaktee));

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

		_main.StartLevel(LevelID(LoadLevel_Vertical));

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

		_main.StartLevel(LevelID(LoadLevel_DeepPit));

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

		_main.StartLevel(LevelID(LoadLevel_Columns));

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
	
	static void LoadLevel_Treeson(Main _main)
	{
		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(-3960, -220), 0);

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		packedLevel_Treeson.Instantiate(_main.World);

		_main.StartLevel(LevelID(LoadLevel_Treeson));

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

		_main.StartLevel(LevelID(LoadLevel_ShakyGround));

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

		_main.StartLevel(LevelID(LoadLevel_Breakthrough));

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

		_main.StartLevel(LevelID(LoadLevel_Caves));

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

		_main.StartLevel(LevelID(LoadLevel_FactoryYard));

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

		_main.StartLevel(LevelID(LoadLevel_Forest));

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

		_main.StartLevel(LevelID(LoadLevel_NewGround));

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

		_main.StartLevel(LevelID(LoadLevel_RingOfFire));

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

		_main.StartLevel(LevelID(LoadLevel_SkullCap));

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
}