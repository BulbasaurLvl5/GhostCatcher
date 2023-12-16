using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

public partial class MenuOptions : Node
{
	[Export] Control _VideoOptions;
	[Export] OptionButton _WindowModeButton;

    List<string> _windowOptions = new List<string>()
    {
        "Full-screen",
        "Window",
        "Full-screen borderless",
        "Window borderless",
    };

    Dictionary<string, Vector2I> _resolutionDict = new Dictionary<string, Vector2I>()
    {
        { "1152 x 648", new Vector2I(1152,648) },
        { "1288 x 720", new Vector2I(1288,720) },
        { "1920 x 1080", new Vector2I(1920,1080) }
    };

	public override void _Ready()
	{	
		if(this.TryGetChildren(out List<Button> _buttons) && this.TryGetNodeInTree(out Main _main))
		{
			//back
			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);                
			};

			//video
			_buttons[1].FocusEntered += () => {
				_VideoOptions.Show();
			};

			//Audio
			_buttons[2].FocusEntered += () => {
				_VideoOptions.Hide();
			};

			//Controls
			_buttons[3].FocusEntered += () => {
				_VideoOptions.Hide();
			};

            foreach (var _ in _windowOptions)
            {
                _WindowModeButton.AddItem(_);
            }

			_WindowModeButton.ItemSelected += (_index) =>{
				// GD.Print("_WindowModeButton selected:", _index);
				switch(_index)
				{
					case 0:
						DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
						DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, false);
						break;

					case 1:
						DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
						DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, false);
						break;

					case 2:
						DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
						DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, true);
						break;

					case 3:
						DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
						DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, true);
						break;

					default: 
						GD.Print("ERROR: _WindowModeButton undefined behaviour");
						break;
				}
			};

			_buttons[1].GrabFocus();
		}
	}
}
