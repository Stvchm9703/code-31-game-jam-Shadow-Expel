using System;
using System.Collections;
using System.Collections.Generic;
using Spine.Unity;
// using Survor.ActionMaps;
// using Survor.ECS.Bullet;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Playables;
using PrimeTween;

using Math = Unity.Physics.Math;

// namespace PlayerInputSet
// {
public enum PlayerState
{
    Idle,
    Move,
    Interact,
    Attack,
    SkillAttack1,
    SkillAttack2,
    SkillAttack3,
    Dead
}

public enum PlayerDirection
{
    Up,
    Down,
    Left,
    Right,
    UpLeft,
    UpRight,
    DownLeft,
    DownRight
}

// }
public class PlayerMoveInputController : MonoBehaviour
{
    private Rigidbody rb;

    // gamepad left side / left-side joystick / A, S, D, W
    private Vector3 RawMovementInput;

    // gamepad right side / right-side joystick / Mouse
    private Vector2 RawFacingDirection;

    // public AnimationPlayerControl animationPlayerControl;

    // private Collider GrandCollider;
    private Vector2 ScreenSize;
    private int jumpCount,
        maxJumpCount = 2;

    [SerializeField]
    private float dashGasCount = 3f,
        maxDashGasCount = 3f;

    [SerializeField]
    private bool isDodging,
        isDashing,
        isInReactingArea,
        isMoving,
        isRolling,
        isAttack;

    [SerializeField]
    private PlayerState playerState;

    private AnimationController animationController;

    // private BulletGeneratorMono bulletGeneratorMono;

    // Start is called before the first frame update

    private Camera mainCamera;
    private Transform _lightTransform;
    
    private readonly RaycastHit[] _spotLightRaycastHits = new RaycastHit[15];
    private Ray spotLightRay;
    public float spotLightRange = 7f;
    

    void Start()
    {
        rb = this.transform.GetComponent<Rigidbody>();
        animationController = this.transform.GetComponent<AnimationController>();
        // bulletGeneratorMono = this.transform.GetComponent<BulletGeneratorMono>();
        this._lightTransform = this.transform.Find("LampLight");
        // GrandCollider = this.transform.GetComponent<Collider>();
        this.ScreenSize = new Vector2(Screen.width, Screen.height);
        // Debug.Log("Screen Size : x" + this.ScreenSize);
        playerState = PlayerState.Idle;

        this.mainCamera = Camera.main;
        // onAnimatorInit();
        // onInputMapInit();
        this.spotLightRay = new Ray(this.transform.position, this.transform.forward);
    }

    IEnumerable Attack()
    {
        yield return new WaitForSeconds(0.5f);
        isAttack = false;
    }

    /**
        private void onAnimatorInit()
        {
            // animator init
            this.moving = gameObject.transform.Find("moving").gameObject;
            this.movingTransform = gameObject.transform.Find("moving");
            this.movingPlayer = this.moving.GetComponent<SkeletonAnimation>();
            this.movingPlayer.AnimationState.SetAnimation(0, "Relax", true);
    
            this.front = gameObject.transform.Find("front").gameObject;
            this.frontTransform = gameObject.transform.Find("front");
            this.frontPlayer = this.front.GetComponent<SkeletonAnimation>();
            this.front.SetActive(false);
    
            this.back = gameObject.transform.Find("back").gameObject;
            this.backTransform = gameObject.transform.Find("back");
            this.backPlayer = this.back.GetComponent<SkeletonAnimation>();
            this.back.SetActive(false);
        }
    
    */

    private InputAction moveAction,
        dashAction,
        battleAction,
        UIAction;

    // Update is called once per frame
    void Update()
    {
        if (RawMovementInput != Vector3.zero)
        {
            if (isDashing && dashGasCount > 0f)
            {
                // Dash
                this.transform.position +=
                    new Vector3(RawMovementInput.x, 0, RawMovementInput.z)
                    * Time.deltaTime
                    * (7.5f);
                dashGasCount -= Time.deltaTime;
            }
            else
            {
                // Move
                this.transform.position +=
                    new Vector3(RawMovementInput.x, 0, RawMovementInput.z) * Time.deltaTime * (2f);
                // Debug.Log("Move Event: x:"+ RawMovementInput.x + "  y:" +RawMovementInput.z);
            }
            this.spotLightRay.origin = this.transform.position;
        }
        if (!isDashing && dashGasCount < maxDashGasCount)
        {
            dashGasCount += Time.deltaTime;
        }

        DetectHitted();
        Debug.DrawRay(this.spotLightRay.origin, this.spotLightRay.direction * this.spotLightRange, Color.blue);

    }

    public void onMoveEvent(InputAction.CallbackContext context)
    {
        RawMovementInput = context.ReadValue<Vector3>();
        // var RawMovementInput2 = context.ReadValueAsButton();
        // Debug.Log("Move Event: x:" + RawMovementInput2);

        // Jumping
        if (context.performed)
        {
            // if (RawMovementInput.y > 0 && jumpCount < maxJumpCount)
            // {
            //     rb.AddForce(Vector3.up * 5, ForceMode.VelocityChange);
            //     jumpCount++;
            // }
            if (RawMovementInput.x == 0 && RawMovementInput.z == 0)
            {
                this.playerState = PlayerState.Idle;
            }
            else
            {
                this.playerState = PlayerState.Move;
            }
            this.UpdateAnimation();
        }
    }

