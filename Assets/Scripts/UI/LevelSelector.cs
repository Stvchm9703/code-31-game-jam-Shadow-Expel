using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelSelector : MonoBehaviour
{
    public void Level0()
    {
        SceneManager.LoadScene("Level 0 Objective");
    }

    public void Level1()
    {
    }

    public void Level2()
    {
        SceneManager.LoadScene("Level 2 Objective 1");
    }

    public void Level3()
    {
        SceneManager.LoadScene("Level 3 Objective 2");
    }
}