using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using Unity.Physics;
using UnityEngine;
using Random = UnityEngine.Random;
using Ray = UnityEngine.Ray;
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
    public bool isPaused = false;

    public Vector3 target; // Reference to the player's transform
    public float moveSpeed = 7.5f; // Speed at which the enemy moves towards the player
    public float updateRate = 5f; // Rate at which the enemy updates its position

    public GameObject plane;

    public Texture monsterSkin;


    public float faceDirection => target.x - transform.position.x;
    
    // enemy detection range
    [SerializeField] private bool isPlayerDetected = false;
    public float detectionRange = 2f;
    public float attentionTimeout = 5f;
    [SerializeField] private float attentionTimer = 0f;
    private Ray lookingRay;
    // public Vector3 lookingDirection => this.lookingRay.direction;

    public List<Vector3> patrolPoints;
    
    private Vector3 lastPosition;
    
    public void onStart()
    {
        // Find and store a reference to the player's transform
        plane = transform.Find("Plane").gameObject;
        // StartCoroutine("UpdateTarget");
        if (monsterSkin != null)
        {
            plane.GetComponent<Renderer>().material.SetTexture("_character_texture", monsterSkin);
        }

        this.target = this.transform.position;
        this.lookingRay = new Ray(transform.position, transform.forward);
        StartCoroutine("CoroutineUpdate");
        Debug.DrawRay(transform.position, transform.forward * 10, Color.green);
    }

    public void onUpdate()
    {
        if (isPaused == false)
        {
          
            
            Move(Time.deltaTime);
            
            DetectPlayer(Time.deltaTime);
            CheckAttack();
            Debug.DrawRay(lookingRay.origin, lookingRay.direction * this.detectionRange, Color.red);

        }
    }   
    public IEnumerator CoroutineUpdate()
    {
        while (true)
        {
            if (isPaused == false)
            {
                if (inAttackRange)
                {
                    StartCoroutine("Attack");
                }
                else if (inDefense)
                {
                    StartCoroutine("Defend");
                }
                else if (!this.isPlayerDetected)
                {
                    // updateTime *= 2;
                    StartCoroutine("CausalBehaviour");
                }
                else
                {
                    UpdateTarget();
                }
            }
            Debug.Log("CoroutineUpdate");
            yield return new WaitForSeconds(this.updateRate);
        }
    }

    // body collider
    void OnCollisionEnter(Collision collision)
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
            TakeDamage();
        }
    }

    // ---

    private readonly RaycastHit[] _lookingRaycastHits = new RaycastHit[5];
    public virtual void DetectPlayer(float timeChange)
    {
        int hitsNum = Physics.RaycastNonAlloc(lookingRay, this._lookingRaycastHits, detectionRange);
        
        if (hitsNum > 0  && this._lookingRaycastHits[0].collider.gameObject.tag == "Player")
        {
            this.isPlayerDetected = true;
            this.attentionTimer = this.attentionTimeout;
            this.inAttackRange = Vector3.Distance(transform.position, target) < attackRange;
        }
        else
        {
            if(this.attentionTimer > 0) this.attentionTimer -= timeChange;
            this.isPlayerDetected = (this.attentionTimer <= 0f) == false;
        }
     
        
        
    }   
    public virtual IEnumerator CausalBehaviour()
    {
        this.lastPosition = transform.position;
        // var passLocation = transform.position;
        var randomPointIndex = Random.Range(0, patrolPoints.Count);
        var randomPoint = new Vector3(patrolPoints[randomPointIndex].x, transform.position.y, patrolPoints[randomPointIndex].z);
        this.target = randomPoint;
        yield return new WaitForSeconds(1.2f);
    }
    public virtual void UpdateTarget()
    {
        target = GameObject.FindGameObjectWithTag("Player").transform.position;
        target.y = transform.position.y; // Keep the enemy at the same height as the player
    }

    public virtual IEnumerator Attack()
    {
        // Attack the player
        // ...
        yield return new WaitForSeconds(updateRate);
    }

    public virtual IEnumerator Defend()
    {
        // Defend against the player's attack
        // ...
        inDefense = true;
        yield return new WaitForSeconds(defenseCD);
        inDefense = false;
        yield return new WaitForSeconds(updateRate);
    }

    public virtual IEnumerator TakeDamage()
    {
        if (!inDefense && defenseCD < 0)
        {
            health -= 1;
            // Play damage animation
        }

        // Take damage from the player
        if (health <= 0)
        {
            yield return Die();
        }
        // play animation
        yield return new WaitForSeconds(updateRate);
    }

    public virtual IEnumerator Die()
    {
        yield return new WaitForSeconds(updateRate);
        Destroy(gameObject);
    }

    public virtual void Move(float time)
    {
        // Move towards the player
        if (!isPaused && !inAttackRange && !inDefense)
        {
            var speedSet = moveSpeed;
            if (!this.isPlayerDetected) speedSet *= 0.5f;
            
            transform.position = Vector3.MoveTowards(transform.position, target, speedSet * time);
            CheckRotate();
            lookingRay.origin = transform.position;

            if (transform.position != this.target)
            {
                lookingRay.direction = GetDirection(transform.position, this.target ) * this.detectionRange;
                
            }
            else
            {
                lookingRay.direction = GetDirection(transform.position,  this.lastPosition) *  - this.detectionRange;
            }
            
        }
        else if (!this.isPaused)    
        {
            transform.position += Vector3.zero;
        }
    }

    public virtual void CheckRotate()
    {
        // Rotate the enemy towards the player
        // ...
        if (faceDirection > 0)
        {
            plane.GetComponent<Renderer>().material.SetInt("_is_flip", 1);
        }
        else
        {
            plane.GetComponent<Renderer>().material.SetInt("_is_flip", 0);
        }
    }

    public virtual void CheckAttack()
    {
        // Check if the enemy is in range to attack the player
        // ...
        if (inAttackRange)
        {
            plane.GetComponent<Renderer>().material.SetInt("_is_attack", 1);
        }
        else
        {
            plane.GetComponent<Renderer>().material.SetInt("_is_attack", 0);
        }
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

    public virtual void BahaviourPattern() { }
    
    public Vector3 GetDirection(Vector3 currentPosition, Vector3 targetPosition)
    {
        
        return (targetPosition - currentPosition).normalized;
        
    }
  
}
