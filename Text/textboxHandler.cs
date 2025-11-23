using Godot;
using System.Threading.Tasks;

[GlobalClass]
public partial class textboxHandler : Node
{
	public MarginContainer TextboxContainer;
	public Label endSymbol;
	public Label text;
	public float TEXT_SPEED = 2f;
	public string[] textQueue;

	public enum State
	{
		IDLE,
		TYPING,
		FINISHED
	}
	public State currentState = State.IDLE;
	private Tween tween;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		base._Ready();
		TextboxContainer = GetNode<MarginContainer>("TextboxContainer");
		text = GetNode<Label>("TextboxContainer/Panel/HBoxContainer/Label");
		endSymbol = GetNode<Label>("TextboxContainer/Panel/HBoxContainer/endSymbol");

		hideTextbox();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		switch (currentState)
		{
			case State.IDLE:
				if(textQueue != null && textQueue.Length > 0)
				{
					_ = displayText(textQueue[0]);
					textQueue = textQueue[1..];
				}
				break;
			case State.TYPING:
				if(Input.IsActionJustPressed("ui_accept"))
				{
					tween.Kill();
					text.VisibleRatio = 1f;
					currentState = State.FINISHED;
					endSymbol.Text = "*"; 
				}
				break;
			case State.FINISHED:
				if(Input.IsActionJustPressed("ui_accept"))
				{
					if (textQueue.Length == 0) hideTextbox();
					currentState = State.IDLE;
				}
				break;
		}
	}

	public void hideTextbox()
	{
		text.Text = "";
		text.VisibleRatio = 0f;
		endSymbol.Text = "";
		TextboxContainer.Hide();
	}

	public async Task displayText(string nextText)
	{
		if(!TextboxContainer.Visible) TextboxContainer.Show();
		currentState = State.TYPING;
		text.Text = nextText;
		text.VisibleRatio = 0f;

		tween = GetTree().CreateTween();
		tween.TweenProperty(text, "visible_ratio", TEXT_SPEED, TEXT_SPEED);

		await ToSignal(tween, "finished");
		currentState = State.FINISHED;
		endSymbol.Text = "*"; 
	}
}
