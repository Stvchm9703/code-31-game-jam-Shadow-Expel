using UnityEngine.InputSystem;

// using UnityEngine.InputSystem.InputAction;

namespace Survor.ActionMaps
{
  /**
  BattleInputMap is a class that contains all the input actions for the battle scene.

  
  Key W = Move Forward
  Key S = Move Backward
  Key A = Move Left
  Key D = Move Right
  Key Space = Jump
  Key Z = Dodge / Roll 
  Key Shift = Dash + 

  Key Q = Switch Weapon
  Key E = Memu
  Key B = Block
  Key H = Attack / Interact
  Key J = Skill 1
  Key K = Skill 2
  Key L = Skill 3

  
  */

    public static class InputMapPC
    {
    
      public static InputAction GetMoveProfile()
      {
            InputAction action = new InputAction("MoveProfile");
            // PC Keyboard
            action.AddCompositeBinding("3DVector")
                  .With("Forward",    "<Keyboard>/w")
                  .With("Backward",   "<Keyboard>/s")
                  .With("Left",       "<Keyboard>/a")
                  .With("Right",      "<Keyboard>/d")
                  .With("Up",         "<Keyboard>/space") // jump
                  .With("Down",       "<Keyboard>/z");
                  
            // Gamepad
            action.AddCompositeBinding("3DVector(mode=2)")
                  .With("Forward",    "<Gamepad>/leftStick/up")
                  .With("Backward",   "<Gamepad>/leftStick/down")
                  .With("Left",       "<Gamepad>/leftStick/left")
                  .With("Right",      "<Gamepad>/leftStick/right")
                  .With("Up",         "<Gamepad>/leftStickButton") // jump
                  .With("Down",       "<Gamepad>/crossButton");
            return action;
      }
      public static InputAction GetDashProfile()
      {
            InputAction action = new InputAction("DashProfile");
            action.AddBinding("<Keyboard>/leftShift" /** dash */);
            action.AddBinding("<Gamepad>/leftStickButton" /** dash */);
            return action;
      }

      public static InputAction GetBattleProfile()
      {
            InputAction action = new InputAction("BattleProfile");
            // PC Keyboard
            action.AddBinding("<Keyboard>/q" /** switch  */);
            action.AddBinding("<Keyboard>/e" /** menu */);
            action.AddBinding("<Keyboard>/b" /** block */);
            action.AddBinding("<Keyboard>/h" /** attack / interact */);
            action.AddBinding("<Keyboard>/j" /** skill 1 */);
            action.AddBinding("<Keyboard>/k" /** skill 2 */);
            action.AddBinding("<Keyboard>/l" /** skill 3 */);
            action.AddBinding("<Keyboard>/u" /** item */);
            // Gamepad
            action.AddBinding("<Gamepad>/startButton" /** menu */);

            // action.AddCompositeBinding("<Gamepad>/buttonEast" /**  circleButton attack / interact */)
            //       .With("Modifier", "<Gamepad>/rightShoulder" /** switch */);
            
            // action.AddCompositeBinding("<Gamepad>/buttonNorth" /** triangleButton , skill 1 */)
            //       .With("Modifier", "<Gamepad>/rightShoulder"/** skill 2 */);

            // action.AddCompositeBinding("<Gamepad>/buttonWest" /**squareButton, item */)
            //       .With("Modifier", "<Gamepad>/rightShoulder" /** skill 3 */);

            // action.AddCompositeBinding("<Gamepad>/buttonSouth" /** crossButtion down */ )
            //       .With("Modifier", "<Gamepad>/rightShoulder" /** block */);
            return action;
        }

        public static InputAction GetUIProfile()
        {
            InputAction action = new InputAction();

            return action;
        }
    }
    public static class InputMapPS4
    {
      public static InputAction GetMoveProfile()
        {
            InputAction action = new InputAction("MoveProfile");
      
            // Gamepad
            action.AddCompositeBinding("3DVector(mode=2)")
                  .With("Forward",    "<Gamepad>/leftStick/up")
                  .With("Backward",   "<Gamepad>/leftStick/down")
                  .With("Left",       "<Gamepad>/leftStick/left")
                  .With("Right",      "<Gamepad>/leftStick/right")
                  .With("Up",         "<Gamepad>/leftStickButton") // jump
                  .With("Down",       "<Gamepad>/crossButton");

            action.AddBinding("<Gamepad>/leftStickButton" /** dash */);
            return action;
        }

        public static InputAction GetBattleProfile()
        {
            InputAction action = new InputAction("BattleProfile");

            // Gamepad
            action.AddBinding("<Gamepad>/startButton" /** menu */);

            action.AddCompositeBinding("<Gamepad>/buttonEast" /**  circleButton attack / interact */)
                  .With("Modifier", "<Gamepad>/rightShoulder" /** switch */);
            
            action.AddCompositeBinding("<Gamepad>/buttonNorth" /** triangleButton , skill 1 */)
                  .With("Modifier", "<Gamepad>/rightShoulder"/** skill 2 */);

            action.AddCompositeBinding("<Gamepad>/buttonWest" /**squareButton, item */)
                  .With("Modifier", "<Gamepad>/rightShoulder" /** skill 3 */);

            action.AddCompositeBinding("<Gamepad>/buttonSouth" /** crossButtion down */ )
                  .With("Modifier", "<Gamepad>/rightShoulder" /** block */);
            return action;
        }

        public static InputAction GetUIProfile()
        {
            InputAction action = new InputAction();

            return action;
        }
    }
}
