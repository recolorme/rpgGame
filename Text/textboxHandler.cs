using Godot;
using System.Threading.Tasks;

[GlobalClass]
public partial class textboxHandler : Node
{
	public MarginContainer TextboxContainer;
	public Label endSymbol;
	public RichTextLabel text;
	public float TEXT_SPEED = 0.04f;
	public string[] textQueue;
	public int totalChars;
	public float duration;

	public enum State
	{
		IDLE,
		TYPING,
		FINISHED
	}
	public State currentState = State.IDLE;
	private Tween tween;

	public override void _Ready()
	{
		base._Ready();
		TextboxContainer = GetNode<MarginContainer>("TextboxContainer");
		text = GetNode<RichTextLabel>("TextboxContainer/Panel/HBoxContainer/RichTextLabel");
		endSymbol = GetNode<Label>("TextboxContainer/Panel/HBoxContainer/endSymbol");

		// text effects
		text.BbcodeEnabled = true;
		// word wrapping
		text.VisibleCharactersBehavior = TextServer.VisibleCharactersBehavior.CharsAfterShaping;

		hideTextbox();
	}

	public override void _Process(double _delta)
	{
		switch (currentState)
		{
			case State.IDLE:
				if(textQueue != null && textQueue.Length > 0)
				{
					_ = displayText(textQueue[0]);
					textQueue = textQueue[1..];
					endSymbol.Text = "";
				}
				break;
			case State.TYPING:
				if(Input.IsActionJustPressed("ui_accept"))
				{
					tween.Kill();
					text.VisibleCharacters = text.GetTotalCharacterCount();
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
		text.VisibleCharacters = 0;
		endSymbol.Text = "";
		TextboxContainer.Hide();
	}

	public async Task displayText(string nextText)
	{
		if(!TextboxContainer.Visible) TextboxContainer.Show();
		currentState = State.TYPING;
		text.Text = nextText;
		totalChars = text.GetTotalCharacterCount();
		text.VisibleCharacters = 0;

		tween = GetTree().CreateTween();
		duration = totalChars * TEXT_SPEED;
		tween.TweenProperty(text, "visible_characters", totalChars, duration);

		if (textQueue.Length == 0) endSymbol.Text = "*";

		await ToSignal(tween, "finished");
		currentState = State.FINISHED;
		endSymbol.Text = "*"; 
	}
}
