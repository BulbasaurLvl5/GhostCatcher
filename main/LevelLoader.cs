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

	public class Level
	{
		public string Name {get;}
		public float[] StarTimes{get;}

		public Action<Main> Load {get;}

		public PackedScene PackedScene {get;}

		public Level(string name, float[] starTimes, PackedScene packedScene, Action<Main> loadfunction)
		{
			this.Name = name;
			this.StarTimes = starTimes;
			this.PackedScene = packedScene;
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
		new Level("jumping", new float[5]{8,10,12,15,25}, ResourceLoader.Load<PackedScene>("res://levels/tutorial_1_stefan.tscn"), LoadLevel_Tutorial_1),
		new Level("grabbing", new float[5]{12,13,15,20,25}, ResourceLoader.Load<PackedScene>("res://levels/tutorial_2_stefan.tscn"), LoadLevel_Tutorial_2),
		new Level("dashing", new float[5]{13,16,19,22,25}, ResourceLoader.Load<PackedScene>("res://levels/tutorial_3_stefan.tscn"), LoadLevel_Tutorial_3),
	// collectible ghosts, endless pit
		new Level("tutorial", new float[5]{5,7,9,12,15}, ResourceLoader.Load<PackedScene>("res://levels/tutorial.tscn"), LoadLevel_Tutorial),
		new Level("tunnels", new float[5]{10,12,15,20,25}, ResourceLoader.Load<PackedScene>("res://levels/tunnels.tscn"), LoadLevel_Tunnels),
		new Level("treeson", new float[5]{32,34,38,42,50}, ResourceLoader.Load<PackedScene>("res://levels/treeson.tscn"), LoadLevel_Treeson),
		new Level("cliff", new float[5]{16,18,23,27,33}, ResourceLoader.Load<PackedScene>("res://levels/cliff.tscn"), LoadLevel_Cliff),
		new Level("wall grab", new float[5]{18,20,22,24,26}, ResourceLoader.Load<PackedScene>("res://levels/wallgrab.tscn"), LoadLevel_Wallgrab),
	// moving ghosts
	// moving pit
		new Level("vertical", new float[5]{20,21,22,23,24}, ResourceLoader.Load<PackedScene>("res://levels/vertical.tscn"), LoadLevel_Vertical),
	// moving platforms
		new Level("kettle", new float[5]{16,17,18,20,22}, ResourceLoader.Load<PackedScene>("res://levels/kettle.tscn"), LoadLevel_Kettle),
		new Level("blocks", new float[5]{28,30,33,38,45}, ResourceLoader.Load<PackedScene>("res://levels/blocks.tscn"), LoadLevel_blocks),
		new Level("switch", new float[5]{30,33,36,40,50}, ResourceLoader.Load<PackedScene>("res://levels/switch.tscn"), LoadLevel_switch),
		new Level("assemble", new float[5]{22,24,27,30,36}, ResourceLoader.Load<PackedScene>("res://levels/assembly_line.tscn"), LoadLevel_assembly),
		new Level("the fall", new float[5]{21,23,25,27,30}, ResourceLoader.Load<PackedScene>("res://levels/thefall.tscn"), LoadLevel_Fall),
		new Level("quake", new float[5]{35,36,38,40,42}, ResourceLoader.Load<PackedScene>("res://levels/quake.tscn"), LoadLevel_Quake),
	// 1st enemy type (ghosts)
	// spikes
		new Level("spikes", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/spikes.tscn"), LoadLevel_Spikes),
		new Level("mountain", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/mountainside.tscn"), LoadLevel_MountainSide),
		new Level("cactee", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/kaktee.tscn"), LoadLevel_Kaktee),
		new Level("deeppit", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/deep_pit.tscn"), LoadLevel_DeepPit),
		new Level("columns", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/columns.tscn"), LoadLevel_Columns),
		new Level("escape", new float[5]{32,33,34,36,38}, ResourceLoader.Load<PackedScene>("res://levels/escape.tscn"), LoadLevel_Escape),
	// 2nd enemy type (skulls)
		new Level("skulls", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/platforms.tscn"), LoadLevel_Platforms),
	// falling platforms
		new Level("shaky", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/shaky_ground.tscn"), LoadLevel_ShakyGround),
		new Level("newground", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/new_ground.tscn"), LoadLevel_NewGround),
	// extra air
	// unasigned
		new Level("break", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/breakthrough.tscn"), LoadLevel_Breakthrough),
		new Level("caves", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/caves.tscn"), LoadLevel_Caves),
		new Level("factory", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/factory_yard.tscn"), LoadLevel_FactoryYard),
		new Level("forest", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/forest.tscn"), LoadLevel_Forest),
		new Level("firering", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/ring_of_fire.tscn"), LoadLevel_RingOfFire),
		new Level("skullcap", new float[]{}, ResourceLoader.Load<PackedScene>("res://levels/skull_cap.tscn"), LoadLevel_SkullCap),
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
		int id = LevelID(LoadLevel_Tutorial);

		List<Vector2I> ghostPositions = new List<Vector2I>(){
			new Vector2I(-5*110, -3*110),
			new Vector2I(0*110, -7*110),
			new Vector2I(0*110, -2*110),
			new Vector2I(5*110, -3*110),
		};

		LoadUI(_main);

		Levels[id].PackedScene.Instantiate(_main.World);

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(_main.World, _gp, 0) as Ghost;
		}

		_main.StartLevel(id);

		FileIO.SaveGame _save = FileIO.Load();
		if(_save.LastTimes[0] == 0)
			UILoader.LoadIntroMenu(_main);
	}

	static void LoadLevel_Platforms(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Platforms);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Tunnels(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Tunnels);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Cliff(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Cliff);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_blocks(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_blocks);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	
	static void LoadLevel_Spikes(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Spikes);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_MountainSide(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_MountainSide);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Kaktee(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Kaktee);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Vertical(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Vertical);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_DeepPit(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_DeepPit);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_Columns(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Columns);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_Treeson(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Treeson);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_ShakyGround(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_ShakyGround);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Breakthrough(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Breakthrough);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Caves(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Caves);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_FactoryYard(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_FactoryYard);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Forest(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Forest);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_NewGround(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_NewGround);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_RingOfFire(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_RingOfFire);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
	
	static void LoadLevel_SkullCap(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_SkullCap);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Fall(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Fall);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Quake(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Quake);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Kettle(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Kettle);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Wallgrab(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Wallgrab);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Escape(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Escape);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Tutorial_1(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Tutorial_1);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Tutorial_2(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Tutorial_2);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_Tutorial_3(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_Tutorial_3);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_assembly(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_assembly);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}

	static void LoadLevel_switch(Main _main)
	{
		LoadUI(_main);
		int id = LevelID(LoadLevel_switch);
		Levels[id].PackedScene.Instantiate(_main.World);
		_main.StartLevel(id);
	}
}
