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
        if (this.health <= 0)
        {
            GameStateManager.Instance.SetState(GameState.GameOver);
        }
    }
    
    public void TakeDamage(float damage)
    {
        Debug.Log("Player take damage");
        this.health -= damage;
       
    }
}
