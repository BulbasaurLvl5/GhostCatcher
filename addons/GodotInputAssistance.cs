using System;
using System.Collections.Generic;
using Godot;

namespace MyGodotExtensions
{
    public static class InputAssistance
    {
        /*
        Godot Input events sometimes are unhandy
        they have child classes and getting readable names is sometimes unintuitive
        things get worse with controller support

        to solve this _inputEventDict maps all keys i could think of to a string
        this string can be used ingame to display the key and to saved as JSON
        the functions InputEventToString and StringToInputEvent operate on this dict
        */
        static Dictionary<string, InputEvent> _inputEventDict = new Dictionary<string, InputEvent>
        {
            // Mouse Buttons
            { "MBL", new InputEventMouseButton { ButtonIndex = MouseButton.Left } },
            { "MBR", new InputEventMouseButton { ButtonIndex = MouseButton.Right } },
            { "MBM", new InputEventMouseButton { ButtonIndex = MouseButton.Middle } },
            { "MWU", new InputEventMouseButton { ButtonIndex = MouseButton.WheelUp } },
            { "MWD", new InputEventMouseButton { ButtonIndex = MouseButton.WheelDown } },
            { "MWL", new InputEventMouseButton { ButtonIndex = MouseButton.WheelLeft } },
            { "MWR", new InputEventMouseButton { ButtonIndex = MouseButton.WheelRight } },

            // Joypad Motion
            { "JSLL", new InputEventJoypadMotion { Axis = JoyAxis.LeftX, AxisValue = -.5f } }, //.5 is godot default
            { "JSLR", new InputEventJoypadMotion { Axis = JoyAxis.LeftX, AxisValue = .5f } },
            { "JSLU", new InputEventJoypadMotion { Axis = JoyAxis.LeftY, AxisValue = -.5f } },
            { "JSLD", new InputEventJoypadMotion { Axis = JoyAxis.LeftY, AxisValue = .5f } },
            { "JSRL", new InputEventJoypadMotion { Axis = JoyAxis.RightX, AxisValue = -.5f  } },
            { "JSRR", new InputEventJoypadMotion { Axis = JoyAxis.RightX, AxisValue = .5f  } },
            { "JSRU", new InputEventJoypadMotion { Axis = JoyAxis.RightY, AxisValue = -.5f  } },
            { "JSRD", new InputEventJoypadMotion { Axis = JoyAxis.RightY, AxisValue = .5f  } },
            { "JPTL", new InputEventJoypadMotion { Axis = JoyAxis.TriggerLeft, AxisValue = .5f } },
            { "JPTR", new InputEventJoypadMotion { Axis = JoyAxis.TriggerRight, AxisValue = .5f } },

            // Joypad Buttons
            { "JPA", new InputEventJoypadButton { ButtonIndex = JoyButton.A } },
            { "JPB", new InputEventJoypadButton { ButtonIndex = JoyButton.B } },
            { "JPX", new InputEventJoypadButton { ButtonIndex = JoyButton.X } },
            { "JPY", new InputEventJoypadButton { ButtonIndex = JoyButton.Y } },
            { "JPLS", new InputEventJoypadButton { ButtonIndex = JoyButton.LeftShoulder } },
            { "JPRS", new InputEventJoypadButton { ButtonIndex = JoyButton.RightShoulder } },
            //{ "JPSe", new InputEventJoypadButton { ButtonIndex = JoyButton.Select } }, UI only
            //{ "JPSt", new InputEventJoypadButton { ButtonIndex = JoyButton.Start } }, UI only
            // { "JPL3", new InputEventJoypadButton { ButtonIndex = JoyButton.L3 } }, there are two shoulder buttons left
            // { "JPR3", new InputEventJoypadButton { ButtonIndex = JoyButton.R3 } }, there are two shoulder buttons left
            { "JPDU", new InputEventJoypadButton { ButtonIndex = JoyButton.DpadUp } },
            { "JPDD", new InputEventJoypadButton { ButtonIndex = JoyButton.DpadDown } },
            { "JPDL", new InputEventJoypadButton { ButtonIndex = JoyButton.DpadLeft } },
            { "JPDR", new InputEventJoypadButton { ButtonIndex = JoyButton.DpadRight } },
            //{ "joy_button_guide", new InputEventJoypadButton { ButtonIndex = JoyButton.Guide } }, no idea what that is

            // Keyboard letters
            { "A", new InputEventKey { Keycode = Key.A } },
            { "B", new InputEventKey { Keycode = Key.B } },
            { "C", new InputEventKey { Keycode = Key.C } },
            { "D", new InputEventKey { Keycode = Key.D } },
            { "E", new InputEventKey { Keycode = Key.E } },
            { "F", new InputEventKey { Keycode = Key.F } },
            { "G", new InputEventKey { Keycode = Key.G } },
            { "H", new InputEventKey { Keycode = Key.H } },
            { "I", new InputEventKey { Keycode = Key.I } },
            { "J", new InputEventKey { Keycode = Key.J } },
            { "K", new InputEventKey { Keycode = Key.K } },
            { "L", new InputEventKey { Keycode = Key.L } },
            { "M", new InputEventKey { Keycode = Key.M } },
            { "N", new InputEventKey { Keycode = Key.N } },
            { "O", new InputEventKey { Keycode = Key.O } },
            { "P", new InputEventKey { Keycode = Key.P } },
            { "Q", new InputEventKey { Keycode = Key.Q } },
            { "R", new InputEventKey { Keycode = Key.R } },
            { "S", new InputEventKey { Keycode = Key.S } },
            { "T", new InputEventKey { Keycode = Key.T } },
            { "U", new InputEventKey { Keycode = Key.U } },
            { "V", new InputEventKey { Keycode = Key.V } },
            { "W", new InputEventKey { Keycode = Key.W } },
            { "X", new InputEventKey { Keycode = Key.X } },
            { "Y", new InputEventKey { Keycode = Key.Y } },
            { "Z", new InputEventKey { Keycode = Key.Z } },
            
            // Keyboard Modifiers & Control
            { "ENTER", new InputEventKey { Keycode = Key.Enter } },
            { "SPACE", new InputEventKey { Keycode = Key.Space } },
            //{ "ESC", new InputEventKey { Keycode = Key.Escape } }, UI only
            { "SHIFT", new InputEventKey { Keycode = Key.Shift } },
            { "CTRL", new InputEventKey { Keycode = Key.Ctrl } },
            { "ALT", new InputEventKey { Keycode = Key.Alt } },
            { "TAB", new InputEventKey { Keycode = Key.Tab } },
            //{ "key_capslock", new InputEventKey
            { "-", new InputEventKey { Keycode = Key.Minus } },
            { "+", new InputEventKey { Keycode = Key.Plus } },
            { ",", new InputEventKey { Keycode = Key.Comma } },
            { ".", new InputEventKey { Keycode = Key.Period } },
            { "/", new InputEventKey { Keycode = Key.Slash } },
            { ";", new InputEventKey { Keycode = Key.Semicolon } },
            { "'", new InputEventKey { Keycode = Key.Apostrophe } },
            // { "(", new InputEventKey { Keycode = Key.BracketLeft } },
            // { ")", new InputEventKey { Keycode = Key.BracketRight } },
            // { "\", new InputEventKey { Keycode = Key.Backslash } },
            //{ "", new InputEventKey { Keycode = Key.QuoteLeft } }, no way ... """ lol
            { "INSERT", new InputEventKey { Keycode = Key.Insert } },
            { "DEL", new InputEventKey { Keycode = Key.Delete } },
            //{ "key_home", new InputEventKey { Keycode = Key.Home } },
            { "END", new InputEventKey { Keycode = Key.End } },
            { "PGUP", new InputEventKey { Keycode = Key.Pageup } },
            { "PGDWN", new InputEventKey { Keycode = Key.Pagedown } },
            { "BACK", new InputEventKey { Keycode = Key.Backspace } },
            
            // Keyboard Numbers
            { "0", new InputEventKey { Keycode = Key.Key0 } },
            { "1", new InputEventKey { Keycode = Key.Key1 } },
            { "2", new InputEventKey { Keycode = Key.Key2 } },
            { "3", new InputEventKey { Keycode = Key.Key3 } },
            { "4", new InputEventKey { Keycode = Key.Key4 } },
            { "5", new InputEventKey { Keycode = Key.Key5 } },
            { "6", new InputEventKey { Keycode = Key.Key6 } },
            { "7", new InputEventKey { Keycode = Key.Key7 } },
            { "8", new InputEventKey { Keycode = Key.Key8 } },
            { "9", new InputEventKey { Keycode = Key.Key9 } },
            
            // Keyboard Function Keys
            { "F1", new InputEventKey { Keycode = Key.F1 } },
            { "F2", new InputEventKey { Keycode = Key.F2 } },
            { "F3", new InputEventKey { Keycode = Key.F3 } },
            { "F4", new InputEventKey { Keycode = Key.F4 } },
            { "F5", new InputEventKey { Keycode = Key.F5 } },
            { "F6", new InputEventKey { Keycode = Key.F6 } },
            { "F7", new InputEventKey { Keycode = Key.F7 } },
            { "F8", new InputEventKey { Keycode = Key.F8 } },
            { "F9", new InputEventKey { Keycode = Key.F9 } },
            { "F10", new InputEventKey { Keycode = Key.F10 } },
            { "F11", new InputEventKey { Keycode = Key.F11 } },
            { "F12", new InputEventKey { Keycode = Key.F12 } },
            
            // Keyboard Arrows
            { "UP", new InputEventKey { Keycode = Key.Up } },
            { "DOWN", new InputEventKey { Keycode = Key.Down } },
            { "LEFT", new InputEventKey { Keycode = Key.Left } },
            { "RIGHT", new InputEventKey { Keycode = Key.Right } },
            
            // Keyboard numpad
            { "NP0", new InputEventKey { Keycode = Key.Kp0 } },
            { "NP1", new InputEventKey { Keycode = Key.Kp1 } },
            { "NP2", new InputEventKey { Keycode = Key.Kp2 } },
            { "NP3", new InputEventKey { Keycode = Key.Kp3 } },
            { "NP4", new InputEventKey { Keycode = Key.Kp4 } },
            { "NP5", new InputEventKey { Keycode = Key.Kp5 } },
            { "NP6", new InputEventKey { Keycode = Key.Kp6 } },
            { "NP7", new InputEventKey { Keycode = Key.Kp7 } },
            { "NP8", new InputEventKey { Keycode = Key.Kp8 } },
            { "NP9", new InputEventKey { Keycode = Key.Kp9 } },
            { "NP+", new InputEventKey { Keycode = Key.KpAdd } },
            { "NP-", new InputEventKey { Keycode = Key.KpSubtract } },
            { "NP*", new InputEventKey { Keycode = Key.KpMultiply } },
            { "NP/", new InputEventKey { Keycode = Key.KpDivide } },
            { "NP,", new InputEventKey { Keycode = Key.KpPeriod } },
            { "NPE", new InputEventKey { Keycode = Key.KpEnter } },
        };


