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
    
    public Button EntryButton { get {return this.TryGetChild<Button>();} } //used to navigate menu. TODO should change if controller is plugged


    public override void _Ready()
    {
        if (!this.TryGetChildren<Button>(out List<Button> _buttons))
        {
            GD.Print("ERROR: buttons not found by " + this.Name);
            return;            
        }

        // When toggle_mode is set to true, the button becomes toggleable, meaning:
        // Clicking it switches its pressed state between true and false.
        // It stays pressed after being clicked, until clicked again or manually changed in code.
        // Button.ToggleMode = true;

        // If set to true, enables unhandled input processing. This is not required for
        // GUI controls! It enables the node to receive all input that was not previously
        // handled (usually by a Godot.Control). Enabled automatically if Godot.Node._UnhandledInput(Godot.InputEvent) is overridden.
        // thus false at start
        SetProcessUnhandledInput(false);

        foreach (var _ in InputMap.ActionGetEvents(Label))
        {
            // GD.Print(Label + " " + _);

            if (_ is InputEventKey _inputEventKey)
            {
                // GD.Print(_ie + " is InputEventKey");
                // GD.Print(_ie.Keycode);
                _buttons[0].Text = _inputEventKey.Keycode.ToString();

                _buttons[0].Pressed += async () =>
                {
                    _buttons[0].Text = "...";
                    _buttons[0].Disabled = true; // disable while waiting
                    await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame); // wait 1 frame to ignore first button press (enter)

                    //check if input is keyboard or mouse and only proceed then
                    //does this require a wrapper function for unhandled input or a flag? likely flag for switch in _UnhandledInput
                    SetProcessUnhandledInput(true);
                };
            }
        }
    }


    public override void _UnhandledInput(InputEvent inputEvent)
    {
        // turn this into switch
        // check if input is correct for the button used
        // change InputEventToString to return enum
        if (InputAssistance.InputEventToString(inputEvent) == "Unknown Input")
            return;

        _buttons[0].Text = InputAssistance.InputEventToString(inputEvent);

        InputMap.ActionEraseEvents(Label); //erase old events
        InputMap.ActionAddEvent(Label, inputEvent); //add new input to map

        //save to player prefs

        SetProcessUnhandledInput(false);
        _buttons[0].Disabled = false;
        _buttons[0].ButtonPressed = false;
    }
}
