using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtensions;
using System.Threading.Tasks;
using System.Runtime.CompilerServices;
using System.Reflection.Metadata.Ecma335;

public static class LevelLoader
{
	// static PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://entities/player/player.tscn");
	static PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://ui/time_label.tscn");
	static PackedScene packedCenterLabel = ResourceLoader.Load<PackedScene>("res://ui/main_label.tscn");

	// static PackedScene packedGhostDisplay = ResourceLoader.Load<PackedScene>("res://ui/remaining_ghost_display.tscn");
	// static PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");
	static PackedScene packedGhost = ResourceLoader.Load<PackedScene>("res://entities/mobs/ghost.tscn");
	// static PackedScene packedPit = ResourceLoader.Load<PackedScene>("res://environment/endless_pit.tscn");

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

	static PackedScene packedLevel_fall = ResourceLoader.Load<PackedScene>("res://levels/thefall.tscn");
	static PackedScene packedLevel_quake = ResourceLoader.Load<PackedScene>("res://levels/quake.tscn");
	static PackedScene packedLevel_kettle = ResourceLoader.Load<PackedScene>("res://levels/kettle.tscn");

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
		new Level("kettle", new float[]{16,17,18,20,22}, LoadLevel_Kettle),
		new Level("blocks", new float[]{}, LoadLevel_blocks),
		new Level("the fall", new float[]{22,23.5f,25,27,30}, LoadLevel_Fall),
		new Level("quake", new float[]{35,36,38,40,42}, LoadLevel_Quake),
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
		new Level("newground", new float[]{}, LoadLevel_NewGround),
	// 3rd enemy type (???)
	// extra air
	// unasigned
		new Level("break", new float[]{}, LoadLevel_Breakthrough),
		new Level("caves", new float[]{}, LoadLevel_Caves),
		new Level("factory", new float[]{}, LoadLevel_FactoryYard),
		new Level("forest", new float[]{}, LoadLevel_Forest),
		new Level("firering", new float[]{}, LoadLevel_RingOfFire),
		new Level("skullcap", new float[]{}, LoadLevel_SkullCap),
	};

	// public static async void PlayerDisableDelay(Main _main, int milisecdelay)
	// {
	// 	//delay the activation just a little bit, to allow the camera to lock
	// 	await Task.Delay(milisecdelay);
	// 	_main.Player().ProcessMode = Node.ProcessModeEnum.Disabled;
	// }

	static int LevelID(Action<Main> action)
	{
		foreach (var _level in Levels)
			if (_level.Load == action)
				return Array.IndexOf(Levels, _level);
		return 0;
	}

	static void LoadUI(Main _main)
	{
		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);
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

		// _main.player = packedPlayer.Instantiate(_main.World, new Vector2(-23*110,-1*110), 0);
		// packedPlayer.Instantiate(_main.World, new Vector2(-23*110,-1*110), 0);

		// TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		// _main.UI.AddChild(_timeLabel);

		// MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		// _main.UI.AddChild(_center_label);

		LoadUI(_main);

		packedLevel_Tutorial.Instantiate(_main.World);

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(_main.World, _gp, 0) as Ghost;
			// _g.BodyEntered += _main.GhostCollision;
			// _main.GhostCount += 1;
		}
		//like different ghost types will require special code. thats why the region ends below

		_main.StartLevel(LevelID(LoadLevel_Tutorial));

		// RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		// _main.UI.AddChild(_ghostDisplay);

		FileIO.SaveGame _save = FileIO.Load();
		if(_save.LastTimes[0] == 0)
			UILoader.LoadIntroMenu(_main);

		// PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Platforms(Main _main)
	{
		// _main.player = packedPlayer.Instantiate(_main.World, new Vector2(1*110,-1*110), 0);

		// TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		// _main.UI.AddChild(_timeLabel);

		// MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		// _main.UI.AddChild(_center_label);

		LoadUI(_main);

		packedLevel_Platforms.Instantiate(_main.World);

		_main.StartLevel(LevelID(LoadLevel_Platforms));

		// RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		// _main.UI.AddChild(_ghostDisplay);

		// PlayerDisableDelay(_main, 1);
	}

	static void LoadLevel_Tunnels(Main _main)
	{
		LoadUI(_main);
		packedLevel_Tunnels.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Tunnels));
	}

	static void LoadLevel_Cliff(Main _main)
	{
		LoadUI(_main);
		packedLevel_cliff.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Cliff));
	}

	static void LoadLevel_blocks(Main _main)
	{
		LoadUI(_main);
		packedLevel_blocks.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_blocks));
	}

	
	static void LoadLevel_Spikes(Main _main)
	{
		LoadUI(_main);
		packedLevel_spikes.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Spikes));
	}

	static void LoadLevel_MountainSide(Main _main)
	{
		LoadUI(_main);
		packedLevel_MountainSide.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_MountainSide));
	}

	static void LoadLevel_Kaktee(Main _main)
	{
		LoadUI(_main);
		packedLevel_Kaktee.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Kaktee));
	}

	static void LoadLevel_Vertical(Main _main)
	{
		LoadUI(_main);
		packedLevel_Vertical.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Vertical));
	}

	static void LoadLevel_DeepPit(Main _main)
	{
		LoadUI(_main);
		packedLevel_DeepPit.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_DeepPit));
	}
	
	static void LoadLevel_Columns(Main _main)
	{
		LoadUI(_main);
		packedLevel_Columns.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Columns));
	}
	
	static void LoadLevel_Treeson(Main _main)
	{
		LoadUI(_main);
		packedLevel_Treeson.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Treeson));
	}
	
	static void LoadLevel_ShakyGround(Main _main)
	{
		LoadUI(_main);
		packedLevel_ShakyGround.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_ShakyGround));
	}

	static void LoadLevel_Breakthrough(Main _main)
	{
		LoadUI(_main);
		packedLevel_Breakthrough.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Breakthrough));
	}

	static void LoadLevel_Caves(Main _main)
	{
		LoadUI(_main);
		packedLevel_Caves.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Caves));
	}

	static void LoadLevel_FactoryYard(Main _main)
	{
		LoadUI(_main);
		packedLevel_FactoryYard.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_FactoryYard));
	}

	static void LoadLevel_Forest(Main _main)
	{
		LoadUI(_main);
		packedLevel_Forest.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Forest));
	}
	
	static void LoadLevel_NewGround(Main _main)
	{
		LoadUI(_main);
		packedLevel_NewGround.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_NewGround));
	}
	
	static void LoadLevel_RingOfFire(Main _main)
	{
		LoadUI(_main);
		packedLevel_RingOfFire.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_RingOfFire));
	}
	
	static void LoadLevel_SkullCap(Main _main)
	{
		LoadUI(_main);
		packedLevel_SkullCap.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_SkullCap));
	}

	static void LoadLevel_Fall(Main _main)
	{
		LoadUI(_main);
		packedLevel_fall.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Fall));
	}

	static void LoadLevel_Quake(Main _main)
	{
		LoadUI(_main);
		packedLevel_quake.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Quake));
	}

	static void LoadLevel_Kettle(Main _main)
	{
		LoadUI(_main);
		packedLevel_kettle.Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Kettle));
	}
}
