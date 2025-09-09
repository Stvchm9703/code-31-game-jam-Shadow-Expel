using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuestItem : ISceneInteractable
{
    [Obsolete("Obsolete")]
    public override void Interact()
    {
        Debug.Log("Interacting with QuestItem " + gameObject.name);
        PlayerInventoryController playerInventoryController = FindObjectOfType<PlayerInventoryController>();
        // playerInventoryController.AddQuestItem(this);
        InventoryItem item = new InventoryItem
        {
            uid = "quest_item",
            name = "Quest Item",
            description = "A quest item",
            count = 1,
            icon = null
        };
        playerInventoryController.AddItem(item);
        Destroy(this.gameObject);
    }
}