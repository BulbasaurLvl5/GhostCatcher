using Godot;
using System;
using System.Threading.Tasks;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class Ghost : Area2D
{
	//This extra code isn't needed for now, because there's only one animation.
	//It will come in handy if we add a second animation and want to switch from this script.
	//private AnimatedSprite2D Anim;
		
	public override void _Ready()
	{
		BodyEntered += PlayerCollision;
		//Anim = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		//Anim.Play();

		if(this.TryGetNestedChildren(out List<AnimationPlayer> anim))
		{
			anim[0].Seek(GD.RandRange(0,1), true);
			anim[1].Seek(GD.RandRange(0,1), true);
		}
	}

	async void PlayerCollision(Node2D player)
	{
		if(this.TryGetChild(out GpuParticles2D _particles))
		{
			// GD.Print(_particles.Name);
			_particles.Emitting = true;
			_particles.Reparent(GetParent());
		}

		if(this.TryGetChild(out AudioStreamPlayer _audio))
		{
			// GD.Print(_particles.Name);
			_audio.Playing = true;
			_audio.Reparent(GetParent(),true);
		}
		//wait a ms, because otherwise it is freed before main registers collision
		//alternative is to connect main to TreeExit, but then it emits also when the scene is unbuilt
		await Task.Delay(1);
		QueueFree();
	}
}
