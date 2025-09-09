using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;
using UnityEngine.SceneManagement;

public class UIController : MonoBehaviour
{
    public GameObject pauseMenu;
    public GameObject gameOverScreen;
    public  GameObject invertoryMenu;
    // Start is called before the first frame update
    // public bool isPaused = false;
    
    public PlayerInput playerInput;
    public InputSystemUIInputModule inputModule;
    public GameState lastGameState;
    
    void Awake()
    {
        GameStateManager.Instance.OnGameStateChanged += OnGameStateChanged;
        // playerInput = GameObject.FindObjectOfType<PlayerInput>();

        OnGameStateChanged(GameStateManager.Instance.CurrentGameState);
    }

    void OnDestroy()
    {
        GameStateManager.Instance.OnGameStateChanged -= OnGameStateChanged;
    }
    
    void OnGameStateChanged(GameState newGameState)
    {
        if (newGameState == GameState.GameOver)
        {
            if (this.gameOverScreen) gameOverScreen.SetActive(true);
        }
        else if (newGameState == GameState.Paused)
        {
            Debug.Log("Pause Game start");
            pauseMenu.SetActive(true);
            // this.playerInput.SwitchCurrentActionMap("UI");
        }
        
        else if (newGameState == GameState.InGame)
        {
            Debug.Log("Pause Game resume");
           if (this.gameOverScreen) gameOverScreen.SetActive(false);
            pauseMenu.SetActive(false);
            // this.playerInput.SwitchCurrentActionMap("main_action");
        }
        
        else if (newGameState == GameState.InventoryMenu)
        {
            Debug.Log("Pause Game resume");
            // gameOverScreen.SetActive(false);
            pauseMenu.SetActive(false);
            invertoryMenu.SetActive(true);
            // this.playerInput.SwitchCurrentActionMap("UI");
            

            // this.playerInput.SwitchCurrentActionMap("inventory_menu");
        }
    }


    public void PauseGame()
    {
        GameState currentGameState = GameStateManager.Instance.CurrentGameState;
        GameState newGameState = currentGameState == GameState.InGame
            ? GameState.Paused
            : GameState.InGame;
        GameStateManager.Instance.SetState(newGameState);
        
    }


    public void OnPause(InputAction.CallbackContext context)
    {
        Debug.Log("PauseGame");
        
        var value = context.ReadValue<float>();
        
        Debug.Log("PauseGame value : " + value);
        
        if (context.performed && value == 0f)
        {
            PauseGame();
        }
    }

    public void Echo()
    {
        Debug.Log("Echo : Hello World");
    }
    
    public void LevelSelect()
    {
        SceneManager.LoadScene("LevelSelection");
    }
    
    public void ManiMenu()
    {
        SceneManager.LoadScene("MainMenu");
    }
    
    public void Quit()
    {
        Application.Quit();
    }
}
