using System;
using PrimeTween;
using UnityEngine;

public class LightModeSwitch : MonoBehaviour
{
    public int lightMode;
    public GameObject lampLight;
    public GameObject torchLight;
    public Light torchLightComponent;
    public Light lampLightComponent;

    public int powerCellCount;
    public UIController uiController;

    public float lampLightMaxIntensity = 1500f;

    public float lampLightMinIntensity = 700f;

    public float lampLightMaxRange = 8f;

    public float lampLightMinRange = 2f;

    public float lampLightMaxPower = 100;


    // Start is called before the first frame update
    public StatusAnimationController statusAnimationController;

    private float lampLightPower = 100;

    public float torchLightIntensity => this.lampLightMinIntensity + this.lampLightPower / this.lampLightMaxPower * (this.lampLightMaxIntensity - this.lampLightMinIntensity);

    public float torchLightRange => this.lampLightMinRange + this.lampLightPower / this.lampLightMaxPower * (this.lampLightMaxRange - this.lampLightMinRange);

    private void Start()
    {
        if (this.torchLightComponent == null) this.torchLightComponent = this.torchLight.GetComponent<Light>();
        if (this.lampLightComponent == null) this.lampLightComponent = this.lampLight.GetComponent<Light>();
        // TorchLightSwitch(true);
        this.SwitchLightMode(0);
    }

    private void FixedUpdate()
    {
        this.UpdateLampLightPower(Time.fixedTime);
    }

    private void UpdateLampLightPower(float deltaTime)
    {
        // torchLightIntensity = (torchLightPower / torchLightMaxPower) * torchLightMaxIntensity;
        // var target = this.torchLight.GetComponent<Light>();
        // target.intensity = torchLightIntensity;

        // torch power comsumption
        if (this.lightMode == 0)
            // recharge 
            this.lampLightPower = Math.Clamp(this.lampLightPower + deltaTime * 3.5f, 0f, this.lampLightMaxPower);
        else if (this.lightMode == 1)
            // consume
            this.lampLightPower = Math.Clamp(this.lampLightPower - deltaTime * 5f, 0f, this.lampLightMaxPower);
    }

    public void SwitchLightMode(int mode)
    {
        this.lightMode = mode;
        if (this.lightMode == 0)
        {
            this.TorchLightSwitch(true);
            this.LampLightSwitch(false);
        }
        else if (this.lightMode == 1)
        {
            this.TorchLightSwitch(false);
            this.LampLightSwitch(true);
        }
    }

    private void TorchLightSwitch(bool on)
    {
        if (on)
        {
            Tween.LightIntensity(this.torchLightComponent, 3f, 0.15f);
            Tween.LightRange(this.torchLightComponent, 2.5f, 0.15f);
        }
        else
        {
            Tween.LightIntensity(this.torchLightComponent, 2.5f, 0.15f);
            Tween.LightRange(this.torchLightComponent, 2f, 0.15f);
        }
    }

    private void LampLightSwitch(bool on)
    {
        // var light = this.lampLight.GetComponent<Light>();
        if (on)
            this.lampLight.SetActive(true);
        else
            this.lampLight.SetActive(false);
    }
}