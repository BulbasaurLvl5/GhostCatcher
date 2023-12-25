using Godot;
using System;
using System.Threading.Tasks;

public partial class Ghost : Area2D
{
	//This extra code isn't needed for now, because there's only one animation.
	//It will come in handy if we add a second animation and want to switch from this script.
	//private AnimatedSprite2D Anim;
		
	public override void _Ready()
	{
		AreaEntered += PlayerCollision;
		//Anim = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		//Anim.Play();
	}

	async void PlayerCollision(Area2D player)
	{
		//wait a ms, because otherwise it is freed before main registers collision
		//alternative is to connect main to TreeExit, but then it emits also when the scene is unbuilt
		await Task.Delay(1);
		QueueFree();
	}
}
