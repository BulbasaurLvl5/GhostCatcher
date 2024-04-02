using Godot;
using System;

public class SaveGame
{
	public int[] lastTimes;
	public int[] bestTimes;

	public SaveGame()
	{
		lastTimes = new int[LevelLoader.LoadLevel.Length];
		bestTimes = new int[LevelLoader.LoadLevel.Length];
	}

	public SaveGame(int lvl, double time)
	{
		
	}
}
