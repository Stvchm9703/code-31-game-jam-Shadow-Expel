using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tutorial1_Dialog : MonoBehaviour
{
    public Teleport teleport;
    // Start is called before the first frame update
    void Start()
    {
        this.teleport.OnTeleports += () =>
        {
             this.gameObject.SetActive(false);
        };
    }
    
}
