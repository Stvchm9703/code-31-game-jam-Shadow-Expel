using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class Mon001EnemyDetectBehaviour : IEnemyDetectBehaviour
{
    public GameObject attackPlane;
    public Texture attackSkin;
    Renderer _attackPlaneRenderer;
    private static readonly int AttackPlaneRenderCharacterTexture = Shader.PropertyToID("_character_texture");
    private static readonly int AttackPlaneRenderIsFlip = Shader.PropertyToID("_is_flip");

    private void Start()
    {
        onStart();
        attackPlane = transform.Find("AttackPlane").gameObject;
        this._attackPlaneRenderer = attackPlane.GetComponent<Renderer>();
        if (attackSkin != null) 
            this._attackPlaneRenderer.material.SetTexture(AttackPlaneRenderCharacterTexture, attackSkin);
        attackPlane.SetActive(false);
    }

    private void FixedUpdate()
    {
        onUpdate();
    }

    public override IEnumerator Attack()
    {
        inAttack = true;
        // Play the attack animation
        // ...
        // fake preattack animation 
        yield return new WaitForSeconds(1.25f);
        plane.SetActive(false);
        if (attackPlane)
        {   
            this._attackPlaneRenderer.material.SetInt(AttackPlaneRenderIsFlip, faceDirection? 1 : 0);
            attackPlane.SetActive(true);
        }
        yield return new WaitForSeconds(this.attackCD);
        // Deal damage to the player
        // ...
        plane.SetActive(true);
        attackPlane.SetActive(false);
        this.ResetAfterAttack();
    }
    
    // !TODO: add the take damage animation  "TakeDamageAnimation"

    // !TODO: add the Die animation "DieAnimation"
}
