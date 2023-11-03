using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtentions;

public static class UILoader
{
    static PackedScene packedLevelData = ResourceLoader.Load<PackedScene>("res://Scenes/level_data.tscn");
    static PackedScene packedLevelDataContainer = ResourceLoader.Load<PackedScene>("res://Scenes/level_data_container.tscn");

    public static void LoadLevelSelector(Main _main)
    {
        Control _leveldataContainer = packedLevelDataContainer.Instantiate<Control>();
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		_main.UI.AddChild(_leveldataContainer);

        Control _leveldata_0 = packedLevelData.Instantiate<Control>();
		// _timeLabel.GlobalPosition = new Vector2(1200,50);
		_leveldataContainer.AddChild(_leveldata_0);

        List<Button> _buttons = new List<Button>();
        if(_leveldata_0.TryGetChildren<Button>(out _buttons))
        {
            _buttons[0].Text = "Load Level " + 0.ToString();
            _buttons[1].Text = "Show Level " + 0.ToString();

            _buttons[0].Pressed += () => 
            { 
                _main.ClearScenes();
                LevelLoader.LoadLevel[0](_main);
            };
        }

        List<Label> _labels = new List<Label>();
        if(_leveldata_0.TryGetChildren<Label>(out _labels))
        {
            double _loadTime = FileIO.Load();
            _labels[0].Text = TimeCounter.TimeToClock(_loadTime);
        }
    }
}
