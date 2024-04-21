using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleInteractBehaviour : ISceneInteractable
{
    // Start is called before the first frame update
    public void Echo() {
        Debug.Log("Echo from SampleInteractBehaviour");
    }
}
