using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Level0Exit : ISceneInteractable
{
   public override void Interact()
   {
       Debug.Log("Interacting with Level0Exit " + gameObject.name);
       // GameStateManager.Instance.SetState(GameState.GameOver);
       SceneManager.LoadScene("Level 2 Objective 1");
   }
}
