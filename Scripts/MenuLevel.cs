using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuLevel : Node
{
	PackedScene packedLevelData = ResourceLoader.Load<PackedScene>("res://Scenes/level_data.tscn");
	public override void _Ready()
	{
		this.TryGetNodeInTree(out Main _main);

		if(this.TryGetChild(out Button _backbutton)) //&& this.TryGetNodeInTree(out Main _main) <- code for migrating code into its own script
		{
			_backbutton.Pressed += () => {
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

			_buttons[0].FocusNeighborTop = _backbutton.GetPath();
			_backbutton.FocusNeighborBottom = _buttons[0].GetPath();

			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				LevelLoader.LoadLevel[0](_main);
			};

			if(_leveldata.TryGetChildren(out List<Label> _labels))
			{
				FileIO.SaveGame _save = FileIO.Load();
				_labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[0]);
				_labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[0]);
			}
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

			if(_leveldata.TryGetChildren(out List<Label> _labels))
			{
				FileIO.SaveGame _save = FileIO.Load();
				_labels[0].Text = TimeCounter.TimeToClock(_save.LastTimes[i]);
				_labels[1].Text = TimeCounter.TimeToClock(_save.BestTimes[i]);
			}
		}
	}
}
