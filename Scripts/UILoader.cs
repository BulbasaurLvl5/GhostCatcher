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
		_main.UI.AddChild(_leveldataContainer);

        

        for (int i = 0; i < LevelLoader.LoadLevel.Length; i++)
        {
            Control _leveldata = packedLevelData.Instantiate<Control>();
            _leveldataContainer.AddChild(_leveldata);

            List<Button> _buttons = new List<Button>();
            if(_leveldata.TryGetChildren<Button>(out _buttons))
            {
                _buttons[0].Text = "Load Level " + i.ToString();
                _buttons[1].Text = "Show Level " + i.ToString();

                Action<Main> _loadlvl = LevelLoader.LoadLevel[i];
                _buttons[0].Pressed += () => {
                    _main.ClearScenes();
                    _loadlvl(_main);
                };
            }

            List<Label> _labels = new List<Label>();
            if(_leveldata.TryGetChildren<Label>(out _labels))
            {
                FileIO.SaveGame _save = FileIO.Load();
                _labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[i]);
                _labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[i]);
            }
        }
    }
}
