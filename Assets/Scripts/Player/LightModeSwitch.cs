using System;
using PrimeTween;
using UnityEngine;
using UnityEngine.Serialization;

public class LightModeSwitch : MonoBehaviour
{
    public int lightMode;
    public GameObject lampLight;
    public GameObject torchLight;
    public Light torchLightComponent;
    public Light lampLightComponent;

    public int powerCellCount;

    public float lampLightMaxIntensity = 1500f,  lampLightMinIntensity = 700f;
    public float lampLightMaxRange = 8f, lampLightMinRange = 2f;

    public float lampLightMaxPower = 100f;
    [SerializeField] private float lampLightPower = 100f;


    // Start is called before the first frame update
    public StatusAnimationController statusAnimationController;


    public float lampLightIntensity  {
        get
        {
            var intensity = this.lampLightMinIntensity + this.lampLightPower / this.lampLightMaxPower * (this.lampLightMaxIntensity - this.lampLightMinIntensity);
            return (float) Math.Round(intensity);
        }
    }

    public float lampLightRange
    {
        get
        {
            var range = this.lampLightMinRange + this.lampLightPower / this.lampLightMaxPower * (this.lampLightMaxRange - this.lampLightMinRange);
            return (float) Math.Round(range );
        }
    }
    

    private void Start()
    {
        if (this.torchLightComponent == null) this.torchLightComponent = this.torchLight.GetComponent<Light>();
        if (this.lampLightComponent == null) this.lampLightComponent = this.lampLight.GetComponent<Light>();
        // if (this.statusAnimationController == null) this.statusAnimationController = this.GetComponent<StatusAnimationController>();
        // TorchLightSwitch(true);
        this.lampLightPower = this.lampLightMaxPower;
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
            this.lampLightPower = Math.Clamp(this.lampLightPower + (deltaTime / 30f), 0f, this.lampLightMaxPower);
        else if (this.lightMode == 1)
            // consume
            this.lampLightPower = Math.Clamp(this.lampLightPower - (deltaTime / 15f), 0f, this.lampLightMaxPower);

        var power = this.lampLightPower / this.lampLightMaxPower;
        statusAnimationController.UpdateTorchPowerBar( power );
        
        // if (this.lampLightComponent.intensity != this.lampLightIntensity)
        // {
        //     Tween.LightIntensity(this.lampLightComponent, this.lampLightIntensity, 0.15f);
        // }

        // if (this.lampLightComponent.range != this.lampLightRange)
        // {
        //     Tween.LightRange(this.lampLightComponent, this.lampLightRange, 0.15f);
        // }
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
        this.lampLight.SetActive(on);
    }
}