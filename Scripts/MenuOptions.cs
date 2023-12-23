using Godot;
using System;
using MyGodotExtentions;
using System.Collections.Generic;

/* info about screen sizes
	https://www.wearethefirehouse.com/aspect-ratio-cheat-sheet
	https://en.wikipedia.org/wiki/List_of_common_resolutions
	https://store.steampowered.com/hwsurvey/
	https://en.wikipedia.org/wiki/Graphics_display_resolution
	https://www.urtech.ca/2019/04/solved-complete-list-of-screen-resolution-names-sizes-and-aspect-ratios/
	https://gs.statcounter.com/screen-resolution-stats/desktop/worldwide

	800 x 600 (4:3) SVGA
	1024 x 768 (4:3) XGA
	1280 × 720 (16:9) HD
	1280 × 1080 (16:9) Full HD
	1440 × 1080 (16:9) Full HD
	1920 × 1080 (16:9) Full HD

	-to high for sprites
	2560 x 1440 (16:9) QHD
	3840 x 1080 (32:9) DHD
	3840 × 2160 (16:9) UHD
	4480 x 1440
	5120 x 1440 (32:9) DQHD
	5760 x 2160
*/

/* info about vsync
	https://forum.godotengine.org/t/how-do-i-enable-vsync-in-gdscript/1236/3

	VSYNC_DISABLED: turns vsync off

	VSYNC_ENABLED: turns vsync on limiting your fps to your monitors refresh rate

	VSYNC_ADAPTIVE: fps is limited by the monitor as if vsync is enabled, however, when frames are below the monitors refresh rate it behaves as if vsync has been disabled.

	VSYNC_MAILBOX: Displays the most recent image with the frame rate being unlimited. The image is rendered as fast as possible which could reduce input lag but no guarantees are made. This mode is also known as “Fast” Vsync and works best when your frame rate is at least twice that of the monitor refresh rate
*/

/* possible solution for brightness and contrast
	https://forum.godotengine.org/t/how-to-use-worldenvironment-node-in-2d/27288
*/

public partial class MenuOptions : Node
{
	GridContainer _videoOptions;
	GridContainer _audioOptions;
	OptionButton _vsyncButton;
	OptionButton _windowModeButton;

	OptionButton _windowSizeButton;

	public override void _Ready()
	{
		if(this.TryGetAllChildren(out List<GridContainer> _gridcontainer))
		{
			_videoOptions = _gridcontainer[1];
			_audioOptions = _gridcontainer[0];
		}

		if(this.TryGetAllChildren(out List<OptionButton> _optionButton))
		{
			//i dont know why. ordner ingame is different
			_vsyncButton = _optionButton[2];
			_windowModeButton = _optionButton[1];
			_windowSizeButton = _optionButton[0];
		}

		if(this.TryGetChildren(out List<Button> _buttons) && this.TryGetNodeInTree(out Main _main))
		{
			//back
			_buttons[0].Pressed += () => {
				_main.ClearScenes();
				UILoader.LoadMainMenu(_main);

				FileIO.SavePlayerPrefs(
					new int[3]{_vsyncButton.GetSelectedId(), _windowModeButton.GetSelectedId(),_windowSizeButton.GetSelectedId()}
					);
			};

			//video
			_buttons[1].FocusEntered += () => {
				_videoOptions.Show();
				_audioOptions.Hide();
			};

			//Audio
			_buttons[2].FocusEntered += () => {
				_videoOptions.Hide();
				_audioOptions.Show();
			};

			//Controls
			_buttons[3].FocusEntered += () => {
				_videoOptions.Hide();
				_audioOptions.Hide();
			};

			foreach (var _ in VideoSettings.VsyncOptions)
			{
				_vsyncButton.AddItem(_);
			}

			_vsyncButton.ItemSelected += (_index) => {
				// string _key = _vsyncButton.GetItemText((int)_index);
				// DisplayServer.WindowSetVsyncMode(_vsyncDict[_key]);
				// GD.Print("Changed vsync to:", _vsyncDict[_key]);
				VideoSettings.SetVsync(_vsyncButton.GetItemText((int)_index));
			};

			foreach (var _ in VideoSettings.WindowOptions)
			{
				_windowModeButton.AddItem(_);
			}

			_windowModeButton.ItemSelected += (_index) =>{
				// GD.Print("_WindowModeButton selected:", _index);
				VideoSettings.SetWindowMode(_windowModeButton.GetItemText((int)_index));
			};

			foreach (var _ in VideoSettings.ResolutionOptions)
			{
				_windowSizeButton.AddItem(_);
			}

			_windowSizeButton.ItemSelected += (_index) => {
				// string _key = _windowSizeButton.GetItemText((int)_index);
				// DisplayServer.WindowSetSize(_resolutionDict[_key]);
				VideoSettings.SetWindowSize(_windowSizeButton.GetItemText((int)_index));
			};

			_buttons[1].GrabFocus();

			FileIO.PlayerPrefs _playerPrefs = FileIO.LoadPlayerPrefs();
			_vsyncButton.Select(_playerPrefs.VideoSettings[0]);
			_windowModeButton.Select(_playerPrefs.VideoSettings[1]);
			_windowSizeButton.Select(_playerPrefs.VideoSettings[2]);
		}
	}
}
