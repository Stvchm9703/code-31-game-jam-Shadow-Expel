using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Rendering.Universal;

public class Teleport : MonoBehaviour
{
    public Transform target;
    public BoxCollider cameraBounds;
    public CinemachineConfiner cameraConfiner;
    GameObject player;
    // Start is called before the first frame update
    void Start()
    {
        this.player = GameObject.FindWithTag("Player");    
    }

    // Update is called once per frame
    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject == player)
        {
            player.transform.position = target.position;
            cameraConfiner.m_BoundingVolume = cameraBounds;
        }
    }
}