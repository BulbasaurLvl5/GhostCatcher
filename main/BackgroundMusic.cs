using Godot;
using MyGodotExtensions;
using System;
using System.Collections.Generic;

public partial class BackgroundMusic : Node
{
	AudioStreamPlayer channel_1;
	AudioStreamPlayer channel_2;

	AudioStreamPlayer activeChannel;
	AudioStreamPlayer inactiveChannel;

	AnimationPlayer animationPlayer;

	public enum SongNames
	{
		labyrinthofdespair,
		phantomx27,
	}

	public override void _Ready()
	{
		if(this.TryGetChildren(out List<AudioStreamPlayer> audiostreamplayers))
		{
			channel_1 = audiostreamplayers[0];
			channel_2 = audiostreamplayers[1];
		}

		this.TryGetChild(out animationPlayer);

		Startplaying();
	}

	void Startplaying()
	{
		// AudioStream _firstsong = ResourceLoader.Load<AudioStream>("res://Audio/Music/phantomx27s-embrace-164479.mp3");
		channel_1.Stream = SongFile(SongNames.phantomx27);
		channel_1.Play();
		// channel_1.Stop();
		// GD.Print(channel_1.Playing);
	}

	void SetActiveChannel()
	{
		if (channel_1.VolumeDb > -5 && channel_2.VolumeDb < -75)
		{
			activeChannel = channel_1;
			inactiveChannel = channel_2;
		}
		else if (channel_1.VolumeDb < -75 && channel_2.VolumeDb > -5)
		{
			activeChannel = channel_2;
			inactiveChannel = channel_1;
		}
		else //this may happen during cross fade. it remains to be seen if this solution is a problem
		{
			activeChannel = channel_1;
			inactiveChannel = channel_2;
		}
	}

	AudioStream SongFile(SongNames song)
	{
		switch(song) 
		{
		case SongNames.labyrinthofdespair:
			return ResourceLoader.Load<AudioStream>("res://resources/audio/music/labyrinth-of-despair-166594.mp3");
		case SongNames.phantomx27:
			return ResourceLoader.Load<AudioStream>("res://resources/audio/music/phantomx27s-embrace-164479.mp3");
		default:
			GD.Print("requested song does not exist");
			return ResourceLoader.Load<AudioStream>("res://resources/audio/music/phantomx27s-embrace-164479.mp3");
		}
	}

	SongNames GetCurrentSong()
	{
		// GD.Print("song: "+activeChannel.Stream.ResourcePath);
		// if(activeChannel.Stream.ResourcePath.Contains("phantom"))
		//     GD.Print("song is phantom");
		string _path = activeChannel.Stream.ResourcePath;

		if(_path.Contains("phantom"))
			return SongNames.phantomx27;
		else if(_path.Contains("labyrinth"))
			return SongNames.labyrinthofdespair;
		else
			return SongNames.phantomx27;
	}

	public void CrossfadeTo(SongNames songname)
	{
		SetActiveChannel();
		if(GetCurrentSong() == SongNames.phantomx27)
			return; //skip if already in menu
		
		inactiveChannel.Stream = SongFile(songname);
		inactiveChannel.Play();

		if (activeChannel == channel_1)
		{
			animationPlayer.Play("FadeToChannel2");
		}
		else if (activeChannel == channel_2)
		{
			animationPlayer.Play("FadeToChannel1");
		}
	}

	public void FadeoutToPlay(SongNames songname)
	{
		SetActiveChannel();
		inactiveChannel.Stream = SongFile(songname);
		inactiveChannel.Play();
		inactiveChannel.VolumeDb = 0;
		
		if (activeChannel == channel_1)
		{
			animationPlayer.Play("FadeoutChannel1");
		}
		else if (activeChannel == channel_2)
		{
			animationPlayer.Play("FadeoutChannel2");
		}
	}
}
