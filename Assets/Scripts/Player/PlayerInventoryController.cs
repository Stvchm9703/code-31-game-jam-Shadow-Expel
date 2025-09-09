using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.Entities.UI;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
using Object = UnityEngine.Object;

[Serializable]
public struct InventoryItem
{
    public string uid;
    public string name;
    [TextArea(15,20)] 
    public string description;
    [MinValue(1)]
    public int count;
    // public ref GameObject item;
    public Texture2D icon;
}
public class PlayerInventoryController : MonoBehaviour
{
    public int MaxInventorySize = 12;
    public List<InventoryItem> inventoryItems;
    // public List<GameObject> InventoryItemsGO;
    
    public Canvas InventoryUI;
    // Start is called before the first frame update
    public TextMeshProUGUI text;
    public int targetCount;
    public string targetScene;
    public void AddItem(InventoryItem item)
    {
        var index = this.inventoryItems.FindIndex(i => i.uid == item.uid);
        if (index != -1)
        {
            // Debug.Log(this.inventoryItems[index].count);
            InventoryItem inventoryItem = this.inventoryItems[index];
            inventoryItem.count += item.count;
            this.inventoryItems[index] = inventoryItem;
        }
        else if ( index == -1 && this.inventoryItems.Count < MaxInventorySize)
        {
            this.inventoryItems.Add(item);
        }
        else
        {
            Debug.Log("Inventory is full");
        }
        
        if (item.uid == "quest_item")
        {
            var currentCount = this.inventoryItems.Find(i => i.uid == "quest_item").count;
            text.text =  currentCount + "/" + targetCount;
            if (currentCount == targetCount)
            {
                // Exit the level
                SceneManager.LoadScene(targetScene);
            }
        }
        
        Debug.Log("InventoryItems" );
        Debug.Log(inventoryItems);
    }
    
    public void RemoveItem(InventoryItem item)
    {
        var existingItem = this.inventoryItems.Find(i => i.uid == item.uid);
        if (!existingItem.IsUnityNull())
        {
            existingItem.count -= item.count;
        } 
        if (this.inventoryItems.Count == 0)
        {
            this.inventoryItems.Remove(item);
        }
    }
    
    public void RemoveItem(int index)
    {
        if (index < this.inventoryItems.Count)
        {
            this.inventoryItems.RemoveAt(index);
        }
    }
    
    public void ClearInventory()
    {
        this.inventoryItems.Clear();
    }
    
    public void UseItem(InventoryItem item)
    {
        // Use the item
        if (this.inventoryItems.Contains(item))
        {
            item.count--;
            if (item.count <= 0)
            {
                this.inventoryItems.Remove(item);
            }
        }
    }
    
    public void UseItem(int index)
    {
        if (index < this.inventoryItems.Count)
        {
            var item = this.inventoryItems[index];
            item.count--;
            if (item.count <= 0)
            {
                this.inventoryItems.Remove(item);
            }
        }
    }
    
    public void UseItem(string name)
    {
        var item = this.inventoryItems.Find(i => i.name == name);
        item.count--;
        if (item.count <= 0)
        {
            this.inventoryItems.Remove(item);
        }
    }
    
    public void OpenInventory()
    {
        // Open the inventory
        
    }
}
