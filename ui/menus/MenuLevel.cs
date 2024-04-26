using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class MenuLevel : Node
{
	PackedScene packedLevelMenuElement = ResourceLoader.Load<PackedScene>("res://ui/menus/menu_level_element.tscn");

	[Export] Texture2D rating_0 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_0.png");

	[Export] Texture2D rating_1 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_1.png");

	[Export] Texture2D rating_2 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_2.png");

	[Export] Texture2D rating_3 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_3.png");

	[Export] Texture2D rating_4 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_4.png");

	[Export] Texture2D rating_5 = ResourceLoader.Load<Texture2D>("res://resources/sprites/coal/star_rating_5.png");

	public override void _Ready()
	{
		FileIO.SaveGame _save = FileIO.Load();
		this.TryGetNodeInTree(out Main _main);

		_main.BackgroundMusic.CrossfadeTo(BackgroundMusic.SongNames.phantomx27);

		if(this.TryGetChildren(out List<Button> _baseButtons)) //&& this.TryGetNodeInTree(out Main _main) <- code for migrating code into its own script
		{
			//back button
			_baseButtons[0].Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};

			//reset button
			_baseButtons[1].Pressed += () => {
				FileIO.ResetSave();
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);
			};
		}

		this.TryGetNestedChildren(out List<VBoxContainer> _boxContainer);

		Control _levelMenuElement; // = packedLevelMenuElement.Instantiate<Control>();
		// _boxContainer[0].AddChild(_levelMenuElement);

		for (int i = 0; i < LevelLoader.Levels.Length; i++)
		{
			_levelMenuElement = packedLevelMenuElement.Instantiate<Control>();
			_boxContainer[0].AddChild(_levelMenuElement);

			//first button seperator to asign neighbours
			if(i == 0 && _levelMenuElement.TryGetChildren(out List<Button> _buttons))
			{
				_buttons[0].GrabFocus();
				_buttons[0].FocusNeighborTop = _baseButtons[0].GetPath();
				_baseButtons[0].FocusNeighborBottom = _buttons[0].GetPath();
			}

			if(_levelMenuElement.TryGetChildren(out _buttons))
			{
				// _buttons[0].Text = "Level " + i.ToString();
				// _buttons[1].Text = "Layout";
				_buttons[0].Text = LevelLoader.Levels[i].Name;

				Action<Main> _loadlvl = LevelLoader.Levels[i].Load; //needed to store i
				_buttons[0].Pressed += () => {
					_main.ClearScenes();
					_loadlvl(_main);
				};
			}

			if(_levelMenuElement.TryGetChildren(out List<Label> _labels))
			{
				_labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[i]);
				_labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[i]);
			}

			if(_levelMenuElement.TryGetChild(out TextureRect ratingsprite))
			{
				if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 0)
					ratingsprite.Texture = rating_0;
				else if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 1)
					ratingsprite.Texture = rating_1;
				else if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 2)
					ratingsprite.Texture = rating_2;
				else if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 3)
					ratingsprite.Texture = rating_3;
				else if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 4)
					ratingsprite.Texture = rating_4;
				else if(LevelLoader.Levels[i].ReturnScore(_save.BestTimes[i]) == 5)
					ratingsprite.Texture = rating_5;
			}

			// if(_save.LastTimes[i] == 0)
			// 	return;
		}
	}
}
