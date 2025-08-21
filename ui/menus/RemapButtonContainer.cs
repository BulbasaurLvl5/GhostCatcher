using System;
using System.Runtime.CompilerServices;
using Godot;
using MyGodotExtensions;

public partial class RemapButtonContainer : Node
{
    //label stores the name of the inputmap action
    //internally this string is used by godot functions to operate the inputmap
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
            await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame); // wait 1 frame to ignore first button press (enter)
            SetProcessUnhandledInput(true);
        };
    }


    public override void _UnhandledInput(InputEvent inputEvent)
    {
        if (InputAssistance.InputEventToString(inputEvent) == "Unknown Input")
            return;

        Button.Text = InputAssistance.InputEventToString(inputEvent);

        InputMap.ActionEraseEvents(Label); //erase old events
        InputMap.ActionAddEvent(Label, inputEvent); //add new input to map

        //save to player prefs

        SetProcessUnhandledInput(false);
        Button.Disabled = false;
        Button.ButtonPressed = false;
    }
}
