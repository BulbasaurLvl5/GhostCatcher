using Godot;
using System;

// using System;
// using System.Linq;

using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;

namespace MyGodotExtensions
{
  public static class NodeGetters
  {
		public static bool TryGetNode<T>(this Node _this, string path, out T node) where T : Node
		{
			node = _this.GetNode<T>(path);
			
			if(node != null)
				return true;
			else
				return false;
		}

		public static Node GetRoot(this Node _this)
		{
			return _this.GetTree().Root;
		}

		public static bool TryGetChild<T>(this Node _this, out T node) where T : Node
		{
			var _children = _this.GetChildren();
			//this line can be used instead of the foreach loop. requires linq
			// T _child = _this.GetChildren().OfType<T>().FirstOrDefault();
			foreach (var _child in _children)
			{
				if(_child is T)
				{
					node = (T)_child;
					return true;
				}
			}
			node = null;
			return false;
		}

		public static T TryGetChild<T>(this Node _this) where T : Node
		{
			var _children = _this.GetChildren();
			//this line can be used instead of the foreach loop. requires linq
			// T _child = _this.GetChildren().OfType<T>().FirstOrDefault();
			foreach (var _child in _children)
			{
				if(_child is T)
				{
					return (T)_child;
				}
			}
			return null;
		}

		public static bool TryGetChildren<T>(this Node _this, out List<T> nodes) where T : Node
		{
			nodes = new List<T>();
			var _children = _this.GetChildren();

			foreach (var _child in _children)
			{
				if(_child is T)
				{
					nodes.Add((T)_child);
				}
			}

			if(nodes.Count > 0)
				return true;
			else
				return false;
		}

		public static bool TryGetNestedChildren<T>(this Node _this, out List<T> nodes) where T : Node
		{
			var _children = _this.GetChildren().ToList();
			HashSet<Node> _allChildren = new HashSet<Node>();

			while(_children.Count > 0)
			{
				List<Node> _subchildren = new List<Node>();
				for (int i = _children.Count-1; i >= 0; i--)
				{
					_allChildren.Add(_children[i]);
					_subchildren = _subchildren.Concat(_children[i].GetChildren().ToList()).ToList();
					_children.RemoveAt(i);
				}
				_children=_children.Concat(_subchildren).ToList();
			}

			nodes = new List<T>();
			foreach (var _child in _allChildren)
			{
				if(_child is T)
				{
					nodes.Add((T)_child);
				}
			}

			if(nodes.Count > 0)
				return true;
			else
				return false;
		}

		public static bool TryGetNodeInTree<T>(this Node _this, out T node) where T : Node
		{
			if(_this.GetTree().Root.TryGetNestedChildren(out List<T> _t))
			{
				node = _t[0];
				return true;
			}
			else
			{
				node = null;
				return false;
			}
		}

		public static bool TryGetNodesInTree<T>(this Node _this, out List<T> nodes) where T : Node
		{
			var _children = _this.GetTree().Root.GetChildren().ToList();
			HashSet<Node> _allChildren = new HashSet<Node>();

			while(_children.Count > 0)
			{
				List<Node> _subchildren = new List<Node>();
				for (int i = _children.Count-1; i >= 0; i--)
				{
					_allChildren.Add(_children[i]);
					_subchildren = _subchildren.Concat(_children[i].GetChildren().ToList()).ToList();
					_children.RemoveAt(i);
				}
				_children=_children.Concat(_subchildren).ToList();
			}

			nodes = new List<T>();
			foreach (var _child in _allChildren)
			{
				if(_child is T)
				{
					nodes.Add((T)_child);
				}
			}

			if(nodes.Count > 0)
				return true;
			else
				return false;
		}

		public static bool TryGetParent<T>(this Node _this, out T parent) where T : Node
		{
			var _parent = _this.GetParent();

			if(_parent is T)
			{
				parent = _parent as T;
				return true;
			}
			parent = null;
			return false;
		}
	}

	public static class Instantiators
  	{
		//do this for any combination of parent, pos+rot
		//also for generic method

		//implement a switch here, that checks for Area2D,StaticBody2D,RegidBody2D and CharacterBody2D and does the respective casts
		//dynamic laser = laserScene.Instantiate(); this can be used for typing at runtime. the first creation did cuase a lag
		//var laser = laserScene.Instantiate<Node2D>(); this offers all functions of Node2D, i.e. transform

		//maybe an overload for each possible cast?
		//then the version called would depent on the parameters given
		public static Node2D Instantiate(this PackedScene _this, Node _parent, Vector2 _pos, float _rot)
		{
			Node2D obj = _this.Instantiate<Node2D>();
			_parent.AddChild(obj);

			//unsure which one of these two is the correct one...
			// obj.Position = _pos;
			obj.GlobalPosition = _pos;

			//godot uses rad and converts to degree
			//thus e.g. 1 -> 1*360/2pi = 57.29 degree
			//below _rot is given between [0,1], where 1 is one full rotation
			// obj.Rotation = (float)(_rot*2*Math.PI);

			//below _rot is expected to be given in PI, e.g. as a result of Vector2.AngleTo()
			/*full example:
				Vector2 aim = (GetGlobalMousePosition() - GlobalPosition).Normalized();
				float angle = Vector2.Right.AngleTo(aim);
				laserScene.Instantiate(this.GetRoot(), Position+aim*50, angle);
			*/
			//note: Vector2.Right is expected to be default orietation of the sprite
			// if sprite is right oriented float angle = aim.Angle(); does wok too, else adding some degree can work too
			obj.Rotation = _rot;
			
			return obj;
		}

		public static Node2D Instantiate(this PackedScene _this, Node _parent)
		{
			Node2D obj = _this.Instantiate<Node2D>();
			_parent.AddChild(obj);
			return obj;
		}
	}

	public static class TileMapFunctions
	{
		public static void SetRandomCell(this TileMap _this, int layer, Vector2I coords, int sourceID)
		{
			int tilesCount = _this.TileSet.GetSource(0).GetTilesCount() - 1;
			// GD.Print(tilesCount);
			Vector2I tileID = _this.TileSet.GetSource(0).GetTileId(GD.RandRange(0, tilesCount));
			// GD.Print(tileID);

			_this.SetCell(layer, coords, sourceID, tileID);
		}
	}

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
