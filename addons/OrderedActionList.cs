using System;
using System.Collections.Generic;

namespace MyCSharpExtensions
{
	public class OrderedActionList<T>
	{
		public class OrderedAction
		{
			public int order;
			public string? id; // fragezeichen erlaubt null
			public Action<T> action;

			public OrderedAction(int order, Action<T> action, string? id=null)
			{
				this.order = order;
				this.id = id;
				this.action = action;
			}
		}
		
		private List<OrderedAction> _list = new List<OrderedAction>();

		public void Add(OrderedAction orderedAction)
		{
			_list.Add(orderedAction);
			_list.Sort((a, b) => a.order.CompareTo(b.order));
		}
		
		public static OrderedActionList<T> operator +(OrderedActionList<T> _list, (int order, string id, Action<T> action) data)
		{
			_list.Add(new OrderedAction(data.order, data.action, data.id));
			return _list;
		}

        public void Remove(string id)
		{
			_list.RemoveAll(entry => entry.id == id);
		}

		public static OrderedActionList<T> operator -(OrderedActionList<T> _list, string id)
		{
			_list.Remove(id);
			return _list;
		}
		
		public void Invoke(T param)
		{
			foreach (var entry in _list)
			{
				entry.action.Invoke(param);
			}
		}
	}
}