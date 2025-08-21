using Godot;
using System;
using MyGodotExtensions;
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
	GridContainer _controlOptions;
	OptionButton _vsyncButton;
	OptionButton _windowModeButton;

	OptionButton _windowSizeButton;

	HSlider _mainSlider;
	HSlider _effectSlider;
	HSlider _musicSlider;
	HSlider _uiSlider;


	public override void _Ready()
	{
		this.TryGetChildren(out List<Button> _buttons);

		if (this.TryGetChildren(out List<GridContainer> _gridcontainer))
		{
			_videoOptions = _gridcontainer[0];
			_audioOptions = _gridcontainer[1];
			_controlOptions = _gridcontainer[2];
		}

		//videooptions, should be part of own script but who cares
		if (_videoOptions.TryGetChildren(out List<OptionButton> _optionButton))
		{
			_vsyncButton = _optionButton[0];
			_windowModeButton = _optionButton[1];
			_windowSizeButton = _optionButton[2];

			foreach (var _ in VideoSettings.VsyncOptions)
			{
				_vsyncButton.AddItem(_);
			}

			_vsyncButton.ItemSelected += (_index) =>
			{
				// string _key = _vsyncButton.GetItemText((int)_index);
				// DisplayServer.WindowSetVsyncMode(_vsyncDict[_key]);
				// GD.Print("Changed vsync to:", _vsyncDict[_key]);
				VideoSettings.SetVsync(_vsyncButton.GetItemText((int)_index));
			};

			foreach (var _ in VideoSettings.WindowOptions)
			{
				_windowModeButton.AddItem(_);
			}

			_windowModeButton.ItemSelected += (_index) =>
			{
				// GD.Print("_WindowModeButton selected:", _index);
				VideoSettings.SetWindowMode(_windowModeButton.GetItemText((int)_index));
			};

			foreach (var _ in VideoSettings.ResolutionOptions)
			{
				_windowSizeButton.AddItem(_);
			}

			_windowSizeButton.ItemSelected += (_index) =>
			{
				// string _key = _windowSizeButton.GetItemText((int)_index);
				// DisplayServer.WindowSetSize(_resolutionDict[_key]);
				VideoSettings.SetWindowSize(_windowSizeButton.GetItemText((int)_index));
			};
		}

		//audio options, should be part of own script but who cares
		if (_audioOptions.TryGetChildren(out List<HSlider> _audioSliders))
		{
			// for (int i = 0; i < _audioSliders.Count; i++)
			// {
			// 	GD.Print(i + _audioSliders[i].Name);
			// }
			_mainSlider = _audioSliders[0];
			_effectSlider = _audioSliders[1];
			_musicSlider = _audioSliders[2];
			_uiSlider = _audioSliders[3];

			_mainSlider.ValueChanged += (_value) =>
			{
				float _t = Mathf.Clamp((float)_value * .01f, .001f, 1);
				// GD.Print("-----------------------------");
				// GD.Print("main slider value: "+_value);
				// GD.Print("_playerPrefs.AudioSettings: "+_t);
				// GD.Print("Mathf.LinearToDb: "+Mathf.LinearToDb(_t));
				AudioServer.SetBusVolumeDb(0, Mathf.LinearToDb(_t));
			};

			_effectSlider.ValueChanged += (_value) =>
			{
				float _t = Mathf.Clamp((float)_value * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(1, Mathf.LinearToDb(_t));
			};

			_musicSlider.ValueChanged += (_value) =>
			{
				float _t = Mathf.Clamp((float)_value * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(2, Mathf.LinearToDb(_t));
			};

			_uiSlider.ValueChanged += (_value) =>
			{
				float _t = Mathf.Clamp((float)_value * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(3, Mathf.LinearToDb(_t));
			};
		}

		// control options, should be part of own script but who cares
		if (_controlOptions.TryGetChild(out RemapButtonContainer remapButton))
		{
			InputAssistance.IsJoypadConnected();

			GD.Print("Accessing input map: ");
			List<RemapButtonContainer> remapButtonContainers = new List<RemapButtonContainer>();
			foreach (var _ in InputMap.GetActions())
			{
				if (!(_.ToString().StartsWith("ui_") || _.ToString().StartsWith("pause"))) //filter events: ui_ is inbuilt, pause is not supposed to be changed
				{
					GD.Print(_ + " " + InputMap.ActionGetEvents(_));
					RemapButtonContainer _new = remapButton.Duplicate() as RemapButtonContainer;
					_new.Label = _.ToString();
					//_new.SetButtonText(InputMap.ActionGetEvents(_)[0].ToString());
					_new.Button.Text = OS.GetKeycodeString(((InputEventKey)InputMap.ActionGetEvents(_)[0]).Keycode); //if [0] is changed to [1] type changes InputEventJoypadButton
					_controlOptions.AddChild(_new);
					remapButtonContainers.Add(_new);
				}
			}
			
			remapButtonContainers[0].Button.FocusNeighborTop = _buttons[3].GetPath();
			_buttons[3].FocusNeighborBottom = remapButtonContainers[0].Button.GetPath();

			remapButton.QueueFree(); //delete after been copied
		}

		//general buttons + saving loading
		// if (this.TryGetChildren(out List<Button> _buttons))
		// {
			//back
			if (this.TryGetNodeInTree(out Main _main))
			{
				_buttons[0].Pressed += () =>
				{
					_main.ClearScenes();
					UILoader.LoadMainMenu(_main);

					FileIO.SavePlayerPrefs(
						new int[3] { _vsyncButton.GetSelectedId(), _windowModeButton.GetSelectedId(), _windowSizeButton.GetSelectedId() },
						new double[4] { _mainSlider.Value, _effectSlider.Value, _musicSlider.Value, _uiSlider.Value }
						);
				};
			}
			else // for debugging
			{
				GD.Print("ERROR: menu options did not find main. \n Assuming debug mode \n Loading options");
				_buttons[0].Pressed += () => { this.GetTree().Quit(); };

				FileIO.PlayerPrefs _loadPrefs = FileIO.LoadPlayerPrefs();
				VideoSettings.SetVsync(VideoSettings.VsyncOptions[_loadPrefs.VideoSettings[0]]);
				VideoSettings.SetWindowMode(VideoSettings.WindowOptions[_loadPrefs.VideoSettings[1]]);
				VideoSettings.SetWindowSize(VideoSettings.ResolutionOptions[_loadPrefs.VideoSettings[2]]);

				float _t = Mathf.Clamp((float)_loadPrefs.AudioSettings[0] * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(0, Mathf.LinearToDb(_t));
				_t = Mathf.Clamp((float)_loadPrefs.AudioSettings[1] * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(1, Mathf.LinearToDb(_t));
				_t = Mathf.Clamp((float)_loadPrefs.AudioSettings[2] * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(2, Mathf.LinearToDb(_t));
				_t = Mathf.Clamp((float)_loadPrefs.AudioSettings[3] * .01f, .001f, 1);
				AudioServer.SetBusVolumeDb(3, Mathf.LinearToDb(_t));
			}

			//video
			_buttons[1].FocusEntered += () =>
			{
				_videoOptions.Show();
				_audioOptions.Hide();
				_controlOptions.Hide();
			};

			//Audio
			_buttons[2].FocusEntered += () =>
			{
				_videoOptions.Hide();
				_audioOptions.Show();
				_controlOptions.Hide();
			};

			//Controls
			_buttons[3].FocusEntered += () =>
			{
				_videoOptions.Hide();
				_audioOptions.Hide();
				_controlOptions.Show();
			};

			_buttons[1].GrabFocus();

			FileIO.PlayerPrefs _playerPrefs = FileIO.LoadPlayerPrefs();
			_vsyncButton.Select(_playerPrefs.VideoSettings[0]);
			_windowModeButton.Select(_playerPrefs.VideoSettings[1]);
			_windowSizeButton.Select(_playerPrefs.VideoSettings[2]);

			_mainSlider.Value = _playerPrefs.AudioSettings[0];
			_effectSlider.Value = _playerPrefs.AudioSettings[1];
			_musicSlider.Value = _playerPrefs.AudioSettings[2];
			_uiSlider.Value = _playerPrefs.AudioSettings[3];
		// }
	}
	
}
