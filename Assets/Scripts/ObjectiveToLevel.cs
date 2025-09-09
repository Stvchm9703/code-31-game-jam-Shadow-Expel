using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ObjectiveToLevel : MonoBehaviour
{
    
    public string scene;
   
    public void Continue()
    {
        SceneManager.LoadScene(scene);
    }
}
