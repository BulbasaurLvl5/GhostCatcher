using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuLevel : Node
{
	PackedScene packedLevelData = ResourceLoader.Load<PackedScene>("res://Scenes/level_data.tscn");

	[Export]
	Texture2D rating_0 = ResourceLoader.Load<Texture2D>("res://Sprites/CoalDrawn/star_rating_0.png");

	[Export]
	Texture2D rating_1 = ResourceLoader.Load<Texture2D>("res://Sprites/CoalDrawn/star_rating_1.png");

	[Export]
	Texture2D rating_2 = ResourceLoader.Load<Texture2D>("res://Sprites/CoalDrawn/star_rating_2.png");

	[Export]
	Texture2D rating_3 = ResourceLoader.Load<Texture2D>("res://Sprites/CoalDrawn/star_rating_3.png");

	public override void _Ready()
	{
		FileIO.SaveGame _save = FileIO.Load();
		this.TryGetNodeInTree(out Main _main);

		_main.BackgroundMusic.ChangeSongTo(BackgroundMusic.SongNames.phantomx27);

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

		//first button seperator to asign neighbours
		Control _leveldata = packedLevelData.Instantiate<Control>();
		_boxContainer[0].AddChild(_leveldata);

		if(_leveldata.TryGetChildren(out List<Button> _buttons))
		{
			_buttons[0].Text = "Level 0";
			_buttons[1].Text = "Layout";

			_buttons[0].GrabFocus();

			_buttons[0].FocusNeighborTop = _baseButtons[0].GetPath();
			_baseButtons[0].FocusNeighborBottom = _buttons[0].GetPath();

			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				LevelLoader.LoadLevel[0](_main);
			};

			if(_leveldata.TryGetChildren(out List<Label> _labels))
			{
				_labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[0]);
				_labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[0]);
			}

			if(_leveldata.TryGetChild(out TextureRect ratingsprite))
			{
				if(LevelTimesData.ReturnScore(0, _save.BestTimes[0]) == 0)
					ratingsprite.Texture = rating_0;
				else if(LevelTimesData.ReturnScore(0, _save.BestTimes[0]) == 1)
					ratingsprite.Texture = rating_1;
				else if(LevelTimesData.ReturnScore(0, _save.BestTimes[0]) == 2)
					ratingsprite.Texture = rating_2;
				else if(LevelTimesData.ReturnScore(0, _save.BestTimes[0]) == 3)
					ratingsprite.Texture = rating_3;
			}
		}

		if(_save.LastTimes[0] == 0)
			return;

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

			if(_leveldata.TryGetChildren(out List<Label> _labels))
			{
				_labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[i]);
				_labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[i]);
			}

			if(_leveldata.TryGetChild(out TextureRect ratingsprite))
			{
				if(LevelTimesData.ReturnScore(i, _save.BestTimes[i]) == 0)
					ratingsprite.Texture = rating_0;
				else if(LevelTimesData.ReturnScore(i, _save.BestTimes[i]) == 1)
					ratingsprite.Texture = rating_1;
				else if(LevelTimesData.ReturnScore(i, _save.BestTimes[i]) == 2)
					ratingsprite.Texture = rating_2;
				else if(LevelTimesData.ReturnScore(i, _save.BestTimes[i]) == 3)
					ratingsprite.Texture = rating_3;
			}
		}
	}
}
