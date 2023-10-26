using Godot;
using MyGodotExtentions;
using System;

public partial class TimeLabel : Label
{
	[Export]
	Vector2 Pos = new Vector2(1200, 50);

	TimeCounter _time = new TimeCounter();
	string _min;
	string _sec;

	public void Init(ref TimeCounter time)
	{
		_time = time;
		GlobalPosition = Pos;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(_time.Minutes > 0)
			_min = _time.Minutes.ToString();
		else
			_min = 0.ToString();

		if(_time.Seconds >= 10)
			_sec = _time.Seconds.ToString();
		else
			_sec = 0.ToString() + _time.Seconds.ToString();

		Text = _min + ":" + _sec + "  " + _time.MiliSeconds.ToString().Substring(2,2);
		Show();
	}
}