        // Function to construct InputEvent from string key
        public static InputEvent StringToInputEvent(string key)
        {
            if (_inputEventDict.TryGetValue(key, out InputEvent evt))
            {
                return evt.Duplicate() as InputEvent;
            }
            GD.PrintErr($"InputEvent key '{key}' not found.");
            return null;
        }
        
        
        // Reverse: get inputevent and get string ID
        public static string InputEventToString(InputEvent inputEvent)
        {
            foreach (var pair in _inputEventDict)
            {
                InputEvent _dictEvent = pair.Value;
                
                // Mouse Button
                    if (inputEvent is InputEventMouseButton mouseEvent &&
                        _dictEvent is InputEventMouseButton storedMouse &&
                        mouseEvent.ButtonIndex == storedMouse.ButtonIndex)
                    {
                        return pair.Key;
                    }
                // Joypad Motion
                if (inputEvent is InputEventJoypadMotion joyMotion &&
                    _dictEvent is InputEventJoypadMotion storedMotion &&
                    joyMotion.Axis == storedMotion.Axis &&
                    Math.Abs(joyMotion.AxisValue) >= .5 && //sensitivity check
                    Math.Sign(joyMotion.AxisValue) == Math.Sign(storedMotion.AxisValue)
                    )
                {
                    return pair.Key;
                }
                // Joypad Button
                if (inputEvent is InputEventJoypadButton joyButton &&
                    _dictEvent is InputEventJoypadButton storedButton &&
                    joyButton.ButtonIndex == storedButton.ButtonIndex)
                {
                    return pair.Key;
                }
                // Keyboard Key
                if (inputEvent is InputEventKey keyEvent &&
                    _dictEvent is InputEventKey storedKey &&
                    keyEvent.Keycode == storedKey.Keycode)
                {
                    return pair.Key;
                }
            }
            GD.PrintErr("ERROR: no key found in _inputEventDict for this ");
            GD.PrintErr("event: "+inputEvent);
            return null;
        }


        public static bool IsKeyAlreadyUsed(InputEvent inputEvent, out string yesByThisAction)
        {
            yesByThisAction = null;
            foreach (var _action in GetMyActions())
            {
                foreach (var _event in InputMap.ActionGetEvents(_action))
                {
                    if (InputEventToString(inputEvent) == InputEventToString(_event))
                    {
                        // GD.Print(InputEventToString(inputEvent) + InputEventToString(_event));
                        yesByThisAction = _action;
                        return true;
                    }
                }
            }
            return false;
        } 


        public static List<string> GetMyActions()
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


        public static bool IsJoypadConnected()
        {
            /*
            ment to detect joypad connection and make game act on it
            not needed if keyboard and joypad connection in parallel is allowed
            */
            GD.Print("connected joy pads: " + Input.GetConnectedJoypads());
            GD.Print("is joypad connected? " + (Input.GetConnectedJoypads().Count > 0));
            return Input.GetConnectedJoypads().Count > 0;
        }
    }
}