using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BatteryItem: ISceneInteractable
{
    [Obsolete("Obsolete")]
    public override void Interact()
    {
        Debug.Log("Interacting with QuestItem " + gameObject.name);
        LightModeSwitch lightModeSwitch = FindObjectOfType<LightModeSwitch>();
        lightModeSwitch.AddPowerCell(3);
        Destroy(this.gameObject);
    }
}