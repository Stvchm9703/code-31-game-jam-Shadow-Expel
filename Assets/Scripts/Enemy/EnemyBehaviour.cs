using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using Unity.Physics;
using UnityEngine;

public abstract class IEnemyBehaviour : MonoBehaviour
{
    public int health;
    public int maxHealth;

    //
    public int attackDamage;
    public bool inAttack;
    public bool inAttackRange;

    public float attackRange = 1.5f;
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



    public void onStart()
    {
        // Find and store a reference to the player's transform
        plane = transform.Find("Plane").gameObject;
        StartCoroutine("UpdateTarget");
        if (monsterSkin != null)
        {
            plane.GetComponent<Renderer>().material.SetTexture("_character_texture", monsterSkin);
        }
    }

    public void onUpdate()
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
            else
            {
                // move towards the player
                Move(Time.deltaTime);
            }
            CheckAttack();
        }
    }

    void OnCollisionEnter(Collision collision)
    {
        // Check if the enemy collided with the player
        if (collision.gameObject.tag == "Player")
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

    public virtual IEnumerator UpdateTarget()
    {
        while (isPaused == false)
        {
            target = GameObject.FindGameObjectWithTag("Player").transform.position;
            target.y = transform.position.y; // Keep the enemy at the same height as the player
            yield return new WaitForSeconds(updateRate);
        }
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
        if (!isPaused && !inAttackRange  && !inDefense)
        {
            transform.position = Vector3.MoveTowards(transform.position, target, moveSpeed * time);
            CheckRotate();
        }
        else
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

    protected void ResetAfterAttack()
    {
        throw new System.NotImplementedException();
    }
}
