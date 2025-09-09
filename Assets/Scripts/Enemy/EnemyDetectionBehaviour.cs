using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Entities.UI;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;
using RaycastHit = UnityEngine.RaycastHit;
using UnityHFSM;
public abstract class IEnemyDetectBehaviour : MonoBehaviour
{
    public int health;
    public int maxHealth;

    //
    public int attackDamage;
    public bool inAttack;
    public bool inAttackRange;

    public float attackRange = 1.2f;
    public float attackCD = 1.5f;

    [SerializeField]
    bool isDemageProcess;

    float _demageProcessTime = 1.5f; // lock demage process time
    //
    // public bool inDefense;
    // public int defenseCD;

    //
    public bool isPaused;

    protected GameObject _player;

    public Vector3 target; // Reference to the player's transform
    public float moveSpeed = 7.5f; // Speed at which the enemy moves towards the player
    public float updateRate = 5f; // Rate at which the enemy updates its position

    public GameObject plane;
    public Texture monsterSkin;

    // enemy detection range
    [SerializeField]
    private bool isPlayerDetected;

    public float detectionRange = 2f;
    public float attentionTimeout = 5f;

    [SerializeField]
    private float attentionTimer;

    // public Vector3 lookingDirection => this.lookingRay.direction;

    public List<Transform> patrolPoints;

    public LayerMask detectionLayer ; //=  LayerMask.GetMask("character", "wall");
    private readonly RaycastHit[] _lookingRaycastHits = new RaycastHit[5];

    public bool faceDirection => (this.target.x - this.transform.position.x) > 0;

    // Coroutine _currentCoroutine;

    [SerializeField] private List<AudioClip> _attackSound, _demageSound, _dieSound, _idleSound;
    // AudioSource _audioSource;
    // body collider

    protected StateMachine _stateMachine;
    
    [SerializeField] 
    public string State => this._stateMachine.ActiveState.ToString();

    private void OnCollisionEnter(Collision collision)
    {
        // Debug.Log(collision.gameObject);
        // Check if the enemy collided with the player
        if (collision.gameObject.CompareTag("Player") && this.inAttack)
        {
            // Deal damage to the player
            // ...
            if (this._player)
            {
                var playerMI = this._player.GetComponent<PlayerStatus>();
                playerMI.TakeDamage(this.attackDamage);
            }
        }
        // else if (collision.gameObject.CompareTag("HitboxJudgement"))
        // {
        //     // Deal damage to the enemy
        //     // ...
        //     // this.TakeDamage();
        //     if (this._player)
        //     {
        //         var playerMI = this._player.GetComponent<PlayerStatus>();
        //         TakeDamage(playerMI.attack);
        //     }
        //     this._stateMachine.Trigger("OnTakeDemage");
        // }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(this.transform.position, this.target);
        Gizmos.DrawWireSphere(this.transform.position, this.detectionRange);
        // if (this.inAttackRange)
        // {
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(this.transform.position, this.attackRange);
        // }
    }

    public void onStart()
    {
        // Find and store a reference to the player's transform
        this.plane = this.transform.Find("Plane").gameObject;
        this._planeRenderer = this.transform.Find("Plane").GetComponent<Renderer>();
        // StartCoroutine("UpdateTarget");
        if (this.monsterSkin != null)
            this.plane.GetComponent<Renderer>()
                .material.SetTexture(PlaneRendererCharacterTexture, this.monsterSkin);

        this.target = this.transform.position;

        if (this.detectionLayer.value == 0)
        {
            this.detectionLayer = LayerMask.GetMask("character", "wall");
        }

        this._player = GameObject.FindGameObjectWithTag("Player");
        // this.lookingRay = new Ray(this.transform.position, this.transform.forward);
        // this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
        GameStateManager.Instance.OnGameStateChanged += this.OnGameStateChanged;

        this._stateMachine = new StateMachine();
        this._stateMachine.AddState("Patrol", new CoState(this, this.CausalBehaviour, loop: true));
        this._stateMachine.AddState("Attack", new CoState(this, this.Attack, loop: false));
        this._stateMachine.AddState("Detected", new CoState(this, this.ChasePlayer, loop: true));
        this._stateMachine.AddState("TakeDemage", new CoState(this, this.TakeDamageAnimation, loop: false));
        this._stateMachine.AddState("Die", new CoState(this, this.Die , loop: false));

        this._stateMachine.AddTriggerTransitionFromAny("OnTakeDemage", "TakeDemage");
        this._stateMachine.AddTriggerTransitionFromAny("OnDie", "Die", t => this.health <= 0, forceInstantly:true);

        this._stateMachine.AddTwoWayTransition("Patrol", "Detected", t => this.isPlayerDetected);

        this._stateMachine.AddTransitionFromAny("Attack", t => this.inAttackRange);
        // this._stateMachine.AddTwoWayTransition("Detected", "Attack", t => this.inAttackRange);
        // this._stateMachine.AddTwoWayTransition("Attack", "Patrol", t => !this.inAttackRange);
        this._stateMachine.AddTwoWayTransition("TakeDemage", "Detected", t => this.isDemageProcess == false, forceInstantly:true);

        this._stateMachine.SetStartState("Patrol");
        this._stateMachine.Init();
    }
    

