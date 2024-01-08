using System;
using System.Dynamic;
using System.Threading;
using Godot;

namespace MyGodotExtentions
{
	public class TimeCounter
	{
		/*
		timer class thats meant to be used in node classes. It just counts the time to a variable and calls action when done

		stopaction has to be filled with function somewhere, e.g. in ready
					mytimer.Start(2);
					mytimer.stopAction += DoSmth;

		Process has to be manually added to process of node script
			public override void _Process(double delta)
			{
				mytimer.Process(delta);
			}
		*/

		bool _active = false;
		double _time = 0;
		double _stopTime = 0;
		public double Time {get {return _time;}}
		public double StopTime {get {return _stopTime;}}
		public bool IsActive {get {return _active;}}

		public int Minutes{get{ return (int)(_time / 60); }}

		public int Seconds{get{ return (int)_time % 60; }}

		public double MiliSeconds{get{ return _time-(int)_time; }}

		// public bool IsReady {get {return _time > _stopTime;}} //same as !IsActive

		public Action OnStop;
		public TimeCounter()
		{
			_time = 0;
		}

		/*Either add an 	
		public Action<double> OnProcess; 
		in the targt class and call Init in _Ready
			and also in _Process
			if(OnProcess != null)
				OnProcess(delta);
		
		OR Process directly in _Process
		for now this seems preferable, thus Init is commented
		*/

		// public void Init(ref Action<double> OnProcess)
		// {
		//     OnProcess += Process;
		// }

		public void Start(double stopTime)
		{
			if(stopTime >= 0)
			{
				_time = 0;
				_stopTime = stopTime;
			}
			else if (stopTime < 0 )
			{
				_stopTime = 0;
				_time = stopTime;
			}

			_active = true;
		}

		public void Update(double delta)
		{
			if(_active)
			{
				if(_time < _stopTime || _stopTime == 0)
					_time += delta;
				else
					Reset();
			}
		}

		public void Reset()
		{
			_active = false;
			_time = 0;
			_stopTime = 0;
			if(OnStop != null)
				OnStop.Invoke();
		}

		public void Pause()
		{
			_active = false;
			// yield return new Wait... make it pause for certain time. maybe waitforseconds was a unity thing
		}

		public void UnPause()
		{
			_active = true;
		}

		public static string TimeToClock(double time)
		{
			string _min = ((int)(time / 60)).ToString();
			string _sec = Math.Abs((int)time % 60) >= 10 ? Math.Abs((int)time % 60).ToString() : 0.ToString() + Math.Abs((int)time % 60).ToString();
			string _milisec = "00";
			string _returnText = " ";

			if(time-(int)time > 0)
				_milisec = (time-(int)time).ToString().Substring(2,2);
			// else if(time-(int)time == 0)
			// 	_milisec = "00";
			else if (time-(int)time < 0)
				_milisec = Math.Abs(time-(int)time).ToString().Substring(2,2);

			if ((time-(int)time) >= 0)
				_returnText = _min + ":" + _sec + "  " + _milisec;
			else if ((time-(int)time) < 0)
				_returnText = "-"+_min + ":" + _sec + "  " + _milisec;

			return _returnText;
		}
	}
}
