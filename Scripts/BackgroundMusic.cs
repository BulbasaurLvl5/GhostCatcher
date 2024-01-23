using Godot;
using MyGodotExtentions;
using System;
using System.Collections.Generic;

public partial class BackgroundMusic : Node
{
    AudioStreamPlayer channel_1;
    AudioStreamPlayer channel_2;

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

    AudioStream SongFile(SongNames song)
    {
        switch(song) 
        {
        case SongNames.labyrinthofdespair:
            return ResourceLoader.Load<AudioStream>("res://Audio/Music/labyrinth-of-despair-166594.mp3");
        case SongNames.phantomx27:
            return ResourceLoader.Load<AudioStream>("res://Audio/Music/phantomx27s-embrace-164479.mp3");
        default:
            GD.Print("requested song does not exist");
            return ResourceLoader.Load<AudioStream>("res://Audio/Music/phantomx27s-embrace-164479.mp3");
        }
    }

    public void ChangeSongTo(SongNames song)
    {
        //they are both playing anyway as i see it, because only their volumne is changed
        // if (channel_1.Playing && channel_2.Playing)
		//     return; //both channels playing. find a solution for this
        
        if (channel_1.VolumeDb > -5 && channel_2.VolumeDb < -75)
        {
            //set song to channel 2
            channel_2.Stream = SongFile(song);
            //start playing of channel2
            channel_2.Play();
            //call correct animation player : animationPlayer.Play("FadeToChannel2");
            // channel_1.Stop();
            animationPlayer.Play("FadeToChannel2");
        }
        else if (channel_1.VolumeDb < -75 && channel_2.VolumeDb > -5)
        {
            //set song to channel 2
            channel_1.Stream = SongFile(song);
            //start playing of channel2
            channel_1.Play();
            //call correct animation player : animationPlayer.Play("FadeToChannel2");
            // channel_2.Stop();
            animationPlayer.Play("FadeToChannel1");
        }
    }
}