    public void onDashEvent(InputAction.CallbackContext context)
    {
        float ctx = context.ReadValue<float>();
        // Debug.Log("Dash Event: " + ctx);
        // if (context.performed)
        // {
        if (ctx > 0)
        {
            isDashing = dashGasCount > 0f;
            isDodging = dashGasCount > 0f;
            AnimationSpeedChange(5f);
        }
        else
        {
            isDashing = false;
            isDodging = false;
            AnimationSpeedChange(1f);
        }
        // }
    }

    public virtual void DetectHitted()
    {
        // int hitsNum = Physics.RaycastNonAlloc(this.spotLightRay, this._spotLightRaycastHits, this.spotLightRange);
        // Debug.Log(hitsNum);
    }
    public void onLookEvent(InputAction.CallbackContext context)
    {
        // RawFacingDirection = context.ReadValue<Vector2>();
        var inputDevice = context.control.device;
        var ctx = context.ReadValue<Vector2>();
        float angle = 0;
        if (inputDevice == InputSystem.GetDevice<Mouse>())
        {
            Vector3 screenPos = this.mainCamera.WorldToScreenPoint(transform.position);
             angle = Mathf.Atan2(ctx.y - screenPos.y, ctx.x - screenPos.x);
        }
        else
        {
            // Gamepad
            angle = Mathf.Atan2(ctx.y, ctx.x);
        }

        // Tween.LocalPosition(this._lightTransform, new Vector3(ctx.x, this._lightTransform.localPosition.y, ctx.y), 0.5f);
        Tween.LocalRotation(this._lightTransform, new Vector3(0, angle * -Mathf.Rad2Deg, 0) , 0.5f);
        this.spotLightRay.direction = Quaternion.Euler(0,angle * -Mathf.Rad2Deg + 90 ,0) * transform.forward * this.spotLightRange;
        
    }

    /// <summary>
    /// Attack / Interact Event
    /// </summary>
    /// <param name="context"></param>
    public void onAttackEvent(InputAction.CallbackContext context)
    {
        float ctx = context.ReadValue<float>();
        // Debug.Log("Attack Event: " + ctx);

        // if (context.performed)
        // {
        if (ctx > 0)
        {
            isAttack = true;
            playerState = PlayerState.Attack;
            this._lightTransform.GetComponent<LightModeSwitch>().lightMode = 1;
        }
        else
        {
            isAttack = false;
            playerState = isMoving ? PlayerState.Move : PlayerState.Idle;
            this._lightTransform.GetComponent<LightModeSwitch>().lightMode = 0;
        }
        // StartCoroutine(Attack());
        if (context.performed)
        {
            this.UpdateAnimation();
        }
        // }
    }

    public void onSkillAttack1Event(InputAction.CallbackContext context)
    {
        // Debug.Log("SkillAttack1 Event: " + context.ReadValue<float>());
        float ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            isAttack = true;
            playerState = PlayerState.SkillAttack1;
        }
        else
        {
            isAttack = false;
            playerState = isMoving ? PlayerState.Move : PlayerState.Idle;
        }
        if (context.performed)
        {
            this.UpdateAnimation();
            // StartCoroutine(Attack());
            // bulletGeneratorMono.Shoot();
        }   
    }

    public void onSkillAttack2Event(InputAction.CallbackContext context)
    {
        float ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            isAttack = true;
            playerState = PlayerState.SkillAttack2;
        }
        else
        {
            isAttack = false;
            playerState = isMoving ? PlayerState.Move : PlayerState.Idle;
        }
        if (context.performed)
        {
            this.UpdateAnimation();
            // StartCoroutine(Attack());
        }
    }

    public void onSkillAttack3Event(InputAction.CallbackContext context)
    {
        float ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            isAttack = true;
            playerState = PlayerState.SkillAttack3;
        }
        else
        {
            isAttack = false;
            playerState = isMoving ? PlayerState.Move : PlayerState.Idle;
        }
        if (context.performed)
        {
            this.UpdateAnimation();
            // StartCoroutine(Attack());
        }
    }

    private void onSwitchEvent(InputAction.CallbackContext context) { }

    private void onBlockEvent(InputAction.CallbackContext context)
    {
        isAttack = false;
    }

    private void onMenuEvent(InputAction.CallbackContext context) { }

    private void onItemEvent(InputAction.CallbackContext context) { }

    private void OnCollisionEnter(Collision collision)
    {
        var hited = collision.gameObject;
        if (hited.tag == "WorldEndMapGround")
        {
            this.jumpCount = 0;
            this.transform.position = new Vector3(0, 0, 0);
            return;
        }
        if (hited.tag == "MapGround")
            jumpCount = 0;
    }

    /// <summary>
    ///  AnimationController Wrapper
    /// </summary>
    ///


    void UpdateAnimation() =>
        animationController.UpdateAnimation(isAttack, GetDirectionState(), playerState);

    void AnimationSpeedChange(float speed) => animationController.SpeedChange(speed);

    public PlayerDirection GetDirectionState()
    {
        if (RawMovementInput.x > -1 && RawMovementInput.z > 0)
        {
            // up right
            return PlayerDirection.UpRight;
        }
        else if (RawMovementInput.z > 0)
        {
            // up left
            return PlayerDirection.UpLeft;
        }
        else if (RawMovementInput.x < 0 && RawMovementInput.z < 1)
        {
            // down left
            return PlayerDirection.DownLeft;
        }
        else if (RawMovementInput.z < 1)
        {
            // down right
            return PlayerDirection.DownRight;
        }
        return PlayerDirection.DownRight;
    }
}
