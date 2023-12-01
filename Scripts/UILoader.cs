using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtentions;
using System.Threading.Tasks;

public static class UILoader
{
    static PackedScene packedLevelData = ResourceLoader.Load<PackedScene>("res://Scenes/level_data.tscn");
    static PackedScene packedLevelDataContainer = ResourceLoader.Load<PackedScene>("res://Scenes/level_data_container.tscn");

    static PackedScene packedRetryMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menu_Retry.tscn");
    static PackedScene packedMainMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menu_Main.tscn");

    public static void LoadLevelSelector(Main _main)
    {
        Node _leveldataContainer = packedLevelDataContainer.Instantiate<Node>();
		_main.UI.AddChild(_leveldataContainer);

        _leveldataContainer.TryGetAllChildren(out List<VBoxContainer> _boxContainer);

        for (int i = 0; i < LevelLoader.LoadLevel.Length; i++)
        {
            Control _leveldata = packedLevelData.Instantiate<Control>();
            _boxContainer[0].AddChild(_leveldata);

            if(_leveldata.TryGetChildren<Button>(out List<Button> _buttons))
            {
                _buttons[0].Text = "Level " + i.ToString();
                // _buttons[1].Text = "Show " + i.ToString();
                _buttons[1].Text = "Layout";

                if(i == 0)
                    _buttons[0].GrabFocus();

                Action<Main> _loadlvl = LevelLoader.LoadLevel[i]; //needed to store i
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

    public static void LoadRetryMenu(Main _main)
    {
        Node _retryMenu = packedRetryMenu.Instantiate<Node>();
            _main.UI.AddChild(_retryMenu);

        if(_retryMenu.TryGetChildren(out List<Button> _buttons))
        {
            _buttons[0].Pressed += () => {
                _main.ClearScenes();
                // await Task.Delay(1); //waiting 1ms so the QueueFree in ClearScenes can do its job
                LevelLoader.LoadLevel[_main.Level].Invoke(_main);
            };

            _buttons[1].Pressed += () => {
                _main.ClearScenes();
                LoadLevelSelector(_main);
            };

            _buttons[2].Pressed += () => {
                _main.ClearScenes();
                LoadMainMenu(_main);
            };

            _buttons[3].Pressed += () => {
                _main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
                _main.GetTree().Quit();
            };

            _buttons[0].GrabFocus();

            if(_retryMenu.TryGetChild(out Label _deathsOpinion))
            {
                if(_main.Failed)
                    _deathsOpinion.Text = "I am not mad, \ni am disappointed";
                else
                    _deathsOpinion.Text = "Its been about time";
            }
        }
    }

    public static void LoadMainMenu(Main _main)
    {
        Node _mainMenu = packedMainMenu.Instantiate<Node>();
            _main.UI.AddChild(_mainMenu);

        if(_mainMenu.TryGetChildren(out List<Button> _buttons))
        {
            _buttons[0].Pressed += () => {
                _main.ClearScenes();
                LoadLevelSelector(_main);                
            };

            _buttons[1].Pressed += () => {

            };

            _buttons[2].Pressed += () => {
                _main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
                _main.GetTree().Quit();
            };

            _buttons[0].GrabFocus();
        }
    }
}
