using System.Collections.Generic;
using Godot;

namespace MyGodotExtensions
{
    public static class InputAssistance
    {
        
        public static string InputEventToString(InputEvent inputEvent)
        {
            /*
            Godot Input events sometimes are unhandy
            they have child classes and getting readable names is sometimes unintuitive
            things get worse with controller support
            */

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


        public static List<string> ReturnInputMapNames()
        {
            /*
            Returns the names of all input actions defined by user
            assumes names starting with ui_ belong to engine
            in other words, dont create input starting with ui_
            */

            List<string> _inputMapNames = new List<string>();

            foreach (var _ in InputMap.GetActions())
            {
                if (!_.ToString().StartsWith("ui_"))
                {
                    _inputMapNames.Add(_.ToString());
                }
            }

            return _inputMapNames;
        }


        public static string EventNameToKeyName(string eventName)
        {
            /*
            returns the key name assigned in the projects input map
            currently unfinished
            at the time of writing the function there are two key for each action:
            one keypad [0]
            one joypad [1]
            currently unknown if the [0] fails when there is only one
            for joypad event the cast has to be changed to InputEventJoypadButton
            */

            return OS.GetKeycodeString(((InputEventKey)InputMap.ActionGetEvents(eventName)[0]).Keycode);
        }


        public static bool IsJoypadConnected()
        {
            GD.Print("connected joy pads: " + Input.GetConnectedJoypads());
            GD.Print("is joypad connected? " + (Input.GetConnectedJoypads().Count > 0));
            return Input.GetConnectedJoypads().Count > 0;
        }
    }
}