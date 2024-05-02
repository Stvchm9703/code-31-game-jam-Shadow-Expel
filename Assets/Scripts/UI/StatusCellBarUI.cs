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
        Debug.Log("persentage : "+ persentage);
        
        int cell_index = (int) (persentage * this.cellCount);
        float cellPersentage = persentage * this.cellCount - cell_index;
        Debug.Log("cell_index : "+ cell_index); 
        Debug.Log("cellPersentage : "+ cellPersentage);
        if (cell_index == this.cellCount + 1)
        {
            return;
        }
        for (var i = 0; i < cell_index; i++)
        {
            cellValueBars[i].UpdateValue(1);
        }
        for (var i = cell_index + 1; i < this.cellCount; i++)
        {
            cellValueBars[i].UpdateValue(0);
        }
        if (cell_index < this.cellCount)
        {
            cellValueBars[cell_index].UpdateValue(cellPersentage);
        }
        
        
        // for (var i = 0; i < this.cellCount; i++)
        // { 
        //     var cellValueBar = this.cellValueBars[i];
        //     if ( i < persentage * this.cellCount)
        //     {
        //         cellValueBar.UpdateValue(10, 10);
        //     }
        //     else if (i < persentage * this.cellCount)
        //     {
        //         cellValueBar.UpdateValue(10 ,  10);
        //     }
        //     // else
        //     // {
        //     //     // cellValueBar.UpdateValue((persentage * 10) % 1);
        //     //     cellValueBar.UpdateValue(0);
        //     // }
        // }
    }
}