using Godot;
using MyGodotExtentions;
using System;

public partial class TimeLabel : Label
{
	TimeCounter _time = new TimeCounter();
	string _min;
	string _sec;

	string _milisec;

	public override void _Ready()
	{
		Main _main;
		if(this.TryGetNodeInTree<Main>(out _main))
		{
			_time = _main.LevelTime;
		}
	}

	public override void _Process(double _delta)
	{
		_min = _time.Minutes.ToString();

		if(Math.Abs(_time.Seconds) >= 10)
			_sec = Math.Abs(_time.Seconds).ToString();
		else
			_sec = 0.ToString() + Math.Abs(_time.Seconds).ToString();

		if(_time.MiliSeconds > 0)
			_milisec = _time.MiliSeconds.ToString().Substring(1,2);
		else if(_time.MiliSeconds == 0)
			_milisec = "00";
		else if (_time.MiliSeconds < 0)
			_milisec = Math.Abs(_time.MiliSeconds).ToString().Substring(1,2);

		if (_time.MiliSeconds >= 0)
			Text = _min + ":" + _sec + "  " + _milisec;
		else if (_time.MiliSeconds < 0)
			Text = "-"+_min + ":" + _sec + "  " + _milisec;

		// Text = TimeCounter.TimeToClock(_time.Time);

		Show();
	}
}
