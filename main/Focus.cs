using Godot;
using System;

public partial class Focus : Node
{
    /**************************************************************
    https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#window-focus

    Unlike keyboard input, controller inputs can be seen by all windows on the operating system, including unfocused windows.
    If you wish to ignore events when the project window isn't focused, you will need to create an autoload called Focus with the following script and use it to check all your inputs:
    */

    bool _focus = true;

    public override void _Notification(int notification_id)
    {
        switch (notification_id)
        {
            case (int)NotificationApplicationFocusOut:
                GD.Print("Focus?" + _focus);
                _focus = false;
                break;
            case (int)NotificationApplicationFocusIn:
                GD.Print("Focus?" + _focus);
                _focus = true;
                break;
        }
    }
}
