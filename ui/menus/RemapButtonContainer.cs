using System;
using System.Runtime.CompilerServices;
using Godot;
using MyGodotExtensions;

public partial class RemapButtonContainer : Node
{
    public string Label
    {
        get
        {
            if (this.TryGetChild<Label>(out Label label))
            {
                return label.Text;
            }
            return null;
        }
        set
        {
            if (this.TryGetChild<Label>(out Label label))
            {
                label.Text = value;
            }
        }
    }

    public Button Button
    {
        get
        {
            if (this.TryGetChild<Button>(out Button button))
            {
                return button;
            }
            return null;
        }
    }

    public override void _Ready()
    {
        // When toggle_mode is set to true, the button becomes toggleable, meaning:
        // Clicking it switches its pressed state between true and false.
        // It stays pressed after being clicked, until clicked again or manually changed in code.
        // Button.ToggleMode = true;

        // If set to true, enables unhandled input processing. This is not required for
        // GUI controls! It enables the node to receive all input that was not previously
        // handled (usually by a Godot.Control). Enabled automatically if Godot.Node._UnhandledInput(Godot.InputEvent) is overridden.
        // thus false at start
        SetProcessUnhandledInput(false);

        Button.Pressed += async () =>
        {
            Button.Text = "...";
            Button.Disabled = true; // disable while waiting
            await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame); // wait 1 frame to ignore first button press
            SetProcessUnhandledInput(true);
        };
    }


    public override void _UnhandledInput(InputEvent inputEvent)
    {
        // GD.Print("unhandled input: "+GetReadableInputName(inputEvent));
        Button.Text = GetReadableInputName(inputEvent);
        SetProcessUnhandledInput(false);
        Button.Disabled = false;
        Button.ButtonPressed = false;
    }

	private string GetReadableInputName(InputEvent inputEvent)
	{
		if (inputEvent is InputEventKey keyEvent)
		{
			return OS.GetKeycodeString(keyEvent.PhysicalKeycode);
		}
		else if (inputEvent is InputEventMouseButton mouseEvent)
		{
			return mouseEvent.ButtonIndex switch
			{
				MouseButton.Left => "Left Mouse Button",
				MouseButton.Right => "Right Mouse Button",
				MouseButton.Middle => "Middle Mouse Button",
				_ => $"Mouse Button {mouseEvent.ButtonIndex}"
			};
		}
		else if (inputEvent is InputEventJoypadButton joyEvent)
		{
			return $"Joystick Button {joyEvent.ButtonIndex}";
		}
		else if (inputEvent is InputEventJoypadMotion motionEvent)
		{
			return $"Joystick Axis {motionEvent.Axis}";
		}

		return "Unknown Input";
	}
}
