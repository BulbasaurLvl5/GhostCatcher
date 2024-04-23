using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtensions;
using System.Threading.Tasks;

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

	public class LevelVariables
	{
		public string Name {get;}
		public float[] Times{get;}

		public Action<Main> Loadfunction {get;}

		public LevelVariables(string name, float[] times, Action<Main> loadfunction)
		{
			this.Name = name;
			this.Times = times;
			this.Loadfunction = loadfunction;
		}

		public static int ReturnScore(int level, double time)
		{
			Dictionary<int, int[]> _leveltimedata = new Dictionary<int, int[]>()
			{
				//times for rating from better to worse. i.e. first is max stars
				{0,new int[5]{4,5,6,7,8}},
			};
			
			if(level >= _leveltimedata.Count || time == 0)
				return 0; //default if level is out of range or time non existant

			for (int i = 0; i < _leveltimedata[level].Length; i++)
			{
				if(time < _leveltimedata[level][i])
				{	
					// GD.Print("level: "+level);
					// GD.Print("i: "+i);
					// GD.Print("time: "+time);
					// GD.Print("_leveltimedata: "+_leveltimedata[level][i]);
					// GD.Print("return: "+(_leveltimedata[level].Length-i));
					return _leveltimedata[level].Length-i; //higher rating is better
				}
			}
			return 0;        
		}
	}
	
	public static Action<Main>[] LoadLevel = {
	// collectible ghosts, endless pit
		LoadLevel_Tutorial,
		LoadLevel_Tunnels,
		LoadLevel_Vertical,
		LoadLevel_Treeson,
		LoadLevel_Cliff,
    // moving platforms
		//blocks
    // 1st enemy type (ghosts)
    // spikes
		LoadLevel_Spikes,
		LoadLevel_MountainSide,
		LoadLevel_Kaktee,
		LoadLevel_DeepPit,
		LoadLevel_Columns,
    // 2nd enemy type (skulls)
		LoadLevel_Platforms,
    // falling platforms
		LoadLevel_ShakyGround,
    // 3rd enemy type (???)
    // extra air
	// unasigned
		LoadLevel_Breakthrough,
		LoadLevel_Caves,
		LoadLevel_FactoryYard,
		LoadLevel_Forest,
		LoadLevel_RingOfFire,
		LoadLevel_NewGround,
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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Tutorial));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Platforms));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Tunnels));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Cliff));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Spikes));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_MountainSide));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Kaktee));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Vertical));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_DeepPit));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Columns));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Treeson));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_ShakyGround));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Breakthrough));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Caves));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_FactoryYard));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_Forest));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_NewGround));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_RingOfFire));

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

		_main.StartLevel(Array.IndexOf(LoadLevel, LoadLevel_SkullCap));

		RemainingGhostDisplay _ghostDisplay = packedGhostDisplay.Instantiate<RemainingGhostDisplay>();
		_main.UI.AddChild(_ghostDisplay);

		PlayerDisableDelay(_main, 1);
	}
}