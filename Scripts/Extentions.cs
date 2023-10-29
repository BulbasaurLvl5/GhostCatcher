using Godot;
using System;

// using System;
// using System.Linq;

using System.Collections.Generic;
using System.ComponentModel;

namespace MyGodotExtentions
{
  public static class NodeGetters
  {
		public static void AsignTo<T>(this Node _this, ref T _var) where T : Node
		{
			_var = (T)_this;
		}

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

		public static bool TryGetNodeInTree<T>(this Node _this, out T node) where T : Node
		{
			if(_this.GetTree().Root.TryGetChild<T>(out T _t))
			{
				node = _t;
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
			nodes = new List<T>();

			foreach (var _child in _this.GetTree().Root.GetChildren())
			{
				if(_child is T)
					nodes.Add((T)_child);
			}

			if(nodes.Count > 0)
				return true;
			else
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
}
