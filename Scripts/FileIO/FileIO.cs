using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

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
    }

    public static void Save(double time)
    {
        string _filepath = _baseSavePath + "timeSave" + ".json";
        GD.Print("saved time to: "+_filepath);

        string _jsonString = JsonSerializer.Serialize(time);
        File.WriteAllText(_filepath, _jsonString);
    }

    public static double Load()
    {
        string _filepath = _baseSavePath + "timeSave" + ".json";

        if (File.Exists(_filepath))
        {
            string _jsonString = File.ReadAllText(_filepath);
            return (double)JsonSerializer.Deserialize(_jsonString, typeof(double));
        }
        return 0;
    }
}
