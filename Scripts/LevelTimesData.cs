using Godot;
using System;
using System.Collections.Generic;

public static class LevelTimesData
{
	public static int ReturnScore(int level, double time)
	{
		Dictionary<int, int[]> _leveltimedata = new Dictionary<int, int[]>()
		{
			{0,new int[2]{5,10}},
			{1,new int[2]{20,25}},
			{2,new int[2]{20,25}},
			{3,new int[2]{20,25}},
			{4,new int[2]{20,25}},
			{5,new int[2]{20,25}},
			{6,new int[2]{20,25}},
			{7,new int[2]{20,25}},
			{8,new int[2]{20,25}},
			{9,new int[2]{20,25}},
			{10,new int[2]{20,25}},
			{11,new int[2]{20,25}},
			{12,new int[2]{20,25}},
			{13,new int[2]{20,25}},
			{14,new int[2]{20,25}},
			{15,new int[2]{20,25}},
			{16,new int[2]{20,25}},
			{17,new int[2]{20,25}},
		};
		
		if(level >= _leveltimedata.Count || time == 0)
			return 0; //default if level is out of range or time non existant

		for (int i = 0; i < _leveltimedata[level].Length; i++)
		{
			if(time < _leveltimedata[level][i])
			{
				return _leveltimedata[level].Length-i+1; //higher rating is better, e.g. best = 3 stars
			}
		}
		return 1;        
	}
}
