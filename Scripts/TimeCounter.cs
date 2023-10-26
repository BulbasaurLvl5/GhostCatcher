using System;
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
		double _time = 1;
		double _stopTime = 0;

		public double Time {get {return _time;}}
		public double StopTime {get {return _stopTime;}}
		public bool IsActive {get {return _active;}}

		// public bool IsReady {get {return _time > _stopTime;}} //same as !IsActive

		public Action OnStop;
		public TimeCounter(){}

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
			_time = 0;
			_active = true;
			_stopTime = stopTime;
		}

		public void Process(double delta)
		{
			if(_active)
			{
				if(_time < _stopTime)
					_time += delta;
				else
					Stop();
			}
		}

		public void Stop()
		{
			_active = false;
			if(OnStop != null)
				OnStop.Invoke();
		}

		public void Pause()
		{
			_active = false;
			// yield return new Wait... make it pause for certain time. maybe waitforseconds was a unity thing
		}

		public void Continue()
		{
			_active = true;
		}
	}
}
