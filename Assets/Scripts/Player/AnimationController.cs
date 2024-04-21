using System.Collections;
using System.Collections.Generic;
using Spine.Unity;
using UnityEngine;

public enum AnimationTarget
{
    Front,
    Back,
    Moving
}

public class AnimationController : MonoBehaviour
{
    private GameObject front,
        back,
        moving;

    private SkeletonAnimation frontPlayer,
        backPlayer,
        movingPlayer;

    // private Animator movingAnimator;
    private Transform frontTransform,
        backTransform,
        movingTransform;

    // Start is called before the first frame update
    void Start()
    {
        onAnimatorInit();
    }

    // Update is called once per frame
    void Update() { }

    private void onAnimatorInit()
    {
        // animator init
        this.moving = gameObject.transform.Find("moving").gameObject;
        this.movingTransform = gameObject.transform.Find("moving");
        this.movingPlayer = this.moving.GetComponent<SkeletonAnimation>();
        this.movingPlayer.AnimationState.SetAnimation(0, "Relax", true);

        this.front = gameObject.transform.Find("front").gameObject;
        this.frontTransform = gameObject.transform.Find("front");
        this.frontPlayer = this.front.GetComponent<SkeletonAnimation>();
        this.front.SetActive(false);

        this.back = gameObject.transform.Find("back").gameObject;
        this.backTransform = gameObject.transform.Find("back");
        this.backPlayer = this.back.GetComponent<SkeletonAnimation>();
        this.back.SetActive(false);
    }

    public void SpeedChange(float speed)
    {
        this.frontPlayer.timeScale = speed;
        this.backPlayer.timeScale = speed;
        this.movingPlayer.timeScale = speed;
    }


    public void UpdateAnimation(
        bool isAttack,
        PlayerDirection direction,
        PlayerState playerState
    )
    {
        // var direction = GetDirectionState();

        if (!isAttack)
        {
            this.moving.SetActive(true);
            this.front.SetActive(false);
            this.back.SetActive(false);

            if (playerState == PlayerState.Idle)
            {
                /// idle
                movingPlayer.AnimationState.SetAnimation(1, "Relax", true);
                // movingPlayer.AnimationState.
            }
            else if (playerState == PlayerState.Move)
            {
                movingPlayer.AnimationState.SetAnimation(1, "Move", true);
            }

            if (direction == PlayerDirection.UpRight)
            {
                // movingPlayer.AnimationState.SetAnimation(1, "Move", true);
                // up (face neg)  (0.00000, 0.92388, 0.38268, 0.00000)
                movingTransform.localRotation = new Quaternion(0f, 0.92388f, 0.38268f, 0f);
                movingPlayer.addNormals = false;
                movingTransform.localScale = new Vector3(-0.45f, 0.45f, 0.45f);
            }
            else if (direction == PlayerDirection.UpLeft)
            {
                // movingPlayer.AnimationState.SetAnimation(1, "Move", true);
                // up (face neg)  (0.00000, 0.92388, 0.38268, 0.00000)
                movingTransform.localRotation = new Quaternion(0f, 0.92388f, 0.38268f, 0f);
                movingPlayer.addNormals = true;
                movingTransform.localScale = new Vector3(0.45f, 0.45f, 0.45f);
            }
            else if (direction == PlayerDirection.DownRight)
            {
                movingTransform.localRotation = new Quaternion(0.38268f, 0f, 0f, 0.92388f);
                movingPlayer.addNormals = true;
                movingTransform.localScale = new Vector3(0.45f, 0.45f, 0.45f);
            }
            else if (direction == PlayerDirection.DownLeft)
            {
                movingTransform.localRotation = new Quaternion(0.38268f, 0f, 0f, 0.92388f);
                movingPlayer.addNormals = true;
                movingTransform.localScale = new Vector3(-0.45f, 0.45f, 0.45f);
            }

            // yield return null;
        }
        else
        {
            if (direction == PlayerDirection.UpLeft || direction == PlayerDirection.UpRight)
            {
                this.front.SetActive(false);
                this.moving.SetActive(false);
                this.back.SetActive(true);
                if (direction == PlayerDirection.UpLeft)
                {
                    this.backTransform.localScale = new Vector3(-0.45f, 0.45f, 0.45f);
                }
                else // (direction == PlayerDirection.UpRight)
                {
                    this.backTransform.localScale = new Vector3(0.45f, 0.45f, 0.45f);
                }

                if (playerState == PlayerState.Attack)
                {
                    this.backPlayer.AnimationState.SetAnimation(1, "Attack", false);
                    // yield return new WaitForSeconds(1f);

                }
                else if (playerState == PlayerState.SkillAttack1)
                {
                    this.backPlayer.AnimationState.SetAnimation(1, "Skill_2_start", false);
                    // yield return new WaitForSeconds(0.4f);
                }
                else if (playerState == PlayerState.SkillAttack2)
                {
                    this.backPlayer.AnimationState.SetAnimation(1, "Skill_2_Attack", false);
                    // yield return new WaitForSeconds(1f);
                }
                else if (playerState == PlayerState.SkillAttack3)
                {
                    this.backPlayer.AnimationState.SetAnimation(1, "Skill_3_Loop", false);
                    // yield return new WaitForSeconds(1f);
                }
            }
            else if (
                direction == PlayerDirection.DownLeft
                || direction == PlayerDirection.DownRight
            )
            {
                this.back.SetActive(false);
                this.moving.SetActive(false);
                this.front.SetActive(true);
                if (direction == PlayerDirection.DownLeft)
                {
                    this.frontTransform.localScale = new Vector3(-0.45f, 0.45f, 0.45f);
                }
                else //* (direction == PlayerDirection.UpRight)
                {
                    this.frontTransform.localScale = new Vector3(0.45f, 0.45f, 0.45f);
                }
                if (playerState == PlayerState.Attack)
                {
                    this.frontPlayer.AnimationState.SetAnimation(1, "Attack", false);
                    // yield return new WaitForSeconds(1.0f);
                }
                else if (playerState == PlayerState.SkillAttack1)
                {
                    this.frontPlayer.AnimationState.SetAnimation(1, "Skill_2_Start", false);
                    // yield return new WaitForSeconds(0.4f);

                }
                else if (playerState == PlayerState.SkillAttack2)
                {
                    this.frontPlayer.AnimationState.SetAnimation(1, "Skill_2_Attack", false);
                    // yield return new WaitForSeconds(1f);

                }
                else if (playerState == PlayerState.SkillAttack3)
                {
                    this.frontPlayer.AnimationState.SetAnimation(1, "Skill_3_Loop", false);
                    // yield return new WaitForSeconds(1f);

                }
                // this.frontPlayer.AnimationState.SetAnimation(1, "Attack", false);
            }
        }
        // yield return null;
    }

    public void Pause()
    {
        this.backPlayer.AnimationState.TimeScale = 0;
        this.frontPlayer.AnimationState.TimeScale = 0;
        this.movingPlayer.AnimationState.TimeScale = 0;
    }
    
    public void Resume()
    {
        this.backPlayer.AnimationState.TimeScale = 1;
        this.frontPlayer.AnimationState.TimeScale = 1;
        this.movingPlayer.AnimationState.TimeScale = 1;
    }
}
