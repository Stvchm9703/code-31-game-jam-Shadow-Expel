using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PrimeTween;
using UnityEngine;
using UnityEngine.InputSystem;

// using Survor.ActionMaps;
// using Survor.ECS.Bullet;

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
    // public AnimationPlayerControl animationPlayerControl;

    // private Collider GrandCollider;
    // private Vector2 ScreenSize;

    // private int jumpCount,
    //     maxJumpCount = 2;
    // public int attackDamage = 1;


    [SerializeField]
    public float dashGasCount = 3f,
        maxDashGasCount = 3f;

    [SerializeField]
    private bool isDodging,
        isDashing,
        isMoving,
        isAttack;

    [SerializeField]
    private PlayerState playerState;

    public float spotLightRange = 7f;

    public AnimationController _animationController;

    [SerializeField]
    private List<GameObject> itemTouched;

    // gamepad right side / right-side joystick / Mouse
    [SerializeField]
    private float _rawFacingAngle;

    private readonly RaycastHit[] _closeRaycastHits = new RaycastHit[15];

    private readonly RaycastHit[] _spotLightRaycastHits = new RaycastHit[15];

    private Transform _lightTransform;
    // private bool _isItemTouched;

    private Camera _mainCamera;

    /**
     * * private void onAnimatorInit()a
     * * {
     * * // animator init
     * * this.moving = gameObject.transform.Find("moving").gameObject;
     * * this.movingTransform = gameObject.transform.Find("moving");
     * * this.movingPlayer = this.moving.GetComponent
     * <SkeletonAnimation>
     *     ();
     *     this.movingPlayer.AnimationState.SetAnimation(0, "Relax", true);
     *     this.front = gameObject.transform.Find("front").gameObject;
     *     this.frontTransform = gameObject.transform.Find("front");
     *     this.frontPlayer = this.front.GetComponent
     *     <SkeletonAnimation>
     *         ();
     *         this.front.SetActive(false);
     *         * this.back = gameObject.transform.Find("back").gameObject;
     *         * this.backTransform = gameObject.transform.Find("back");
     *         * this.backPlayer = this.back.GetComponent
     *         <SkeletonAnimation>
     *             ();
     *             * this.back.SetActive(false);
     *             *}
     */
    private InputAction _moveAction,
        _dashAction,
        _battleAction,
        _uiAction;

    private PlayerInventoryController _playerInventoryController;

    // gamepad left side / left-side joystick / A, S, D, W
    private Vector3 _rawMovementInput;
    // private Ray _spotLightRay;

    private PlayerSoundFXController _soundFXController;

    // private UIController _uiController;
    // private Rigidbody rb;

    // private int activeToolIndex = 0; // 0 : none, 1 : lamp, 2 : sword
    // private bool isPaused => GameStateManager.Instance.CurrentGameState == GameState.Paused;
    private bool isPaused;

    private void Start()
    {
        // this.rb = this.transform.GetComponent<Rigidbody>();
        Transform transform1 = this.transform;
        if (this._animationController == null) this._animationController = transform1.GetComponent<AnimationController>();
        this._playerInventoryController = transform1.GetComponent<PlayerInventoryController>();
        this._soundFXController = transform1.GetComponent<PlayerSoundFXController>();
        
        this._lightTransform = transform1.Find("LampLight");
        this.playerState = PlayerState.Idle;
        this._mainCamera = Camera.main;
        // onAnimatorInit();
        // onInputMapInit();
        // this._spotLightRay = new Ray(transform1.position, transform1.forward);
        GameStateManager.Instance.OnGameStateChanged += this.onGameStateChanged;
    }

    // Update is called once per frame
    private void FixedUpdate()
    {
        if (this.isPaused) return;
        this.MovementUpdate(Time.fixedDeltaTime);
        // if (this.isAttack) this.DetectHitted();
        this.DetechItem();
        // Debug.DrawRay(this._spotLightRay.origin, this._spotLightRay.direction * this.spotLightRange, Color.blue);
        // this.CheckAtiveTool();
    }

    private void OnDestroy()
    {
        GameStateManager.Instance.OnGameStateChanged -= this.onGameStateChanged;
    }

    private void OnCollisionEnter(Collision collision)
    {
        GameObject hited = collision.gameObject;
        if (hited.CompareTag("WorldEndMapGround"))
            this.transform.position = new Vector3(0, 0, 0);
        // if (hited.CompareTag("Item"))
        // {
        //     Debug.Log("Item Touched: " + hited.name);
        //     if (!this._itemTouched.Contains(hited))  this._itemTouched.Add(hited);
        // }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(this.transform.position, 1.5f);
    }

    public void onGameStateChanged(GameState newGameState)
    {
        if (newGameState == GameState.Paused || newGameState == GameState.InventoryMenu)
        {
            this._animationController.Pause();
            this.isPaused = true;
        }
        else if (newGameState == GameState.InGame)
        {
            this._animationController.Resume();
            this.isPaused = false;
        }
    }

    // private IEnumerable Attack()
    // {
    //     yield return new WaitForSeconds(0.5f);
    //     this.isAttack = false;
    // }

    private void MovementUpdate(float deltaTime = 0.02f)
    {
        if (this._rawMovementInput != Vector3.zero)
        {
            if (this.isDashing && this.dashGasCount > 0f)
            {
                // Dash
                this.transform.position +=
                    new Vector3(this._rawMovementInput.x, 0, this._rawMovementInput.z)
                    * (deltaTime * 7.5f);
                this.dashGasCount = Math.Clamp(this.dashGasCount - deltaTime, 0, this.maxDashGasCount);
            }
            else
            {
                // Move
                this.transform.position +=
                    new Vector3(this._rawMovementInput.x, 0, this._rawMovementInput.z) * (deltaTime * 2f);
                // Debug.Log("Move Event: x:"+ RawMovementInput.x + "  y:" +RawMovementInput.z);
            }

            // this._spotLightRay.origin = this.transform.position;
        }

        if (!this.isDashing && this.dashGasCount < this.maxDashGasCount)
            this.dashGasCount = Math.Clamp(this.dashGasCount + deltaTime, 0, this.maxDashGasCount);

        Tween.LocalRotation(this._lightTransform, new Vector3(0, -1 * this._rawFacingAngle, 0), 0.5f);
        // this._spotLightRay.direction = Quaternion.Euler(0,  -1 * this._rawFacingAngle, 0) * this.transform.right * this.spotLightRange;
        // Debug.DrawRay(this._spotLightRay.origin, this._spotLightRay.direction, Color.blue);
    }

    public void onMove(InputAction.CallbackContext context)
    {
        this._rawMovementInput = context.ReadValue<Vector3>();

        // Jumping
        //
        //

        if (this._rawMovementInput.x == 0 && this._rawMovementInput.z == 0)
            this.playerState = PlayerState.Idle;
        else
            this.playerState = PlayerState.Move;

        this.UpdateAnimation();
        this._soundFXController.PlaySoundFX(SoundFXType.Walk);
    }

    public void onDash(InputAction.CallbackContext context)
    {
        var ctx = context.ReadValue<float>();
        // Debug.Log("Dash Event: " + ctx);
        // if (context.performed)
        // {
        if (ctx > 0)
        {
            this.isDashing = this.dashGasCount > 0f;
            this.isDodging = this.dashGasCount > 0f;
            this.AnimationSpeedChange(5f);
            this._soundFXController.PlaySoundFX(SoundFXType.Dash);
        }
        else
        {
            this.isDashing = false;
            this.isDodging = false;
            this.AnimationSpeedChange(1f);
        }
        // }
    }



    // public virtual void DetectHitted()
    // {
    //     // set as cone cast
    //     int hitsNumInRange = Physics.SphereCastNonAlloc(
    //         this._spotLightRay,
    //         this.spotLightRange,
    //         this._spotLightRaycastHits,
    //         this.spotLightRange,
    //         LayerMask.GetMask("monster")
    //     );
    //     //
    //
    //
    //
    //     if (hitsNumInRange > 0)
    //         foreach (RaycastHit hitted in this._spotLightRaycastHits)
    //         {
    //             if (!hitted.collider) continue;
    //
    //             Vector3 directionToHit = hitted.point - this._spotLightRay.origin;
    //             float angleToHit = Vector2.Angle(
    //                 new Vector2(_spotLightRay.direction.x , this._spotLightRay.direction.z),
    //                 Vector2.right
    //             );
    //             // float angleN = Vector2.Angle(this._spotLightRay.direction, this.transform.position );
    //             float angleToHitA = Vector2.Angle(
    //                 new Vector2( directionToHit.normalized.x , directionToHit.normalized.z),
    //                 Vector2.right
    //             );
    //             // float angle = Vector3.Angle(this._spotLightRay.direction, this.transform.position );
    //             // Debug.Log("possible hitted: " + directionToHit + "  norm: " + directionToHit.normalized);
    //             // Debug.Log("orig hitted: " + this._spotLightRay.direction + "  norm: " + this._spotLightRay.direction.normalized);
    //             Debug.Log("angleToHit : " + Math.Abs(angleToHit - angleToHitA));
    //             Debug.Log("angleToHit : " + angleToHit + " "+ angleToHitA);
    //             // Debug.Log("raw_angle: " + this._rawFacingAngle);
    //             // Debug.Log("Hitted: " + hitted.collider.gameObject.name + "  angle: " + angleToHit + "  raw_angle: " + this._rawFacingAngle);
    //
    //             if( Math.Abs(angleToHit - angleToHitA) <= 30f)
    //             {
    //                 var enemyBehaviour = hitted.collider.gameObject.GetComponent<IEnemyDetectBehaviour>();
    //                 if (enemyBehaviour) enemyBehaviour.TakeDamage(this.attackDamage);
    //             }
    //         }
    // }

    private void DetechItem()
    {
        int closeHitsNum = Physics.SphereCastNonAlloc(
            this.transform.position,
            1.5f,
            this.transform.forward,
            this._closeRaycastHits,
            1.5f,
            LayerMask.GetMask("items", "interactable")
        );
        if (closeHitsNum > 0)
            this.itemTouched = this._closeRaycastHits
                .Where(rh => rh.collider && rh.collider.gameObject)
                .Select(
                    rh => rh.collider.gameObject
                )
                .ToList();
        else
            this.itemTouched.Clear();
    }

    public void onLook(InputAction.CallbackContext context)
    {
        // RawFacingDirection = context.ReadValue<Vector2>();
        var ctx = context.ReadValue<Vector2>();
        float angle;
        if (context.control.device == InputSystem.GetDevice<Mouse>())
        {
            Vector3 screenPos = this._mainCamera.WorldToScreenPoint(this.transform.position);
            angle = Mathf.Atan2(ctx.y - screenPos.y, ctx.x - screenPos.x);
        }
        else
        {
            // Gamepad
            angle = Mathf.Atan2(ctx.y, ctx.x);
        }

        // Tween.LocalPosition(this._lightTransform, new Vector3(ctx.x, this._lightTransform.localPosition.y, ctx.y), 0.5f);
        this._rawFacingAngle = Mathf.Rad2Deg * angle;
        this.UpdateAnimation();
    }

    /// <summary>
    ///     Attack / Interact Event
    /// </summary>
    /// <param name="context"></param>
    public void onAttackInteract(InputAction.CallbackContext context)
    {
        var ctx = context.ReadValue<float>();
        if (this.itemTouched.Count > 0)
            this.InteractAction(context, ctx);
        else
            this.AttackAction(context, ctx);
    }

    private void AttackAction(InputAction.CallbackContext context, float ctx)
    {
        if (ctx > 0)
        {
            this.isAttack = true;
            this.playerState = PlayerState.Attack;
            this._lightTransform.GetComponent<LightModeSwitch>().SwitchLightMode(1);
            this._soundFXController.PlaySoundFX(SoundFXType.Attack);
        }
        else
        {
            this.isAttack = false;
            this.playerState = this.isMoving
                ? PlayerState.Move
                : PlayerState.Idle;
            this._lightTransform.GetComponent<LightModeSwitch>().SwitchLightMode(0);
        }

        if (context.performed) this.UpdateAnimation();
        
    }

    private void InteractAction(InputAction.CallbackContext context, float ctx)
    {
        if (ctx > 0 && context.performed)
            // this.isAttack = true;
            // this.playerState = PlayerState.Interact;
            // this._lightTransform.GetComponent<LightModeSwitch>().lightMode = 2;
            foreach (GameObject item in this.itemTouched)
            {
                var itemDataRef = item.GetComponent<ItemDataRef>();
                if (itemDataRef != null)
                {
                    this._playerInventoryController.AddItem(itemDataRef.itemData);
                    Destroy(item);
                    continue;
                }

                var interactable = item.GetComponent<ISceneInteractable>();
                if (interactable != null) interactable.Interact();
            }
    }

    // public void OnSkillAttack1Event(InputAction.CallbackContext context)
    // {
    //     // Debug.Log("SkillAttack1 Event: " + context.ReadValue<float>());
    //     var ctx = context.ReadValue<float>();
    //     if (ctx > 0)
    //     {
    //         this.isAttack = true;
    //         this.playerState = PlayerState.SkillAttack1;
    //     }
    //     else
    //     {
    //         this.isAttack = false;
    //         this.playerState = this.isMoving
    //             ? PlayerState.Move
    //             : PlayerState.Idle;
    //     }
    //
    //     if (context.performed) this.UpdateAnimation();
    //     // StartCoroutine(Attack());
    //     // bulletGeneratorMono.Shoot();
    // }
    //
    // public void OnSkillAttack2Event(InputAction.CallbackContext context)
    // {
    //     var ctx = context.ReadValue<float>();
    //     if (ctx > 0)
    //     {
    //         this.isAttack = true;
    //         this.playerState = PlayerState.SkillAttack2;
    //     }
    //     else
    //     {
    //         this.isAttack = false;
    //         this.playerState = this.isMoving
    //             ? PlayerState.Move
    //             : PlayerState.Idle;
    //     }
    //
    //     if (context.performed) this.UpdateAnimation();
    //     // StartCoroutine(Attack());
    // }
    //
    // public void OnSkillAttack3Event(InputAction.CallbackContext context)
    // {
    //     var ctx = context.ReadValue<float>();
    //     if (ctx > 0)
    //     {
    //         this.isAttack = true;
    //         this.playerState = PlayerState.SkillAttack3;
    //     }
    //     else
    //     {
    //         this.isAttack = false;
    //         this.playerState = this.isMoving
    //             ? PlayerState.Move
    //             : PlayerState.Idle;
    //     }
    //
    //     if (context.performed) this.UpdateAnimation();
    //     // StartCoroutine(Attack());
    // }
    //
    // private void OnSwitchEvent(InputAction.CallbackContext context)
    // {
    // }
    //
    // private void OnBlockEvent(InputAction.CallbackContext context)
    // {
    //     this.isAttack = false;
    // }

    // public void OnMenu(InputAction.CallbackContext context)
    // {
    //     var ctx = context.ReadValue<float>();
    //     if (context.performed && ctx > 0)
    //     {
    //         this._uiController.PauseGame();
    //     }
    // }

    public void onItem(InputAction.CallbackContext context)
    {
    }

    /// <summary>
    ///     AnimationController Wrapper
    /// </summary>
    private void UpdateAnimation()
    {
        this._animationController.UpdateAnimation(this.isAttack, this.GetDirectionState(), this.playerState);
    }

    private void AnimationSpeedChange(float speed)
    {
        this._animationController.SpeedChange(speed);
    }

    public PlayerDirection GetDirectionState()
    {
        // up
        // up right
        if (this._rawFacingAngle > 0 && this._rawFacingAngle <= 90)
            return PlayerDirection.UpRight;

        // up left
        if (this._rawFacingAngle > 90 && this._rawFacingAngle <= 180)
            return PlayerDirection.UpLeft;
        // down left
        if (this._rawFacingAngle > -180 && this._rawFacingAngle <= -90)
            return PlayerDirection.DownLeft;
        // down right

        if (this._rawFacingAngle > -90 && this._rawFacingAngle <= 0)
            return PlayerDirection.DownRight;

        return PlayerDirection.DownRight;
    }
}
