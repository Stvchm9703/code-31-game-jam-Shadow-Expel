using System.Collections;
using System.Collections.Generic;
using UnityEngine;
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

    //
    public bool inDefense;
    public int defenseCD;

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
    

    public float faceDirection => this.target.x - this.transform.position.x;

    // body collider
    private void OnCollisionEnter(Collision collision)
    {
        // Check if the enemy collided with the player
        if (collision.gameObject.tag == "Player" && this.inAttack)
        {
            // Deal damage to the player
            // ...
        }
        else if (collision.gameObject.tag == "AttackHitbox")
        {
            // Deal damage to the enemy
            // ...
            this.TakeDamage();
        }
    }


    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(this.transform.position, this.target);
        Gizmos.DrawWireSphere(this.transform.position, this.detectionRange);
        if (this.inAttackRange)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(this.transform.position, this.attackRange);
        }
    }

    public void onStart()
    {
        // Find and store a reference to the player's transform
        this.plane = this.transform.Find("Plane").gameObject;
        // StartCoroutine("UpdateTarget");
        if (this.monsterSkin != null) this.plane.GetComponent<Renderer>().material.SetTexture("_character_texture", this.monsterSkin);

        this.target = this.transform.position;
        // this.lookingRay = new Ray(this.transform.position, this.transform.forward);
        this.StartCoroutine("CoroutineUpdate");
    }

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
            if (this.isPaused == false)
            {
                if (this.inAttackRange)
                    this.StartCoroutine("Attack");
                else if (this.inDefense)
                    this.StartCoroutine("Defend");
                else if (!this.isPlayerDetected)
                    // updateTime *= 2;
                    this.StartCoroutine("CausalBehaviour");
                else
                    this.UpdateTarget();
            }

            Debug.Log("CoroutineUpdate");
            yield return new WaitForSeconds(this.updateRate);
        }
    }

    public virtual void DetectPlayer(float timeChange)
    {
        int hitsNum = Physics.SphereCastNonAlloc(
            this.transform.position,
            this.detectionRange,
            this.GetDirection(this.transform.position, this.target),
            this._lookingRaycastHits,
            this.detectionRange,
            this.detectionLayer
        );
        if (hitsNum > 0)
            foreach (RaycastHit hitted in this._lookingRaycastHits)
                if (hitted.collider.gameObject && hitted.collider.gameObject.tag == "Player")
                {
                    this.isPlayerDetected = true;
                    this.attentionTimer = this.attentionTimeout;
                    this.CheckInAttackRage();
                }
                else
                {
                    if (this.attentionTimer > 0) this.attentionTimer -= timeChange;
                    this.isPlayerDetected = this.attentionTimer <= 0f == false;
                }
    }

    public virtual void CheckInAttackRage()
    {
        // this.inAttackRange = Vector3.Distance(this.transform.position, this.target) < this.attackRange;
        this.inAttackRange = Physics.SphereCast(
            this.transform.position,
            this.attackRange,
            this.GetDirection(this.transform.position, this.target),
            out _,
            this.attackRange,
            LayerMask.NameToLayer("character")
        );
    }

    public virtual IEnumerator CausalBehaviour()
    {
        int randomPointIndex = Random.Range(0, this.patrolPoints.Count);
        var randomPoint = new Vector3(this.patrolPoints[randomPointIndex].x, this.transform.position.y, this.patrolPoints[randomPointIndex].z);
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
        // Attack the player
        // ...
        yield return new WaitForSeconds(this.updateRate);
    }

    public virtual IEnumerator Defend()
    {
        // Defend against the player's attack
        // ...
        this.inDefense = true;
        yield return new WaitForSeconds(this.defenseCD);
        this.inDefense = false;
        yield return new WaitForSeconds(this.updateRate);
    }

    public virtual IEnumerator TakeDamage()
    {
        if (!this.inDefense && this.defenseCD < 0) this.health -= 1;
        // Play damage animation
        // Take damage from the player
        if (this.health <= 0) yield return this.Die();
        // play animation
        yield return new WaitForSeconds(this.updateRate);
    }

    public virtual IEnumerator Die()
    {
        yield return new WaitForSeconds(this.updateRate);
        Destroy(this.gameObject);
    }

    public virtual void Move(float time)
    {
        // Move towards the player
        if (!this.isPaused && !this.inAttackRange && !this.inDefense)
        {
            float speedSet = this.moveSpeed;
            if (!this.isPlayerDetected) speedSet *= 0.5f;

            this.transform.position = Vector3.MoveTowards(this.transform.position, this.target, speedSet * time);
            this.CheckRotate();
        }
        else if (!this.isPaused)
        {
            this.transform.position += Vector3.zero;
        }
    }

    public virtual void CheckRotate()
    {
        // Rotate the enemy towards the player
        // ...
        if (this.faceDirection > 0)
            this.plane.GetComponent<Renderer>().material.SetInt("_is_flip", 1);
        else
            this.plane.GetComponent<Renderer>().material.SetInt("_is_flip", 0);
    }

    public virtual void CheckAttack()
    {
        // Check if the enemy is in range to attack the player
        // ...
        if (this.inAttackRange)
            this.plane.GetComponent<Renderer>().material.SetInt("_is_attack", 1);
        else
            this.plane.GetComponent<Renderer>().material.SetInt("_is_attack", 0);
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

    public virtual void BahaviourPattern()
    {
    }

    public Vector3 GetDirection(Vector3 currentPosition, Vector3 targetPosition)
    {
        return (targetPosition - currentPosition).normalized;
    }
}