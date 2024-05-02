using System.Collections;
using System.Collections.Generic;
using PrimeTween;
using UnityEngine;

public class StatusBarUI : MonoBehaviour
{
    public RectTransform statusBar;
    public RectTransform statusValueBar;
    // Start is called before the first frame update
    void Start()
    {
        if (statusBar == null)
        {
            statusBar = this.GetComponent<RectTransform>();
        }
        if (statusValueBar == null)
        {
            statusValueBar = statusBar.Find("value").GetComponent<RectTransform>();
        }
    }

    public void UpdateValue(float persentage)
    {
        
        statusValueBar.sizeDelta = new Vector2(
            (statusBar.sizeDelta.x - 10) * persentage, 
            statusValueBar.sizeDelta.y
        );

    }
    
    public void UpdateValue(float current, float max)
    {
        UpdateValue(current / max);
    }
}
