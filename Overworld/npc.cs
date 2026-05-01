using Godot;
using System;

public partial class npc : CharacterBody2D
{
	[Export] public string jsonPath = "res://Text/Dialogues/test.txt";
	
	private Area2D detector;
	private bool playerInRange = false;
	private textboxHandler textboxHandler;

	public override void _Ready()
	{
		base._Ready();
		
		// Get the detector Area2D child
		detector = GetNode<Area2D>("detector");
		if (detector != null)
		{
			detector.BodyEntered += OnBodyEntered;
			detector.BodyExited += OnBodyExited;
		}
		
		// Get textbox handler
		textboxHandler = GetNodeOrNull<textboxHandler>($"../../Textbox");
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
		var jsonHelper = GetNodeOrNull<Node>($"../../Textbox/JSONHelper");
		if (jsonHelper == null)
		{
			GD.PrintErr("JSONHelper not found.");
			return;
		}
		
		string[] text = ((Godot.Variant)jsonHelper.Call("load_dialogue", jsonPath)).AsStringArray();
		
		// Only add new lines if the textbox is idle
		if (textboxHandler.currentState == textboxHandler.State.IDLE)
		{
			textboxHandler.textQueue = text;
		}
	}
}
