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

	static PackedScene packedOptionsMenu = ResourceLoader.Load<PackedScene>("res://Scenes/menu_options.tscn");

	static PackedScene packedPauseMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menu_Pause.tscn");

	public static void LoadLevelSelector(Main _main)
	{
		Node _leveldataContainer = packedLevelDataContainer.Instantiate<Node>();
		_main.UI.AddChild(_leveldataContainer);

		if(_leveldataContainer.TryGetChild(out Button _backbutton)) //&& this.TryGetNodeInTree(out Main _main) <- code for migrating code into its own script
		{
			_backbutton.Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};
		}

		_leveldataContainer.TryGetNestedChildren(out List<VBoxContainer> _boxContainer);

		//first button seperator to asign neighbours
		Control _leveldata = packedLevelData.Instantiate<Control>();
		_boxContainer[0].AddChild(_leveldata);

		if(_leveldata.TryGetChildren(out List<Button> _buttons))
		{
			_buttons[0].Text = "Level 0";
			_buttons[1].Text = "Layout";

			_buttons[0].GrabFocus();

			_buttons[0].FocusNeighborTop = _backbutton.GetPath();
			_backbutton.FocusNeighborBottom = _buttons[0].GetPath();

			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				LevelLoader.LoadLevel[0](_main);
			};
		}

		for (int i = 1; i < LevelLoader.LoadLevel.Length; i++)
		{
			_leveldata = packedLevelData.Instantiate<Control>();
			_boxContainer[0].AddChild(_leveldata);

			if(_leveldata.TryGetChildren(out _buttons))
			{
				_buttons[0].Text = "Level " + i.ToString();
				// _buttons[1].Text = "Show " + i.ToString();
				_buttons[1].Text = "Layout";

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
				_main.ClearScenes();
				LoadOptionsMenu(_main);
			};

			_buttons[2].Pressed += () => {
				_main.GetTree().Root.PropagateNotification((int)Node.NotificationWMCloseRequest);
				_main.GetTree().Quit();
			};

			_buttons[0].GrabFocus();
		}
	}

	public static Node LoadOptionsMenu(Main _main)
	{
		//returns _optionsMenu bc main menu has to load it quickly once when started to load input settings
		Node _optionsMenu = packedOptionsMenu.Instantiate<Node>();
			_main.UI.AddChild(_optionsMenu);
		return _optionsMenu;
	}

	public static void LoadRetryMenu(Main _main)
	{
		Node _retryMenu = packedRetryMenu.Instantiate<Node>();
			_main.UI.AddChild(_retryMenu);
	}

	public static void LoadPauseMenu(Main _main)
	{
		Node _pauseMenu = packedPauseMenu.Instantiate<Node>();
			_main.UI.AddChild(_pauseMenu);
	}
}
