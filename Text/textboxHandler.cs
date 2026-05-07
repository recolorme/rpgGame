using Godot;
using System.Threading.Tasks;

[GlobalClass]
public partial class textboxHandler : Node
{
	public MarginContainer textboxContainer;
	public Control textboxUI;
	public Label endSymbol;
	public RichTextLabel text;
	public float TEXT_SPEED = 0.03f;
	public string[] textQueue;
	public int totalChars;
	public float duration;
	public bool isActive = false;

	public enum State
	{
		IDLE,
		TYPING,
		FINISHED
	}
	public State currentState = State.IDLE;
	private Tween tween;
	public Timer timer;
	public AudioStreamPlayer audioStreamPlayer;

	public override void _Ready()
	{
		base._Ready();
		textboxContainer = GetNode<MarginContainer>("TextboxUI/TextboxContainer");
		textboxUI = GetNode<Control>("TextboxUI");
		text = GetNode<RichTextLabel>("TextboxUI/TextboxContainer/Panel/HBoxContainer/RichTextLabel");
		endSymbol = GetNode<Label>("TextboxUI/TextboxContainer/Panel/HBoxContainer/endSymbol");
		timer = GetNode<Timer>("TextboxUI/Timer");
		audioStreamPlayer = GetNode<AudioStreamPlayer>("TextboxUI/AudioStreamPlayer");

		timer.Timeout += OnTimerTimeout;

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
					text.VisibleCharacters = text.GetTotalCharacterCount();
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

	public void showTextbox()
	{
		isActive = true;
		// textboxUI.ProcessMode = Node.PROCESS_MODE_ALWAYS;
		// get_tree().paused = true;
		textboxUI.Show();
	}
	public void hideTextbox()
	{
		isActive = false;
		// textboxUI.ProcessMode = Node.PROCESS_MODE_ALWAYS;
		// get_tree().paused = false;

		text.Text = "";
		text.VisibleCharacters = 0;
		endSymbol.Text = "";
		textboxUI.Hide();
	}

	public async Task displayText(string nextText)
	{
		showTextbox();

		currentState = State.TYPING;
		text.Text = nextText;
		totalChars = text.GetTotalCharacterCount();
		text.VisibleCharacters = 0;

		startTimer();
	}

	public void startTimer()
	{
		// manipulates wait time
		timer.WaitTime = TEXT_SPEED;
		timer.Start();
	}
	private void OnTimerTimeout()
	{
		text.VisibleCharacters += 1;
		if (text.VisibleCharacters <= totalChars)
		{
			// letterAdded?.Invoke(plainTotalChars[text.VisibleCharacters - 1]);
			textboxSFX();
			startTimer();
		}
		else
		{
			endSymbol.Text = "*";
			endSymbol.Show();
			currentState = State.FINISHED;
		}
	}

	public void textboxSFX()
	{
		if ("abcdefghijklmnopqrstuvwxyz123456789".Contains(text.GetParsedText()[text.VisibleCharacters - 1].ToString()))
		{
			audioStreamPlayer.PitchScale = (float)GD.RandRange(0.98f,1.02f);
			audioStreamPlayer.Play();
		}
		else if (".,!?-".Contains(text.GetParsedText()[text.VisibleCharacters - 1].ToString()))
		{
			// silence
		}
	}

	// public void _unhandledInput(InputEvent event)
	// {
	// 	// if (!isActive)
	// 	// {
	// 	// 	return;
	// 	// }
	// 	// if event.is_action_pressed("ui_accept")
	// 	if (event.is_action_pressed("ui_accept"))
	// 	{
	// 		if (!isActive)
	// 		{
	// 		showTextbox();
	// 		}
	// 		else
	// 		{
	// 		hideTextbox();
	// 		}
	// 	}
	// }


}
