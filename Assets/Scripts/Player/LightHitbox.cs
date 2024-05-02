using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightHitbox : MonoBehaviour
{
    GameObject _player;

    private void Start()
    {
        this._player = GameObject.FindWithTag("Player");
    }

    private void OnTriggerEnter(Collider colliser)
    {
        if (colliser.gameObject.CompareTag("Monster"))
        {
            var enemyDetect = colliser.gameObject.GetComponent<IEnemyDetectBehaviour>();
            if (this._player)
            {
                var playerMI = this._player.GetComponent<PlayerStatus>();
                enemyDetect.TakeDamage(playerMI.attack);
            }
        
        }
    }
}
