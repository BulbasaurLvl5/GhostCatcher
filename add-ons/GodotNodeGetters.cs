using Godot;
using System.Collections.Generic;
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

		public static bool TryGetNodeInTree<T>(this Node _this, string name, out T node) where T : Node
		{
			var _children = _this.GetRoot().GetChildren().ToList();
			HashSet<Node> _allChildren = new HashSet<Node>();

			while(_children.Count > 0)
			{
				List<Node> _subchildren = new List<Node>();
				for (int i = _children.Count-1; i >= 0; i--)
				{
					_allChildren.Add(_children[i]);
					_subchildren = _subchildren.Concat(_children[i].GetChildren().ToList()).ToList();
					_children.RemoveAt(i);

					//for some reason this shortcut is forbiden here
					// if(_children[i].Name == name)
					// {
					// 	node = (T)_children[i];
					// 	return true;
					// }
				}
				_children=_children.Concat(_subchildren).ToList();
			}

			foreach (var _child in _allChildren)
			{
				// GD.Print(_child.Name);
				if(_child.Name == name)
				{
					node = (T)_child;
					return true;
				}	
			}

			// throw new Exception("Player not found");
			node = null;
			return false;
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
}
