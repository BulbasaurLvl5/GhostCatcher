using Godot;
using System;
using System.Collections.Generic;
using MyGodotExtensions;
using System.Threading.Tasks;

public static class UILoader
{
	static PackedScene packed_menu_level = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_level.tscn");

	static PackedScene packedRetryMenu = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_retry.tscn");
	static PackedScene packedMainMenu = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_main.tscn");

	static PackedScene packedOptionsMenu = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_options.tscn");

	static PackedScene packedPauseMenu = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_pause.tscn");

	static PackedScene packedIntroMenu = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_intro.tscn");

	public static void LoadLevelSelector(Main _main)
	{
		Node _menu_level = packed_menu_level.Instantiate<Node>();
		_main.UI.AddChild(_menu_level);
	}

	public static void LoadMainMenu(Main _main)
	{
		Node _mainMenu = packedMainMenu.Instantiate<Node>();
			_main.UI.AddChild(_mainMenu);

		_main.BackgroundMusic.CrossfadeTo(BackgroundMusic.SongNames.phantomx27);

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

	public static void LoadOptionsMenu(Main _main)
	{
		Node _optionsMenu = packedOptionsMenu.Instantiate<Node>();
			_main.UI.AddChild(_optionsMenu);
		//return _optionsMenu; //returns _optionsMenu bc main menu has to load it quickly once when started to load input settings
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

	public static void LoadIntroMenu(Main _main)
	{
		Node _introMenu = packedIntroMenu.Instantiate<Node>();
		_main.UI.AddChild(_introMenu);
	}
}
