using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

// using System.Diagnostics;
// Debug.WriteLine();

public static class FileIO
{
	private static readonly string _baseSavePath;
	// private static readonly string _separator = Path.DirectorySeparatorChar.ToString(); //looks like it is not needed. universal sep is /

	static FileIO() //static constructors are executed automatically
	{
		// By default, the user:// folder is created within Godot's editor data path in the app_userdata/[project_name] folder
		// thus: C:/Users/John/AppData/Roaming/Godot/app_userdata/GhostCatcher/
		// _baseSavePath = ProjectSettings.GlobalizePath("user://");
		string _filepath;

		// from https://docs.godotengine.org/en/stable/classes/class_projectsettings.html#class-projectsettings-method-globalize-path
		if (OS.HasFeature("editor"))
		{
			_baseSavePath = ProjectSettings.GlobalizePath("user://");
		}
		else
		{
			// Returns the absolute directory path where user data is written (user://).
			_baseSavePath = OS.GetUserDataDir();
		}

		// GD.Print("Save data found in: "+_baseSavePath);
		// C:/Users/John/AppData/Roaming/Godot/app_userdata/GhostCatcher/

		_filepath = _baseSavePath + "Save" + ".json";
		if(!File.Exists(_filepath) || LevelLoader.Levels.Length != Load().LastTimes.Length || Load().DeathCount == null)
		{
			GD.Print("Created new save file");
			SaveGame _save = new SaveGame{
				LastTimes = new double[LevelLoader.Levels.Length],
				BestTimes = new double[LevelLoader.Levels.Length],
				DeathCount = new Dictionary<CauseOfDeath, int>()
				{
					{CauseOfDeath.pit, 0},
					{CauseOfDeath.spikes, 0},
					{CauseOfDeath.ghost, 0},
					{CauseOfDeath.skull, 0},
				}
			};

			string _jsonString = JsonSerializer.Serialize(_save);
			File.WriteAllText(_filepath, _jsonString);
		}

		_filepath = _baseSavePath + "PlayerPrefs" + ".json";
		if(!File.Exists(_filepath) || LoadPlayerPrefs().VideoSettings == null || LoadPlayerPrefs().AudioSettings == null)
		{
			GD.Print("Created new player prefs");
			PlayerPrefs _playerPrefs = new PlayerPrefs{
				VideoSettings = new int[3]{1,0,6}, //vsync enabled, fullscreen, 1920x1080
				AudioSettings =  new double[4]{1,1,1,1} //main, effect, music, ui
			};

			string _jsonString = JsonSerializer.Serialize(_playerPrefs);
			File.WriteAllText(_filepath, _jsonString);
		}
	}

	public class SaveGame
	{
		public double[] LastTimes {get; set;}
		public double[] BestTimes {get; set;}

		public Dictionary<CauseOfDeath, int> DeathCount{get; set;}

		public Main.QUOTE_SETS quote_set {get; set;}
	}

	public static void Save(int lvl, double time)
	{
		string _filepath = _baseSavePath + "Save" + ".json";
		GD.Print("saved time to: "+_filepath);

		SaveGame _save = Load();

		_save.LastTimes[lvl] = time;

		if(time < _save.BestTimes[lvl] || _save.BestTimes[lvl] == 0)
			_save.BestTimes[lvl] = time;

		string _jsonString = JsonSerializer.Serialize(_save);
		File.WriteAllText(_filepath, _jsonString);
	}

	public static void Save(CauseOfDeath causeOfDeath)
	{
		string _filepath = _baseSavePath + "Save" + ".json";
		GD.Print("saved causeOfDeath to: "+_filepath);

		SaveGame _save = Load();

		_save.DeathCount[causeOfDeath] += 1;

		string _jsonString = JsonSerializer.Serialize(_save);
		File.WriteAllText(_filepath, _jsonString);
	}

	public static void Save(Main.QUOTE_SETS quote)
	{
		string _filepath = _baseSavePath + "Save" + ".json";
		GD.Print("saved end state to: "+_filepath);

		SaveGame _save = Load();

		_save.quote_set = quote;

		string _jsonString = JsonSerializer.Serialize(_save);
		File.WriteAllText(_filepath, _jsonString);
	}

	public static SaveGame Load()
	{
		string _filepath = _baseSavePath + "Save" + ".json";
		// GD.Print(_filepath);

		if (File.Exists(_filepath))
		{
			string _jsonString = File.ReadAllText(_filepath);
			return (SaveGame)JsonSerializer.Deserialize(_jsonString, typeof(SaveGame));
		}
		return null;
	}

	public static void ResetSave()
	{
		string _filepath = _baseSavePath + "Save" + ".json";
		GD.Print("save file reseted: "+_filepath);

		SaveGame _save = new SaveGame{
				LastTimes = new double[LevelLoader.Levels.Length],
				BestTimes = new double[LevelLoader.Levels.Length],
			};

		string _jsonString = JsonSerializer.Serialize(_save);
		File.WriteAllText(_filepath, _jsonString);
	}

	public class PlayerPrefs
	{
		public int[] VideoSettings {get; set;}
		public double[] AudioSettings {get; set;}
		public Dictionary<string, List<string>> ControlSettings {get; set;}
	}

	public static void SavePlayerPrefs(int[] videoSettings, double[] audiosettings, Dictionary<string, List<string>> controlsettings)
	{
		string _filepath = _baseSavePath + "PlayerPrefs" + ".json";
		GD.Print("saved player prefs to: "+_filepath);

		PlayerPrefs _playerPrefs = LoadPlayerPrefs();

		_playerPrefs.VideoSettings = videoSettings;
		_playerPrefs.AudioSettings = audiosettings;
		_playerPrefs.ControlSettings = controlsettings;

		string _jsonString = JsonSerializer.Serialize(_playerPrefs);
		File.WriteAllText(_filepath, _jsonString);
	}

	public static PlayerPrefs LoadPlayerPrefs()
	{
		string _filepath = _baseSavePath + "PlayerPrefs" + ".json";

		if (File.Exists(_filepath))
		{
			string _jsonString = File.ReadAllText(_filepath);
			return (PlayerPrefs)JsonSerializer.Deserialize(_jsonString, typeof(PlayerPrefs));
		}
		return null;
	}
}
