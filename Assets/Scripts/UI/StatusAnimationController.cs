using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StatusAnimationController : MonoBehaviour
{
    public StatusBarUI HpBar;
    public StatusBarUI DashBar;
    public StatusCellBarUI TorchPowerBar;
    
    public void UpdateHpBar(float persentage)
    {
        HpBar.UpdateValue(persentage);
    }
    public void UpdateDashBar(float persentage)
    {
        DashBar.UpdateValue(persentage);
    }
    public void UpdateTorchPowerBar(float persentage)
    {
        TorchPowerBar.UpdateValue(persentage);
    }
}
