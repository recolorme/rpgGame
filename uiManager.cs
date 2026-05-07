using Godot;
using System;

public partial class uiManager : Node
{
	public PackedScene textboxRes = GD.Load<PackedScene>("res://Text/textbox.tscn");
	public textboxHandler textbox;
	public bool uiActive = false;
	//public uiStack;

	
	
	public override void _Ready()
	{
		
	}

	public override void _Process(double _delta)
	{
	}

	public textboxHandler openTextbox()
	{
		textbox = textboxRes.Instantiate<textboxHandler>();
		return textbox;
	}
}
