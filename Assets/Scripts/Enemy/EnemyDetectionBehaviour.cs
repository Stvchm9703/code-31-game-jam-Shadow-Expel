using System.Collections;
using System.Collections.Generic;
using Unity.Entities.UI;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;
using RaycastHit = UnityEngine.RaycastHit;

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

    [SerializeField] bool isDemageProcess;
    float _demageProcessTime = 1.5f; // lock demage process time
    //
    // public bool inDefense;
    // public int defenseCD;

    //
    public bool isPaused;

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

    public List<Vector3> patrolPoints;

    public LayerMask detectionLayer;
    private readonly RaycastHit[] _lookingRaycastHits = new RaycastHit[5];

    public bool faceDirection => (this.target.x - this.transform.position.x) > 0;

    Coroutine _currentCoroutine;
    
    // body collider
    private void OnCollisionEnter(Collision collision)
    {
        // Check if the enemy collided with the player
        if (collision.gameObject.CompareTag( "Player") && this.inAttack)
        {
            // Deal damage to the player
            // ...
        }
        else if (collision.gameObject.CompareTag( "AttackHitbox") )
        {
            // Deal damage to the enemy
            // ...
            // this.TakeDamage();
        }
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
        // this.lookingRay = new Ray(this.transform.position, this.transform.forward);
        this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
    }

    // call this method in the Implement FixedUpdate
    public void onUpdate()
    {
        if (this.isPaused == false)
        {
            this.Move(Time.deltaTime);
            this.DetectPlayer(Time.deltaTime);
            this.CheckAttack();
            // Debug.DrawRay(this.lookingRay.origin, this.lookingRay.direction * this.detectionRange, Color.red);
        }
    }

    public IEnumerator CoroutineUpdate()
    {
        while (true)
        {
            Debug.Log("CoroutineUpdate");
            if (this.isPaused == false)
            {
                if (!this.isPlayerDetected)
                    this.StartCoroutine("CausalBehaviour");
                else
                    this.UpdateTarget();
            }
            yield return new WaitForSeconds(this.updateRate);
        }
    }

    public virtual void DetectPlayer(float timeChange)
    {
        int hitsNum = Physics.SphereCastNonAlloc(
            this.transform.position,
            this.detectionRange,
            IEnemyDetectBehaviour.GetDirection(this.transform.position, this.target),
            this._lookingRaycastHits,
            this.detectionRange,
            this.detectionLayer
        );
        if (hitsNum > 0)
        {
            var playerGO = GameObject.FindGameObjectWithTag("Player");

            foreach (RaycastHit hitted in this._lookingRaycastHits)
            {
                if (!hitted.collider)  continue;
                if (hitted.collider.gameObject && hitted.collider.gameObject == playerGO)
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
        // this.inAttackRange = Vector3.Distance(this.transform.position, this.target) < this.attackRange;
        this.inAttackRange = Vector3.Distance(transform.position, target) < attackRange;
        if (this.inAttackRange)
        {
            this.StopCoroutine(this._currentCoroutine);
            this._currentCoroutine = this.StartCoroutine("Attack");
        }
    }

    public virtual IEnumerator CausalBehaviour()
    {
        int randomPointIndex = Random.Range(0, this.patrolPoints.Count);
        var randomPoint = new Vector3(
            this.patrolPoints[randomPointIndex].x,
            this.transform.position.y,
            this.patrolPoints[randomPointIndex].z
        );
        this.target = randomPoint;
        yield return new WaitForSeconds(this.updateRate * 0.3f);
    }   
    public virtual void UpdateTarget()
    {
        this.target = GameObject.FindGameObjectWithTag("Player").transform.position;
        this.target.y = this.transform.position.y; // Keep the enemy at the same height as the player
    }
    
    

    public virtual IEnumerator Attack()
    {
        // Debug.Log("Attack Phase");
        // Attack the player
        // ...
        yield return new WaitForSeconds(this.updateRate + this.attackCD);
        this.ResetAfterAttack();
    }
    public void ResetAfterAttack()
    {
        this.inAttack = false;
        this.inAttackRange = false;
        this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
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

    public virtual void TakeDamage(int damage = 1)
    {
        Debug.Log("get damage");
        if (this.isDemageProcess) return;
        
        this.health -= damage;
        this.isDemageProcess = true;
        StopCoroutine(this._currentCoroutine);
        this._currentCoroutine = StartCoroutine("TakeDamageAnimation");
        // }
        // Play damage animation
        // Take damage from the player
        if (this.health <= 0)
            StartCoroutine( "Die");

    }

    public virtual IEnumerator TakeDamageAnimation()
    { 
        // Debug.Log("get damage animation");
        yield return new WaitForSeconds(this.updateRate + this._demageProcessTime);
        ResetAfterDemage();
    }
    public void ResetAfterDemage()
    {
        this.isDemageProcess = false;
        this._currentCoroutine = this.StartCoroutine("CoroutineUpdate");
    }

    public virtual void Die()
    {
        StartCoroutine("DieAnimation");
        Destroy(this.gameObject);
    }
    
    public virtual IEnumerator DieAnimation()
    {   
        yield return null;
        // this.isPaused = tru  e;
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
        this._planeRenderer.material.SetInt(PlaneRendererIsFlip, faceDirection ? 1 : 0);
    }

    public virtual void CheckAttack()
    {
        // Check if the enemy is in range to attack the player
        // ...
        this._planeRenderer.material.SetInt(PlaneRendererIsAttack, this.inAttackRange?1:0);
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
