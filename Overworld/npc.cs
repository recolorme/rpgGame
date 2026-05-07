using Godot;
using System;

public partial class npc : CharacterBody2D
{
	[Export] public string jsonPath = "res://Text/Dialogues/test.txt";
	[Export] public bool noCollision;
	public string[] text;
	//public AudioStream textboxSFX;
	private bool playerInRange = false;
	private textboxHandler textboxHandler;
	private Area2D interactable; //to use Area2D functions
	private CollisionShape2D collision;
	public override void _Ready()
	{
		interactable = GetNode<Area2D>("interactable");

		interactable.BodyEntered += OnBodyEntered;
		interactable.BodyExited += OnBodyExited;

		textboxHandler = GetNodeOrNull<textboxHandler>($"../Textbox");
		var jsonHelper = GetNode<Node>($"../Textbox/JSONHelper");
		text = ((Godot.Variant)jsonHelper.Call("load_dialogue", jsonPath)).AsStringArray();

		//disables collision from inspector
		if (noCollision)
		{
			collision = GetNode<CollisionShape2D>("CollisionShape2D");
			collision.Disabled = true;
		}

		//textboxSFX = ResourcePreloader.Load<AudioStream>("res://Audio/TextboxSFX.wav");
	}

	public override void _Process(double delta)
	{
		if (playerInRange && Input.IsActionJustPressed("ui_accept"))
		{
			RunInteraction();
		}
	}

	private void OnBodyEntered(Node body)
	{
		if (body.Name == "Player")
		{
			playerInRange = true;
			Sprite2D interactionHint = body.GetNodeOrNull<Sprite2D>("interactionHint");
			if (interactionHint != null)
			{
				interactionHint.Visible = true;
			}
		}
	}

	private void OnBodyExited(Node body)
	{
		if (body.Name == "Player")
		{
			playerInRange = false;
			Sprite2D interactionHint = body.GetNodeOrNull<Sprite2D>("interactionHint");
			if (interactionHint != null)
			{
				interactionHint.Visible = false;
			}
		}
	}

	private void RunInteraction()
	{
		if (textboxHandler == null)
		{
			GD.PrintErr("TextboxHandler not found.");
			return;
		}
		
		// Load dialogue text
		// var jsonHelper = GetNodeOrNull<Node>($"../../Textbox/JSONHelper");
		// if (jsonHelper == null)
		// {
		// 	GD.PrintErr("JSONHelper not found.");
		// 	return;
		// }
		
		// string[] text = ((Godot.Variant)jsonHelper.Call("load_dialogue", jsonPath)).AsStringArray();
		
		// global.set_dialog(dialog, self) 
		// uiManager.open_dialogue_box()
		// global.persistPlayer.pause()

		// Only add new lines if the textbox is idle
		if (textboxHandler.currentState == textboxHandler.State.IDLE)
		{
			textboxHandler.textQueue = text;
		}


	}
}
