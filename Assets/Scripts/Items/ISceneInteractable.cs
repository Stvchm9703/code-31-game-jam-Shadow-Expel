using UnityEngine;
public class ISceneInteractable : MonoBehaviour
{
    public virtual void Interact()
    {
        Debug.Log("Interacting with " + gameObject.name);
    }
}
    