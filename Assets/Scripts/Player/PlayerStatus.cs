using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerStatus : MonoBehaviour
{
    // Add your member variables and properties here
    public float health, maxHealth;
    public int attack;
    public int speed;
    public PlayerMoveInputController playerMoveInputController;
    public StatusAnimationController statusAnimationController;
    public float dashPercent => (float) Math.Round( playerMoveInputController.dashGasCount / playerMoveInputController.maxDashGasCount , 2);
    // Add your methods and event handlers here
    

    private void Start()
    {
        if (this.playerMoveInputController == null)
        {
            this.playerMoveInputController = this.GetComponent<PlayerMoveInputController>();
        }
    }

    private void FixedUpdate()
    {
        // Update the status bars
        statusAnimationController.UpdateHpBar((float) health / maxHealth);
        statusAnimationController.UpdateDashBar(this.dashPercent);
        
    }
    
    public void TakeDamage(float damage)
    {
        
        this.health -= damage;
        if (this.health <= 0)
        {
            // this.Die();
        }
    }
}
