using System.Collections;
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
    public int attackDamage = 1;
    

    [SerializeField]
    private float dashGasCount = 3f,
        maxDashGasCount = 3f;

    [SerializeField]
    private bool isDodging,
        isDashing,
        isMoving,
        isAttack;

    [SerializeField]
    private PlayerState playerState;

    public float spotLightRange = 7f;

    private readonly RaycastHit[] _spotLightRaycastHits = new RaycastHit[15];
    private Transform _lightTransform;
    private Ray _spotLightRay;

    private AnimationController _animationController;

    // private BulletGeneratorMono bulletGeneratorMono;

    // Start is called before the first frame update

    private Camera _mainCamera;

    /**
     * private void onAnimatorInit()
     * {
     * // animator init
     * this.moving = gameObject.transform.Find("moving").gameObject;
     * this.movingTransform = gameObject.transform.Find("moving");
     * this.movingPlayer = this.moving.GetComponent<SkeletonAnimation>();
       this.movingPlayer.AnimationState.SetAnimation(0, "Relax", true);
       this.front = gameObject.transform.Find("front").gameObject;
       this.frontTransform = gameObject.transform.Find("front");
       this.frontPlayer = this.front.GetComponent<SkeletonAnimation> ();
       this.front.SetActive(false);
     * this.back = gameObject.transform.Find("back").gameObject;
     * this.backTransform = gameObject.transform.Find("back");
     * this.backPlayer = this.back.GetComponent<SkeletonAnimation>();
     * this.back.SetActive(false);
     *}
     */
    private InputAction _moveAction,
        _dashAction,
        _battleAction,
        _uiAction;

    // gamepad right side / right-side joystick / Mouse
    private Vector2 _rawFacingDirection;

    // gamepad left side / left-side joystick / A, S, D, W
    private Vector3 _rawMovementInput;
    // private Rigidbody rb;


    private void Start()
    {
        // this.rb = this.transform.GetComponent<Rigidbody>();
        this._animationController = this.transform.GetComponent<AnimationController>();
        this._lightTransform = this.transform.Find("LampLight");
        this.playerState = PlayerState.Idle;

        this._mainCamera = Camera.main;
        // onAnimatorInit();
        // onInputMapInit();
        this._spotLightRay = new Ray(this.transform.position, this.transform.forward);
    }

    // Update is called once per frame
    private void FixedUpdate()
    {
        this.MovementUpdate(Time.deltaTime);
        if (this.isAttack) this.DetectHitted();
        Debug.DrawRay(this._spotLightRay.origin, this._spotLightRay.direction * this.spotLightRange, Color.blue);
    }

    private void OnCollisionEnter(Collision collision)
    {
        GameObject hited = collision.gameObject;
        if (hited.CompareTag("WorldEndMapGround"))
            this.transform.position = new Vector3(0, 0, 0);

        // if (hited.tag == "MapGround")
        //     jumpCount = 0;
    }

    private IEnumerable Attack()
    {
        yield return new WaitForSeconds(0.5f);
        this.isAttack = false;
    }

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
                this.dashGasCount -= deltaTime;
            }
            else
            {
                // Move
                this.transform.position +=
                    new Vector3(this._rawMovementInput.x, 0, this._rawMovementInput.z) * (deltaTime * 2f);
                // Debug.Log("Move Event: x:"+ RawMovementInput.x + "  y:" +RawMovementInput.z);
            }

            this._spotLightRay.origin = this.transform.position;
        }

        if (!this.isDashing && this.dashGasCount < this.maxDashGasCount) this.dashGasCount += deltaTime;
    }

    public void onMoveEvent(InputAction.CallbackContext context)
    {
        this._rawMovementInput = context.ReadValue<Vector3>();
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
            if (this._rawMovementInput.x == 0 && this._rawMovementInput.z == 0)
                this.playerState = PlayerState.Idle;
            else
                this.playerState = PlayerState.Move;

            this.UpdateAnimation();
        }
    }

    public void onDashEvent(InputAction.CallbackContext context)
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
        }
        else
        {
            this.isDashing = false;
            this.isDodging = false;
            this.AnimationSpeedChange(1f);
        }
        // }
    }

    public virtual void DetectHitted()
    {
        int hitsNum = Physics.RaycastNonAlloc(
            this._spotLightRay,
            this._spotLightRaycastHits,
            this.spotLightRange,
            LayerMask.GetMask("monster")
        );
        if (hitsNum > 0)
            foreach (RaycastHit hitted in this._spotLightRaycastHits)
            {
                if (!hitted.collider) continue;
                var enemyBehaviour = hitted.collider.gameObject.GetComponent<IEnemyDetectBehaviour>();
                if (enemyBehaviour)
                {
                    enemyBehaviour.TakeDamage(this.attackDamage);
                }
            }
    }

    public void onLookEvent(InputAction.CallbackContext context)
    {
        // RawFacingDirection = context.ReadValue<Vector2>();
        InputDevice inputDevice = context.control.device;
        var ctx = context.ReadValue<Vector2>();
        float angle = 0;
        if (inputDevice == InputSystem.GetDevice<Mouse>())
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
        Tween.LocalRotation(this._lightTransform, new Vector3(0, angle * -Mathf.Rad2Deg, 0), 0.5f);
        this._spotLightRay.direction = Quaternion.Euler(0, angle * -Mathf.Rad2Deg + 90, 0) * this.transform.forward * this.spotLightRange;
    }

    /// <summary>
    ///     Attack / Interact Event
    /// </summary>
    /// <param name="context"></param>
    public void onAttackEvent(InputAction.CallbackContext context)
    {
        var ctx = context.ReadValue<float>();
        // Debug.Log("Attack Event: " + ctx);

        // if (context.performed)
        // {
        if (ctx > 0)
        {
            this.isAttack = true;
            this.playerState = PlayerState.Attack;
            this._lightTransform.GetComponent<LightModeSwitch>().lightMode = 1;

            // activate the light racast 
        }
        else
        {
            this.isAttack = false;
            this.playerState = this.isMoving
                ? PlayerState.Move
                : PlayerState.Idle;
            this._lightTransform.GetComponent<LightModeSwitch>().lightMode = 0;
        }

        // StartCoroutine(Attack());
        if (context.performed) this.UpdateAnimation();
        // }
    }

    public void onSkillAttack1Event(InputAction.CallbackContext context)
    {
        // Debug.Log("SkillAttack1 Event: " + context.ReadValue<float>());
        var ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            this.isAttack = true;
            this.playerState = PlayerState.SkillAttack1;
        }
        else
        {
            this.isAttack = false;
            this.playerState = this.isMoving
                ? PlayerState.Move
                : PlayerState.Idle;
        }

        if (context.performed) this.UpdateAnimation();
        // StartCoroutine(Attack());
        // bulletGeneratorMono.Shoot();
    }

    public void onSkillAttack2Event(InputAction.CallbackContext context)
    {
        var ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            this.isAttack = true;
            this.playerState = PlayerState.SkillAttack2;
        }
        else
        {
            this.isAttack = false;
            this.playerState = this.isMoving
                ? PlayerState.Move
                : PlayerState.Idle;
        }

        if (context.performed) this.UpdateAnimation();
        // StartCoroutine(Attack());
    }

    public void onSkillAttack3Event(InputAction.CallbackContext context)
    {
        var ctx = context.ReadValue<float>();
        if (ctx > 0)
        {
            this.isAttack = true;
            this.playerState = PlayerState.SkillAttack3;
        }
        else
        {
            this.isAttack = false;
            this.playerState = this.isMoving
                ? PlayerState.Move
                : PlayerState.Idle;
        }

        if (context.performed) this.UpdateAnimation();
        // StartCoroutine(Attack());
    }

    private void onSwitchEvent(InputAction.CallbackContext context)
    {
    }

    private void onBlockEvent(InputAction.CallbackContext context)
    {
        this.isAttack = false;
    }

    private void onMenuEvent(InputAction.CallbackContext context)
    {
    }

    private void onItemEvent(InputAction.CallbackContext context)
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
        if (this._rawMovementInput.x > -1 && this._rawMovementInput.z > 0)
            // up right
            return PlayerDirection.UpRight;
        if (this._rawMovementInput.z > 0)
            // up left
            return PlayerDirection.UpLeft;
        if (this._rawMovementInput.x < 0 && this._rawMovementInput.z < 1)
            // down left
            return PlayerDirection.DownLeft;
        if (this._rawMovementInput.z < 1)
            // down right
            return PlayerDirection.DownRight;

        return PlayerDirection.DownRight;
    }
}