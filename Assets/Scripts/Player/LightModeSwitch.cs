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

    public CapsuleCollider lampLightCollider;
    
    public int powerCellCount;

    public float lampLightMaxIntensity = 1500f,  lampLightMinIntensity = 700f;
    public float lampLightMaxRange = 8f, lampLightMinRange = 2f;

    public float lampLightMaxPower = 100f;
    [SerializeField] private float lampLightPower = 100f;


    // Start is called before the first frame update
    public StatusAnimationController statusAnimationController;

    

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
        statusAnimationController.UpdateTorchPowerBar(power);

        if (power > 0.7)
        {
            this.lampLightComponent.intensity = this.lampLightMaxIntensity;
            // this.lampLightComponent.range = this.lampLightMaxRange;
            lampLightCollider.height = 5f;
        }
        else if (power <= 0.7 && power >= 0.2)
        {
            this.lampLightComponent.intensity = Mathf.Lerp(this.lampLightMinIntensity, this.lampLightMaxIntensity, power);
            // this.lampLightComponent.range = Mathf.Lerp(this.lampLightMinRange, this.lampLightMaxRange, power);
            lampLightCollider.height = Mathf.Lerp(2f, 5f, power);

        }
        else if (power < 0.2)
        {
            this.lampLightComponent.intensity = this.lampLightMinIntensity;
            lampLightCollider.height = 2f;
        }
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