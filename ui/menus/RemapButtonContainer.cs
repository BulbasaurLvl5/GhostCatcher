using System;
using System.Collections.Generic;
using System.Net;
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

    // assumes two buttons: first for keyboard/mouse input, second for joypads
    List<Button> _buttons = new();

    public Button EntryButton { get { return this.TryGetChild<Button>(); } }

    public List<string> InputStrings = new List<string>();


    public override void _Ready()
    {
        if (!this.TryGetChildren<Button>(out List<Button> _buttons))
        {
            GD.Print("ERROR: buttons not found by " + this.Name);
            return;
        }
        else
            this._buttons = _buttons;

        // When toggle_mode is set to true, the button becomes toggleable, meaning:
        // Clicking it switches its pressed state between true and false.
        // It stays pressed after being clicked, until clicked again or manually changed in code.
        // Button.ToggleMode = true;

        // If set to true, enables unhandled input processing. This is not required for
        // GUI controls! It enables the node to receive all input that was not previously
        // handled (usually by a Godot.Control). Enabled automatically if Godot.Node._UnhandledInput(Godot.InputEvent) is overridden.
        // thus false at start
        SetProcessUnhandledInput(false);

        _buttons[0].Pressed += async () =>
        {
            // _buttons[0].Text = "..."; // does not do anything bc _Process
            _buttons[0].Disabled = true; // disable while waiting
            InputAssistance.DisableInput();
            await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame); // wait 1 frame to ignore first button press (enter)

            SetProcessUnhandledInput(true);
        };
    }


    public override void _Process(double delta)
    {
        // this could and should be done by menu options
        // however the menu does almost nothing so it is uncritical
        // and it simplifies the code. so what ever
        if (InputAssistance.IsInputDisabled())
            return;

        InputStrings.Clear();
        foreach (var _ in InputMap.ActionGetEvents(Label))
        {
            InputStrings.Add(InputAssistance.InputEventToString(_));
        }
        _buttons[0].Text = string.Join(", ", InputStrings);
    }


    public override void _UnhandledInput(InputEvent inputEvent)
    {
        if (InputAssistance.InputEventToString(inputEvent) != null)
        {
            InputAssistance.EnableInput();

            if (InputAssistance.IsKeyAlreadyUsed(inputEvent, out string action))
            {
                InputMap.ActionEraseEvent(action, inputEvent);
            }

            if (InputMap.ActionGetEvents(Label).Count > 3)
            {
                InputMap.ActionEraseEvent(Label, InputMap.ActionGetEvents(Label)[0]);
            }

            InputMap.ActionAddEvent(Label, inputEvent);

            _buttons[0].ButtonPressed = false;
            _buttons[0].Disabled = false;
        }
        SetProcessUnhandledInput(false);
    }
}