    public void OnDestroy()
    {
        GameStateManager.Instance.OnGameStateChanged -= this.OnGameStateChanged;
    }

    // call this method in the Implement FixedUpdate
    public virtual void onUpdate()
    {

        if (this.isPaused == false)
        {
            this.Move(Time.fixedDeltaTime);
            this.DetectPlayer(Time.fixedDeltaTime);
            this.CheckAttack();
            // Debug.DrawRay(this.lookingRay.origin, this.lookingRay.direction * this.detectionRange, Color.red);
            if (this._stateMachine.ActiveState == null)
            {
                this._stateMachine.SetStartState("Patrol");
                this._stateMachine.Init();
            }
            this._stateMachine.OnLogic();
        }
        else
        {
            this._stateMachine.OnExit();
            // Debug.Log(this._stateMachine.ActiveState.name);
        }
        // Debug.Log(this._stateMachine.ActiveState.name);
    }

    // public IEnumerator CoroutineUpdate()
    // {
    //     while (true)
    //     {
    //         // Debug.Log("CoroutineUpdate");
    //         if (this.isPaused == false)
    //         {
    //             if (!this.isPlayerDetected)
    //                 this.StartCoroutine("CausalBehaviour");
    //             else
    //                 this.UpdateTarget();
    //         }
    //         else
    //         {
    //             yield return new WaitUntil(() => this.isPaused == false);
    //         }
    //
    //         yield return new WaitForSeconds(this.updateRate);
    //     }
    // }

    public void OnGameStateChanged(GameState newGameState)
    {
        this.isPaused = newGameState == GameState.Paused || newGameState == GameState.GameOver;
        // Debug.Log("should update " + this.isPaused);
        // if (this.isPaused) this._stateMachine.OnExit();
        // else this._stateMachine.OnEnter();
    }

    public virtual void DetectPlayer(float timeChange)
    {
        var currentDirection = IEnemyDetectBehaviour.GetDirection(this.transform.position, this.target);
        int hitsNum = Physics.SphereCastNonAlloc(
            this.transform.position,
            this.detectionRange,
            currentDirection,
            this._lookingRaycastHits,
            this.detectionRange,
            this.detectionLayer
        );
        if (hitsNum > 0)
        {
            var playerGO = GameObject.FindGameObjectWithTag("Player");

            foreach (RaycastHit hitted in this._lookingRaycastHits)
            {
                if (!hitted.collider) continue;
                Vector3 hitPoint = hitted.point;
                Vector3 directionToHit = hitPoint - this.transform.position;
                float angleToHit = Vector3.Angle(currentDirection, directionToHit);
                if (hitted.collider.gameObject && hitted.collider.gameObject == playerGO && angleToHit < 45f)
                {
                    this.isPlayerDetected = true;
                    this.attentionTimer = this.attentionTimeout;
                    this.CheckInAttackRage();
                }
            }
        }
        else
        {
            if (this.attentionTimer > 0f)
                this.attentionTimer -= timeChange;
            this.isPlayerDetected = !(this.attentionTimer <= 0f);
        }
    }

    public virtual void CheckInAttackRage()
    {
        // Debug.Log("CheckInAttackRage");
        // this.inAttackRange = Vector3.Distance(this.transform.position, this.target) < this.attackRange;
        this.inAttackRange = Vector3.Distance(transform.position, target) < attackRange;
        // if (this.inAttackRange)
        // {
        //     // this.StopCoroutine(this._currentCoroutine);
        //     // this._currentCoroutine = this.StartCoroutine("Attack");
        // }
    }

    public virtual IEnumerator CausalBehaviour()
    {
        if (this.patrolPoints.Count > 0)
        {
            // Debug.Log("Causal Behaviour");
            int randomPointIndex = Random.Range(0, this.patrolPoints.Count);
            var pos = this.patrolPoints[randomPointIndex].position;
            var randomPoint = new Vector3(
                pos.x,
                this.transform.position.y,
                pos.z
            );
            this.target = randomPoint;
        }
        PlayIdleSound();
        yield return new WaitForSeconds(this.updateRate * 0.3f);
    }

    public void PlayIdleSound()
    {
        if (this._idleSound.Count == 0) return;
        // Play idle sound
        var randomIndex = Random.Range(0, this._idleSound.Count);
        SoundFXManager.Instance.PlaySoundFX(this._idleSound[randomIndex], this.transform, 0.25f, this.updateRate * 0.3f);
    
    }

    public virtual void UpdateTarget()
    {

        this.target = GameObject.FindGameObjectWithTag("Player").transform.position;
        this.target.y = this.transform.position.y; // Keep the enemy at the same height as the player
    }

