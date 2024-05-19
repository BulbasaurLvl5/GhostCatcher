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
	// static PackedScene packedLevel_Tutorial = ResourceLoader.Load<PackedScene>("res://levels/tutorial.tscn");
	// static PackedScene packedLevel_Platforms = ResourceLoader.Load<PackedScene>("res://levels/platforms.tscn");
	// static PackedScene packedLevel_Tunnels = ResourceLoader.Load<PackedScene>("res://levels/tunnels.tscn");
	// static PackedScene packedLevel_cliff = ResourceLoader.Load<PackedScene>("res://levels/cliff.tscn");
	// static PackedScene packedLevel_spikes = ResourceLoader.Load<PackedScene>("res://levels/spikes.tscn");
	// static PackedScene packedLevel_MountainSide = ResourceLoader.Load<PackedScene>("res://levels/mountainside.tscn");
	// static PackedScene packedLevel_Kaktee = ResourceLoader.Load<PackedScene>("res://levels/kaktee.tscn");
	// static PackedScene packedLevel_Vertical = ResourceLoader.Load<PackedScene>("res://levels/vertical.tscn");
	// static PackedScene packedLevel_DeepPit = ResourceLoader.Load<PackedScene>("res://levels/deep_pit.tscn");
	// static PackedScene packedLevel_Columns = ResourceLoader.Load<PackedScene>("res://levels/columns.tscn");
	// static PackedScene packedLevel_Treeson = ResourceLoader.Load<PackedScene>("res://levels/treeson.tscn");
	// static PackedScene packedLevel_ShakyGround = ResourceLoader.Load<PackedScene>("res://levels/shaky_ground.tscn");
	// static PackedScene packedLevel_Breakthrough = ResourceLoader.Load<PackedScene>("res://levels/breakthrough.tscn");
	// static PackedScene packedLevel_Caves = ResourceLoader.Load<PackedScene>("res://levels/caves.tscn");
	// static PackedScene packedLevel_FactoryYard = ResourceLoader.Load<PackedScene>("res://levels/factory_yard.tscn");
	// static PackedScene packedLevel_Forest = ResourceLoader.Load<PackedScene>("res://levels/forest.tscn");
	// static PackedScene packedLevel_NewGround = ResourceLoader.Load<PackedScene>("res://levels/new_ground.tscn");
	// static PackedScene packedLevel_RingOfFire = ResourceLoader.Load<PackedScene>("res://levels/ring_of_fire.tscn");
	// static PackedScene packedLevel_SkullCap = ResourceLoader.Load<PackedScene>("res://levels/skull_cap.tscn");
	// static PackedScene packedLevel_blocks = ResourceLoader.Load<PackedScene>("res://levels/blocks.tscn");
	// static PackedScene packedLevel_fall = ResourceLoader.Load<PackedScene>("res://levels/thefall.tscn");
	// static PackedScene packedLevel_quake = ResourceLoader.Load<PackedScene>("res://levels/quake.tscn");
	// static PackedScene packedLevel_kettle = ResourceLoader.Load<PackedScene>("res://levels/kettle.tscn");
	// static PackedScene packedLevel_wallgrab = ResourceLoader.Load<PackedScene>("res://levels/wallgrab.tscn");
	// static PackedScene packedLevel_escape = ResourceLoader.Load<PackedScene>("res://levels/escape.tscn");

	// public static async void PlayerDisableDelay(Main _main, int milisecdelay)
	// {
	// 	//delay the activation just a little bit, to allow the camera to lock
	// 	await Task.Delay(milisecdelay);
	// 	_main.Player().ProcessMode = Node.ProcessModeEnum.Disabled;
	// }

	static PackedScene[] packedScenes= new PackedScene[] { 
		ResourceLoader.Load<PackedScene>("res://levels/tutorial.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/platforms.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/tunnels.tscn"), //2
		ResourceLoader.Load<PackedScene>("res://levels/cliff.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/spikes.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/mountainside.tscn"), //5
		ResourceLoader.Load<PackedScene>("res://levels/kaktee.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/vertical.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/deep_pit.tscn"), //8
		ResourceLoader.Load<PackedScene>("res://levels/columns.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/treeson.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/shaky_ground.tscn"), //11
		ResourceLoader.Load<PackedScene>("res://levels/breakthrough.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/caves.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/factory_yard.tscn"), //14
		ResourceLoader.Load<PackedScene>("res://levels/forest.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/new_ground.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/ring_of_fire.tscn"), //17
		ResourceLoader.Load<PackedScene>("res://levels/skull_cap.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/blocks.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/thefall.tscn"), //20
		ResourceLoader.Load<PackedScene>("res://levels/quake.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/kettle.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/wallgrab.tscn"), //23
		ResourceLoader.Load<PackedScene>("res://levels/escape.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/tutorial_1_stefan.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/tutorial_2_stefan.tscn"), //26
		ResourceLoader.Load<PackedScene>("res://levels/tutorial_3_stefan.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/assembly_line.tscn"),
		ResourceLoader.Load<PackedScene>("res://levels/switch.tscn"), //29
		};

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
	// tutorials
		new Level("jumping", new float[5]{8,10,12,15,25}, LoadLevel_Tutorial_1),
		new Level("grabbing", new float[5]{12,13,15,20,25}, LoadLevel_Tutorial_2),
		new Level("dashing", new float[5]{13,16,19,22,25}, LoadLevel_Tutorial_3),
	// collectible ghosts, endless pit
		new Level("tutorial", new float[5]{5,7,9,12,15}, LoadLevel_Tutorial),
		new Level("tunnels", new float[5]{10,12,15,20,25}, LoadLevel_Tunnels),
		new Level("treeson", new float[5]{32,34,38,42,50}, LoadLevel_Treeson),
		new Level("cliff", new float[5]{16,18,23,27,33}, LoadLevel_Cliff),
		new Level("wall grab", new float[5]{18,20,22,24,26}, LoadLevel_Wallgrab),
	// moving ghosts
	// moving pit
		new Level("vertical", new float[5]{20,21,22,23,24}, LoadLevel_Vertical),
	// moving platforms
		new Level("kettle", new float[5]{16,17,18,20,22}, LoadLevel_Kettle),
		new Level("blocks", new float[5]{28,30,33,38,45}, LoadLevel_blocks),
		new Level("switch", new float[5]{30,33,36,40,50}, LoadLevel_switch),
		new Level("assemble", new float[5]{22,24,27,30,36}, LoadLevel_assembly),
		new Level("the fall", new float[5]{21,23,25,27,30}, LoadLevel_Fall),
		new Level("quake", new float[5]{35,36,38,40,42}, LoadLevel_Quake),
	// 1st enemy type (ghosts)
	// spikes
		new Level("spikes", new float[]{}, LoadLevel_Spikes),
		new Level("mountain", new float[]{}, LoadLevel_MountainSide),
		new Level("cactee", new float[]{}, LoadLevel_Kaktee),
		new Level("deeppit", new float[]{}, LoadLevel_DeepPit),
		new Level("columns", new float[]{}, LoadLevel_Columns),
		new Level("escape", new float[5]{32,33,34,36,38}, LoadLevel_Escape),
	// 2nd enemy type (skulls)
		new Level("skulls", new float[]{}, LoadLevel_Platforms),
	// falling platforms
		new Level("shaky", new float[]{}, LoadLevel_ShakyGround),
		new Level("newground", new float[]{}, LoadLevel_NewGround),
	// extra air
	// unasigned
		new Level("break", new float[]{}, LoadLevel_Breakthrough),
		new Level("caves", new float[]{}, LoadLevel_Caves),
		new Level("factory", new float[]{}, LoadLevel_FactoryYard),
		new Level("forest", new float[]{}, LoadLevel_Forest),
		new Level("firering", new float[]{}, LoadLevel_RingOfFire),
		new Level("skullcap", new float[]{}, LoadLevel_SkullCap),
	};

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

		LoadUI(_main);

		packedScenes[0].Instantiate(_main.World);

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(_main.World, _gp, 0) as Ghost;
		}

		_main.StartLevel(LevelID(LoadLevel_Tutorial));

		FileIO.SaveGame _save = FileIO.Load();
		if(_save.LastTimes[0] == 0)
			UILoader.LoadIntroMenu(_main);
	}

	static void LoadLevel_Platforms(Main _main)
	{
		LoadUI(_main);
		packedScenes[1].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Platforms));
	}

	static void LoadLevel_Tunnels(Main _main)
	{
		LoadUI(_main);
		packedScenes[2].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Tunnels));
	}

	static void LoadLevel_Cliff(Main _main)
	{
		LoadUI(_main);
		packedScenes[3].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Cliff));
	}

	static void LoadLevel_blocks(Main _main)
	{
		LoadUI(_main);
		packedScenes[19].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_blocks));
	}

	
	static void LoadLevel_Spikes(Main _main)
	{
		LoadUI(_main);
		packedScenes[4].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Spikes));
	}

	static void LoadLevel_MountainSide(Main _main)
	{
		LoadUI(_main);
		packedScenes[5].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_MountainSide));
	}

	static void LoadLevel_Kaktee(Main _main)
	{
		LoadUI(_main);
		packedScenes[6].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Kaktee));
	}

	static void LoadLevel_Vertical(Main _main)
	{
		LoadUI(_main);
		packedScenes[7].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Vertical));
	}

	static void LoadLevel_DeepPit(Main _main)
	{
		LoadUI(_main);
		packedScenes[8].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_DeepPit));
	}
	
	static void LoadLevel_Columns(Main _main)
	{
		LoadUI(_main);
		packedScenes[9].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Columns));
	}
	
	static void LoadLevel_Treeson(Main _main)
	{
		LoadUI(_main);
		packedScenes[10].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Treeson));
	}
	
	static void LoadLevel_ShakyGround(Main _main)
	{
		LoadUI(_main);
		packedScenes[11].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_ShakyGround));
	}

	static void LoadLevel_Breakthrough(Main _main)
	{
		LoadUI(_main);
		packedScenes[12].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Breakthrough));
	}

	static void LoadLevel_Caves(Main _main)
	{
		LoadUI(_main);
		packedScenes[13].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Caves));
	}

	static void LoadLevel_FactoryYard(Main _main)
	{
		LoadUI(_main);
		packedScenes[14].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_FactoryYard));
	}

	static void LoadLevel_Forest(Main _main)
	{
		LoadUI(_main);
		packedScenes[15].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Forest));
	}
	
	static void LoadLevel_NewGround(Main _main)
	{
		LoadUI(_main);
		packedScenes[16].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_NewGround));
	}
	
	static void LoadLevel_RingOfFire(Main _main)
	{
		LoadUI(_main);
		packedScenes[17].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_RingOfFire));
	}
	
	static void LoadLevel_SkullCap(Main _main)
	{
		LoadUI(_main);
		packedScenes[18].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_SkullCap));
	}

	static void LoadLevel_Fall(Main _main)
	{
		LoadUI(_main);
		packedScenes[20].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Fall));
	}

	static void LoadLevel_Quake(Main _main)
	{
		LoadUI(_main);
		packedScenes[21].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Quake));
	}

	static void LoadLevel_Kettle(Main _main)
	{
		LoadUI(_main);
		packedScenes[22].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Kettle));
	}

	static void LoadLevel_Wallgrab(Main _main)
	{
		LoadUI(_main);
		packedScenes[23].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Wallgrab));
	}

	static void LoadLevel_Escape(Main _main)
	{
		LoadUI(_main);
		packedScenes[24].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Escape));
	}

	static void LoadLevel_Tutorial_1(Main _main)
	{
		LoadUI(_main);
		packedScenes[25].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Tutorial_1));
	}

	static void LoadLevel_Tutorial_2(Main _main)
	{
		LoadUI(_main);
		packedScenes[26].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Tutorial_2));
	}

	static void LoadLevel_Tutorial_3(Main _main)
	{
		LoadUI(_main);
		packedScenes[27].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_Tutorial_3));
	}

	static void LoadLevel_assembly(Main _main)
	{
		LoadUI(_main);
		packedScenes[28].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_assembly));
	}
	static void LoadLevel_switch(Main _main)
	{
		LoadUI(_main);
		packedScenes[29].Instantiate(_main.World);
		_main.StartLevel(LevelID(LoadLevel_switch));
	}
}
