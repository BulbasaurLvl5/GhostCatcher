using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtentions;

public static class LevelLoader
{
	static PackedScene packedPlayer = ResourceLoader.Load<PackedScene>("res://Scenes/player.tscn");
	static PackedScene packedTimeLabel = ResourceLoader.Load<PackedScene>("res://Scenes/time_label.tscn");
	static PackedScene packedCenterLabel = ResourceLoader.Load<PackedScene>("res://Scenes/main_label.tscn");
	static PackedScene packedPlatforms = ResourceLoader.Load<PackedScene>("res://Scenes/platforms.tscn");
	static PackedScene packedGhost = ResourceLoader.Load<PackedScene>("res://Scenes/ghost.tscn");

	public static readonly int levelCount = 1;

	public static void LoadLevel(Main _main, int _level)
	{
		switch(_level)
		{
			case 0:
				LoadLevel_0(_main);
				break;

			default:
				GD.Print("Error: level unknown");
				break;
		}
	}

    static void LoadLevel_0(Main _main)
    {
		_main.SetupLevelLogic();

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
		List<Vector2I> ghostPositions = new List<Vector2I>()
				{
					new Vector2I(6*128, 4*128),
					new Vector2I(11*128, 0),
					new Vector2I(11*128, 5*128),
					new Vector2I(16*128, 4*128),
				};
		//rotating ghost positions
		//pathGhostPositions

		_main.player = packedPlayer.Instantiate(_main.World, new Vector2(4*128,7*128), 0);
		_main.player.ProcessMode = Node.ProcessModeEnum.Disabled;

		TimeLabel _timeLabel = packedTimeLabel.Instantiate<TimeLabel>();
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		_main.UI.AddChild(_timeLabel);

		MainLabel _center_label = packedCenterLabel.Instantiate<MainLabel>();
		_main.UI.AddChild(_center_label);

		TileMap platforms = packedPlatforms.Instantiate(_main.World) as TileMap;

		foreach (var _tp in tilepositions)
		{
			platforms.SetCell(0, _tp, 0, new Vector2I(3,3));
		}
		// platforms.SetCellsTerrainConnect(0, tilepositions, 0, 0); //has to be godot collection. but when done looks like it does not require the foreach loop

		foreach (var _gp in ghostPositions)
		{
			Ghost _g = packedGhost.Instantiate(_main.World, _gp, 0) as Ghost;
			_g.TreeExited += _main.GhostTreeExit;
			_main.GhostCount += 1;
		}
		//like different ghost types will require special code. thats why the region ends below
    }
}
