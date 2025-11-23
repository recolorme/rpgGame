using Godot;
using System;
public partial class textboxTrigger : Area2D
{
	[Export] public string[] text = Array.Empty<string>();
	private bool playerInRange = false;
	private textboxHandler textboxHandler;
	public override void _Ready()
	{
		BodyEntered += OnBodyEntered;
		BodyExited += OnBodyExited;

		textboxHandler = GetNode<textboxHandler>($"../Textbox");
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
		// Only add new lines if the textbox is idle
		if (textboxHandler.currentState == textboxHandler.State.IDLE)
		{
			textboxHandler.textQueue = text;
		}
	}
}
