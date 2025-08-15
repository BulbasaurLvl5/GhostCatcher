using Godot;
using System.Collections.Generic;

namespace MyGodotExtensions
{
	public static class VideoSettings
	{
		// public static Dictionary<string, DisplayServer.VSyncMode> _vsyncDict = new Dictionary<string, DisplayServer.VSyncMode>()
		// {
		// 	{ "Disabled", DisplayServer.VSyncMode.Disabled },
		// 	{ "Enabled", DisplayServer.VSyncMode.Enabled },
		// 	{ "Adaptive", DisplayServer.VSyncMode.Adaptive },
		// 	{ "Fast", DisplayServer.VSyncMode.Mailbox },
		// };
		// Dictionary<string, Vector2I> _resolutionDict = new Dictionary<string, Vector2I>()
		// {
		// 	{ "800 x 600 (4:3) SVGA", new Vector2I(1152,648) },
		// 	{ "1024 x 768 (4:3) XGA", new Vector2I(1024,768) },
		// 	{ "1152 x 648", new Vector2I(1152,648) },
		// 	{ "1280 × 720 (16:9) HD", new Vector2I(1288,720) },
		// 	{ "1200 x 800", new Vector2I(1200,800) },
		// 	{ "1280 × 1080 (16:9) Full HD", new Vector2I(1288,720) },
		// 	{ "1440 × 1080 (16:9) Full HD", new Vector2I(1152,648) },
		// 	{ "1920 × 1080 (16:9) Full HD", new Vector2I(1920,1080) }
		// };

		static List<string> _vsyncOptions = new List<string>()
		{
			"Disabled",
			"Enabled",
			"Adaptive",
			"Fast",
		};

		public static List<string> VsyncOptions { get{return _vsyncOptions;} }

		static List<string> _windowOptions = new List<string>()
		{
			"Full-screen",
			"Window",
			// "Full-screen borderless",
			// "Window borderless",
		};

		public static List<string> WindowOptions { get{return _windowOptions;} }

		static List<string> _resolutionOptions = new List<string>()
		{
			// "800 x 600 (4:3) SVGA",
			"1024 x 768 (4:3) XGA",
			"1152 x 648",
			"1280 × 720 (16:9) HD",
			"1200 x 800",
			"1280 × 1080 (16:9) Full HD",
			"1440 × 1080 (16:9) Full HD",
			"1920 × 1080 (16:9) Full HD", 
		};

		public static List<string> ResolutionOptions { get{return _resolutionOptions;} }

		// public enum VsyncOptions {Disabled, Enabled, Adaptive, Fast}
		// public enum WindowOptions {Fullscreen, Window, Fullscreen_borderless, Window_borderless}

		public static void SetVsync(string _vsync){
			switch(_vsync)
			{
				case "Disabled":
					DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Disabled);
					break;

				case "Enabled":
					DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Enabled);
					break;

				case "Adaptive":
					DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Adaptive);
					break;

				case "Fast":
					DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Mailbox);
					break;

				default: 
					GD.Print("ERROR: SetVsync undefined behaviour");
					break;
			}
		}

		public static void SetWindowMode(string _windowmode){
			switch(_windowmode)
			{
				case "Full-screen":
					DisplayServer.WindowSetMode(DisplayServer.WindowMode.ExclusiveFullscreen);
					DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, true);
					break;

				case "Window":
					DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
					DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, false);
					break;

				// case "Full-screen borderless":
				// 	DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
				// 	DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, true);
				// 	break;

				// case "Window borderless":
				// 	DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
				// 	DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless, true);
				// 	break;

				default: 
					GD.Print("ERROR: SetWindowMode undefined behaviour");
					break;
			}
		}

		public static void SetWindowSize(string _windowsize){
			switch(_windowsize)
			{
				// case "800 x 600 (4:3) SVGA":
				// 	DisplayServer.WindowSetSize(new Vector2I(800,600));
				// 	break;

				case "1024 x 768 (4:3) XGA":
					DisplayServer.WindowSetSize(new Vector2I(1024,768));
					break;

				case "1152 x 648":
					DisplayServer.WindowSetSize(new Vector2I(1152,648));
					break;

				case "1280 × 720 (16:9) HD":
					DisplayServer.WindowSetSize(new Vector2I(1280,720));
					break;

				case "1200 x 800":
					DisplayServer.WindowSetSize(new Vector2I(1200,800));
					break;

				case "1280 × 1080 (16:9) Full HD":
					DisplayServer.WindowSetSize(new Vector2I(1280,1080));
					break;

				case "1440 × 1080 (16:9) Full HD":
					DisplayServer.WindowSetSize(new Vector2I(1440,1080));
					break;

				case "1920 × 1080 (16:9) Full HD":
					DisplayServer.WindowSetSize(new Vector2I(1920,1080));
					break;

				default: 
					GD.Print("ERROR: SetWindowSize undefined behaviour");
					break;
			}
		}
	}
	
}
