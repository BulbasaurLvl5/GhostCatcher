using Godot;
using MyGodotExtentions;
using System;
using System.ComponentModel;

public partial class MainLabel : Label
{
	public override void _Ready()
	{
		GetReady();

		Main _main;
		if(this.TryGetNodeInTree<Main>(out _main))
		{
			_main.OnLevelStart += Hide;
			_main.OnLevelSuccess += Success;
		}
	}

	void Success()
	{
		Show();
		Text = "Success!";
	}

	void GetReady()
	{
		Show();
		Text = "Get READY!";
	}
}
