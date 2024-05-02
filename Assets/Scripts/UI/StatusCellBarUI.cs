using System;
using System.Collections.Generic;
using UnityEngine;

public class StatusCellBarUI : MonoBehaviour
{
    public RectTransform statusBar;
    public List<StatusBarUI> cellValueBars;
    public GameObject cellBarPrefab;
    public int cellCount;

    private void Start()
    {
        if (this.statusBar == null) this.statusBar = this.GetComponent<RectTransform>();
        if (this.cellValueBars == null || this.cellValueBars.Count == 0)
        {
            this.cellValueBars = new List<StatusBarUI>();
            for (var i = 0; i < this.cellCount; i++)
            {
                GameObject cellBar = Instantiate(this.cellBarPrefab, this.statusBar);
                var cellBarRect = cellBar.GetComponent<RectTransform>();
                cellBarRect.anchoredPosition = new Vector2(i * (cellBarRect.sizeDelta.x + 5), 0 );
                
                this.cellValueBars.Add(cellBar.GetComponent<StatusBarUI>());
            }
        }
    }
    // persentage = 0.0f ~ 1.0f
    public void UpdateValue(float persentage)
    {
        for (var i = 0; i < this.cellCount; i++)
        {
            var cellValueBar = this.cellValueBars[i];
           if (i >= persentage * 10)
            {
                cellValueBar.UpdateValue(100);
            }
            else
            {
                cellValueBar.UpdateValue((persentage * 10) % 1);
            }
        }
    }
}