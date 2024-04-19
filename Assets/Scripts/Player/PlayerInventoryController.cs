using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Entities.UI;
using UnityEngine;
using Object = UnityEngine.Object;

[Serializable]
public struct InventoryItem
{
    string id;
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
    public List<InventoryItem> InventoryItems;
    public List<GameObject> InventoryItemsGO;
    
    public Canvas InventoryUI;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public void AddItem(InventoryItem item)
    {
        if (InventoryItems.Count < MaxInventorySize)
        {
            InventoryItems.Add(item);
        }
    }
    
    public void RemoveItem(InventoryItem item)
    {
        if (InventoryItems.Contains(item))
        {
            InventoryItems.Remove(item);
        }
    }
    
    public void RemoveItem(int index)
    {
        if (index < InventoryItems.Count)
        {
            InventoryItems.RemoveAt(index);
        }
    }
    
    public void ClearInventory()
    {
        InventoryItems.Clear();
    }
    
    public void UseItem(InventoryItem item)
    {
        // Use the item
        if (InventoryItems.Contains(item))
        {
            item.count--;
            if (item.count <= 0)
            {
                InventoryItems.Remove(item);
            }
        }
    }
    
    public void UseItem(int index)
    {
        if (index < InventoryItems.Count)
        {
            var item = InventoryItems[index];
            item.count--;
            if (item.count <= 0)
            {
                InventoryItems.Remove(item);
            }
        }
    }
    
    public void UseItem(string name)
    {
        var item = InventoryItems.Find(i => i.name == name);
        item.count--;
        if (item.count <= 0)
        {
            InventoryItems.Remove(item);
        }
    }
    
    public void OpenInventory()
    {
        // Open the inventory
        
    }
}
