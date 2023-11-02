using Godot;
using MyGodotExtentions;
using System;

public partial class TimeLabel : Label
{
	// [Export]
	// Vector2 Pos = new Vector2(700, 50);

	TimeCounter _time = new TimeCounter();
	string _min;
	string _sec;

	string _milisec;

	// public void Init(ref TimeCounter time)
	// {
	// 	_time = time;
	// 	// Vector2 screenSize = GetViewportRect().Size;
	// 	// GlobalPosition = new Vector2(screenSize.X*.8f, 50);
	// 	GlobalPosition = Pos;
	// }

	public override void _Ready()
	{
		// GlobalPosition = Pos;

		Main _main;
		if(this.TryGetNodeInTree<Main>(out _main))
		{
			_time = _main.LevelTime;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// GD.Print(_time.Time);
		// GD.Print(_time.MiliSeconds);
		// GD.Print(_time.Seconds);
		// GD.Print(_time.Minutes);

		_min = _time.Minutes.ToString();

		if(Math.Abs(_time.Seconds) >= 10)
			_sec = Math.Abs(_time.Seconds).ToString();
		else
			_sec = 0.ToString() + Math.Abs(_time.Seconds).ToString();

		if(_time.MiliSeconds > 0)
			_milisec = _time.MiliSeconds.ToString().Substring(2,2);
		else if(_time.MiliSeconds == 0)
			_milisec = "00";
		else if (_time.MiliSeconds < 0)
			_milisec = Math.Abs(_time.MiliSeconds).ToString().Substring(2,2);

		if (_time.MiliSeconds >= 0)
			Text = _min + ":" + _sec + "  " + _milisec;
		else if (_time.MiliSeconds < 0)
			Text = "-"+_min + ":" + _sec + "  " + _milisec;

		Show();
	}
}
