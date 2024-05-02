using System.Collections;
using System.Collections.Generic;

using UnityEngine;


public class AnimationControllerTemp : AnimationController
{

    public Vector3 frontScale, backScale;

    // Update is called once per frame
    // void Update() { }
    public override void onAnimatorInit()
    {
        // animator init
        // this.moving = gameObject.transform.Find("moving").gameObject;
        // this.movingTransform = gameObject.transform.Find("moving");
        // this.movingPlayer = this.moving.GetComponent<SkeletonAnimation>();
        // this.movingPlayer.AnimationState.SetAnimation(0, "Relax", true);

        this.front = gameObject.transform.Find("front").gameObject;
        this.frontTransform = gameObject.transform.Find("front");
        // this.frontPlayer = this.front.GetComponent<SkeletonAnimation>();
        this.front.SetActive(true);
        this.frontScale = this.frontTransform.localScale;
        
        this.back = gameObject.transform.Find("back").gameObject;
        this.backTransform = gameObject.transform.Find("back");
        // this.backPlayer = this.back.GetComponent<SkeletonAnimation>();
        this.back.SetActive(false);
        this.backScale = this.backTransform.localScale;
    }

    public override void SpeedChange(float speed)
    {
        // this.frontPlayer.timeScale = speed;
        // this.backPlayer.timeScale = speed;
        // this.movingPlayer.timeScale = speed;
    }


    public override void UpdateAnimation(
        bool isAttack,
        PlayerDirection direction,
        PlayerState playerState
    )
    {
        // var direction = GetDirectionState();

        if (direction == PlayerDirection.UpLeft || direction == PlayerDirection.UpRight)
        {
            this.front.SetActive(false);
            this.back.SetActive(true);
            if (direction == PlayerDirection.UpLeft)
            {
                this.backTransform.localScale = new Vector3(
                    this.backScale.x * -1,
                    this.backScale.y,
                    this.backScale.z
                );
            }
            else // (direction == PlayerDirection.UpRight)
            {
                this.backTransform.localScale = this.backScale;
            }

        }
        else if (
            direction == PlayerDirection.DownLeft
            || direction == PlayerDirection.DownRight
        )
        {
            this.back.SetActive(false);
            this.front.SetActive(true);
            if (direction == PlayerDirection.DownLeft)
            {
                this.frontTransform.localScale = new Vector3(
                    this.frontScale.x * -1,
                    this.frontScale.y,
                    this.frontScale.z
                );
            }
            else //* (direction == PlayerDirection.UpRight)
            {
                this.frontTransform.localScale = this.frontScale;
            }
          
        
        }
        // yield return null;
    }

    public override void Pause()
    {
    }
    
    public override void Resume()
    {
    }
}