    public virtual IEnumerator ChasePlayer()
    {
        // Debug.Log("Chase Player");
        var newPosition = GameObject.FindGameObjectWithTag("Player").transform.position;
        newPosition.y = this.transform.position.y;
        this.target = newPosition;
        yield return new WaitForSeconds(this.updateRate * 0.3f);
    }

    public virtual IEnumerator Attack()
    {
        // Debug.Log("Attack Phase");
        // Attack the player
        // ...
        PlayAttackSFX();
        yield return new WaitForSeconds(this.updateRate + this.attackCD);
        this.ResetAfterAttack();
    }

    public void ResetAfterAttack()
    {
        this.inAttack = false;
        this.inAttackRange = false;
        // this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
        this._stateMachine.Trigger("Detected");
    }

    public void PlayAttackSFX()
    {
        if (this._attackSound.Count == 0) return;
        // Play attack animation
        var randomIndex = Random.Range(0, this._attackSound.Count);
        SoundFXManager.Instance.PlaySoundFX(this._attackSound[randomIndex], this.transform);
    }

    // public virtual IEnumerator Defend()
    // {
    //     // Defend against the player's attack
    //     // ...
    //     // this.inDefense = true;
    //     // yield return new WaitForSeconds(this.defenseCD);
    //     // this.inDefense = false;
    //     yield return new WaitForSeconds(this.updateRate);
    // }

    public virtual void TakeDamageEmmiter(int damage = 1)
    {
        // Debug.Log("get damage");
        if (this.isDemageProcess) return;
        this.health -= damage;
        this.isDemageProcess = true;

        if (this.health <= 0) this._stateMachine.Trigger("OnDie");
        else this._stateMachine.Trigger("OnTakeDemage");
        // StopCoroutine(this._currentCoroutine);
        // this._currentCoroutine = StartCoroutine("TakeDamageAnimation");

        /// if (this.health <= 0) this._stateMachine.Trigger("Die");
            // StartCoroutine("Die");
    }

    public virtual IEnumerator TakeDamageAnimation()
    {
        // Debug.Log("get damage animation");
        this.PlayTakeDemageSFX();
        yield return new WaitForSeconds(this.updateRate + this._demageProcessTime);
        ResetAfterDemage();
    }

    public void PlayTakeDemageSFX()
    {
        if (this._demageSound.Count == 0) return;
        // Play damage animation
        var randomIndex = Random.Range(0, this._demageSound.Count);
        SoundFXManager.Instance.PlaySoundFX(this._demageSound[randomIndex], this.transform);    
    }

    public void ResetAfterDemage()
    {
        // Debug.Log("reset demage process");
        this.isDemageProcess = false;
        // this._stateMachine.Trigger("Detected");
        // this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
    }

    public IEnumerator Die()
    {
        yield return DieAnimation();
        this._stateMachine.RequestExit(true);
        Destroy(this.gameObject);
    }

    public virtual IEnumerator DieAnimation()
    {
        // Debug.Log("Die animation");
        // Play damage animation
        this.PlayDieSound();
        yield return new WaitForSeconds(1f);
        // this.isPaused = tru  e;
    }
    public virtual void PlayDieSound()
    {
        if (this._dieSound.Count == 0) return;
        var randomIndex = Random.Range(0, this._dieSound.Count);
        SoundFXManager.Instance.PlaySoundFX(this._dieSound[randomIndex], this.transform);
    }

    public virtual void Move(float time)
    {
        // Move towards the player
        if (!this.isPaused && !this.inAttackRange)
        {
            float speedSet = this.moveSpeed;
            if (!this.isPlayerDetected)
                speedSet *= 0.5f;

            this.transform.position = Vector3.MoveTowards(
                this.transform.position,
                this.target,
                speedSet * time
            );
            this.CheckRotate();
        }
        else if (!this.isPaused)
        {
            this.transform.position += Vector3.zero;
        }
    }

    Renderer _planeRenderer;
    private static readonly int PlaneRendererIsAttack = Shader.PropertyToID("_is_attack");
    private static readonly int PlaneRendererIsFlip = Shader.PropertyToID("_is_flip");
    private static readonly int PlaneRendererCharacterTexture = Shader.PropertyToID("_character_texture");

    public virtual void CheckRotate()
    {
        // Rotate the enemy towards the player
        // ...
        this._planeRenderer.material.SetInt(PlaneRendererIsFlip, faceDirection
            ? 1
            : 0);
    }

    public virtual void CheckAttack()
    {
        // Check if the enemy is in range to attack the player
        // ...
        this._planeRenderer.material.SetInt(PlaneRendererIsAttack, this.inAttackRange
            ? 1
            : 0);
    }

    public virtual void AddStatusEffect()
    {
        // Add a status effect to the enemy
        // ...
    }

    public virtual void RemoveStatusEffect()
    {
        // Remove a status effect from the enemy
        // ...
    }

    public virtual void ShootProjectile()
    {
        // Shoot a projectile at the player
        // ...
    }


    public static Vector3 GetDirection(Vector3 currentPosition, Vector3 targetPosition)
    {
        return (targetPosition - currentPosition).normalized;
    }
}
