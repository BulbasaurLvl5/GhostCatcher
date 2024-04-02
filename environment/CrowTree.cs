using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class CrowTree : Area2D
{
	bool _fired = false;
	public override void _Ready()
	{
		BodyEntered += Collision;
	}

	void Collision(Node2D player)
	{
		if(_fired == true)
			return;

		if(this.TryGetChildren(out List<GpuParticles2D> _particles))
		{
			foreach (var _ in _particles)
			{
				_.Emitting = true;
			}
		}

		if(this.TryGetChild(out AudioStreamPlayer2D _audio))
		{
			_audio.Playing = true;
		}

		_fired = true;
	}
}
