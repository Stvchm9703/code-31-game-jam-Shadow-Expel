using System.Collections;
using PrimeTween;
using UnityEngine;

public class Mon004EnemyDetectBehaviour : IEnemyDetectBehaviour
{
    private static readonly int AttackPlaneRenderCharacterTexture = Shader.PropertyToID("_character_texture");
    private static readonly int AttackPlaneRenderIsFlip = Shader.PropertyToID("_is_flip");
    public GameObject attackPlane;
    public Texture attackSkin;
    private Renderer _attackPlaneRenderer;
    public SphereCollider attackHitbox;

    public Light lightEffect;
    private void Start()
    {
        this.attackPlane = this.transform.Find("AttackPlane").gameObject;
        this._attackPlaneRenderer = this.attackPlane.GetComponent<Renderer>();
        if (this.attackSkin != null)
            this._attackPlaneRenderer.material.SetTexture(AttackPlaneRenderCharacterTexture, this.attackSkin);
        this.attackPlane.SetActive(false);
        this.onStart();
    }

    private void FixedUpdate()
    {
        this.onUpdate();
    }

    public override IEnumerator Attack()
    {
        this.inAttack = true;
        Debug.Log("Mon004 Attack Phase");
        this.target = this._player.transform.position;
        
        if (this.attackPlane)
        {
            this.plane.SetActive(false);
            this.attackPlane.SetActive(true);
            // this._attackPlaneRenderer.material.SetInt(AttackPlaneRenderIsFlip, this.faceDirection
            //     ? 1
            //     : 0);
            // this.attackPlane.SetActive(true);
            Tween.Position(
                this.attackPlane.transform,
                this._player.transform.position, 
                0.5f,
                ease: Ease.InOutQuad
            );
            
            // play explosion sound
            this.PlayAttackSFX();
            // Tween.animate(this.attackPlane.transform, new Vector3(1.5f, 1.5f, 1.5f), 0.5f);
            Tween.LightRange(lightEffect , 10f, this.attackCD);
            yield return Tween.Custom(attackHitbox.radius, 3f, duration: this.attackCD, onValueChange: (value) =>
            {
                this.attackHitbox.radius = value;
            });
            
            
            // Tween.Move(this.transform, this._player.transform.position, 0.5f).EaseOutCubic();
            // this.plane.SetActive(true);
            // this.attackPlane.SetActive(false);
        }
        // play the explosion animation
        // this.ResetAfterAttack();
        this._stateMachine.Trigger("Die");
    }

    // !TODO: add the take damage animation  "TakeDamageAnimation"

    // !TODO: add the Die animation "DieAnimation"
}