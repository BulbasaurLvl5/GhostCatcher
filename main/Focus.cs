using Godot;
using System;
using MyGodotExtensions;
using System.Collections.Generic;

public partial class Focus : Node
{
    /**************************************************************
    https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#window-focus

    The problem we are trying to solve:
    When the game is minimized, controller input is not blocked

    " Unlike keyboard input, controller inputs can be seen by all windows on the operating system, including unfocused windows (our game).
    If you wish to ignore events when the project window isn't focused, 
    you will need to create an autoload called Focus with the following script and use it to check all your inputs... "

    The documented solution force you to rewrite all input
    this script aims to centralize this by stripping the inputmap of ALL input events in inputmap when unfocusing the game
    storing them, and finally reapplying when focusing back

    It has to be done dynamically everytime, because we ahave to assume that the events change via input remapping
    */
    
    private Dictionary<string, Godot.Collections.Array<Godot.InputEvent>> _savedBindings = new();


    public override void _Notification(int notification_id)
    {
        switch (notification_id)
        {
            case (int)NotificationApplicationFocusOut:
                GD.Print("Focus? false");
                DisableInput();
                break;
            case (int)NotificationApplicationFocusIn:
                GD.Print("Focus? true");
                EnableInput();
                break;
        }
    }


    void DisableInput()
    {
        _savedBindings.Clear();

        foreach (var _ in InputMap.GetActions())
        {
            _savedBindings.Add(_, InputMap.ActionGetEvents(_)); //store all input
            //GD.Print(_.ToString());
            InputMap.ActionEraseEvents(_); //erase all input
        }
    }


    void EnableInput()
    {
        foreach (var _ in InputMap.GetActions())
        {
            foreach (InputEvent _event in _savedBindings[_])
            {
                InputMap.ActionAddEvent(_, _event);
            }
        }
    }
}
