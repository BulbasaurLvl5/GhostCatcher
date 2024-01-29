using Godot;
using System;

public partial class ButtonSound : AudioStreamPlayer
{
    public override void _Ready()
    {
        GetTree().NodeAdded += (Node _n) => {
            if(_n is Button _b)
                _b.Pressed += () => { Play(); };
        };
    }
}
