using Unity.Cinemachine;
using UnityEngine;

public class Teleport : MonoBehaviour
{
    public Transform target;
    public BoxCollider cameraBounds;
    public CinemachineConfiner cameraConfiner;

    private GameObject player;

    public delegate void TeleportAction();

    public event TeleportAction OnTeleports;

    // Start is called before the first frame update
    private void Start()
    {
        this.player = GameObject.FindWithTag("Player");
    }

    // Update is called once per frame
    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject == this.player)
        {
            this.player.transform.position = this.target.position;
            this.cameraConfiner.m_BoundingVolume = this.cameraBounds;
            this.OnTeleports?.Invoke();
        }
    }
}