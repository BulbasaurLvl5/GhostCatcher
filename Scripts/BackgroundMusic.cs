using Godot;
using MyGodotExtentions;
using System;
using System.Collections.Generic;

public partial class BackgroundMusic : Node
{
    AudioStreamPlayer channel_1;
    AudioStreamPlayer channel_2;

    AnimationPlayer animationPlayer;

    public enum Songs
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
        AudioStreamMP3 _firstsong = ResourceLoader.Load<AudioStreamMP3>("res://Audio/Music/phantomx27s-embrace-164479.mp3");
        channel_1.Stream = _firstsong;
        channel_1.Play();
        // channel_1.Stop();
        // GD.Print(channel_1.Playing);
    }

    public void ChangeSongTo(Songs song)
    {
        if (channel_1.Playing && channel_2.Playing)
		    return; //both channels playing. find a solution for this
        
        if (channel_1.Playing && !channel_2.Playing)
        {
            //set song to channel 2
            //start playing of channel2
            //call correct animation player : animationPlayer.Play("FadeToChannel2");
        }
    }
}
