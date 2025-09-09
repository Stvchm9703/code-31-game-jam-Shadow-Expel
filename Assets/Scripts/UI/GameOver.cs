using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOver : MonoBehaviour
{

    public void Yes()
    {
        var t = SceneManager.GetActiveScene();
        SceneManager.LoadScene(t.name);
        GameStateManager.Instance.SetState(GameState.InGame);
    }

    public void No()
    { SceneManager.LoadScene("MainMenu"); }

}
