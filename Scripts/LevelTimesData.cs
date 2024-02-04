using Godot;
using System;
using System.Collections.Generic;

public static class LevelTimesData
{
	public static int ReturnScore(int level, double time)
	{
		Dictionary<int, int[]> _leveltimedata = new Dictionary<int, int[]>()
		{
			//times for rating from better to worse. i.e. first is max stars
			{0,new int[5]{4,5,6,7,8}},
		};
		
		if(level >= _leveltimedata.Count || time == 0)
			return 0; //default if level is out of range or time non existant

		for (int i = 0; i < _leveltimedata[level].Length; i++)
		{
			if(time < _leveltimedata[level][i])
			{	
				// GD.Print("level: "+level);
				// GD.Print("i: "+i);
				// GD.Print("time: "+time);
				// GD.Print("_leveltimedata: "+_leveltimedata[level][i]);
				// GD.Print("return: "+(_leveltimedata[level].Length-i));
				return _leveltimedata[level].Length-i; //higher rating is better
			}
		}
		return 0;        
	}
}
