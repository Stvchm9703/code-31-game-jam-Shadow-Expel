using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public void PlayGame()
    {
        SceneManager.LoadScene("LevelSelection");
    }

    public void Instructions()
    {
        SceneManager.LoadScene("Instructions");
    }

    public void LevelSelect()

    {
        SceneManager.LoadScene("LevelSelection");

    }
    public void QuitGame()
    {
        Application.Quit();
    }
}
