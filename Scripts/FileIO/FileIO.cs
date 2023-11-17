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
        // thus: //C:/Users/John/AppData/LocalLow/DefaultCompany/ARPG
        // _baseSavePath = ProjectSettings.GlobalizePath("user://");

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

        string _filepath = _baseSavePath + "Save" + ".json";

        if(!File.Exists(_filepath))
        {
            SaveGame _save = new SaveGame{
                LastTimes = new double[LevelLoader.LoadLevel.Length],
                BestTimes = new double[LevelLoader.LoadLevel.Length],
            };

            string _jsonString = JsonSerializer.Serialize(_save);
            File.WriteAllText(_filepath, _jsonString);
        }
    }

    public class SaveGame
    {
        public double[] LastTimes {get; set;}
        public double[] BestTimes {get; set;}
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
}
