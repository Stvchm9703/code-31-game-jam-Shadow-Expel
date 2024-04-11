using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class Mon001EnemyDetectBehaviour : IEnemyDetectBehaviour
{
    public GameObject attackPlane;
    public Texture attackSkin;

    private void Start()
    {
        onStart();
        attackPlane = transform.Find("AttackPlane").gameObject;
        attackPlane.GetComponent<Renderer>().material.SetTexture("_character_texture", attackSkin);
        attackPlane.SetActive(false);
    }

    private void Update()
    {
        onUpdate();
    }

    public override IEnumerator Attack()
    {
        inAttack = true;
        // Play the attack animation
        // ...

        yield return new WaitForSeconds(1.25f);
        plane.SetActive(false);
        if (attackSkin != null)
        {
            if (faceDirection > 0)
            {
                attackPlane.GetComponent<Renderer>().material.SetInt("_is_flip", 1);
            }
            else
            {
                attackPlane.GetComponent<Renderer>().material.SetInt("_is_flip", 0);
            }
            attackPlane.SetActive(true);
        }
        yield return new WaitForSeconds(2.5f);
        // Deal damage to the player
        // ...
        plane.SetActive(true);
        attackPlane.SetActive(false);
        inAttack = false;
        inAttackRange = false;
    }

}
