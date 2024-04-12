using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PrimeTween;
public class LightModeSwitch : MonoBehaviour
{
    public int lightMode;
    public GameObject lampLight;
    public GameObject torchLight;
    // Start is called before the first frame update
    void Start()
    {
        TorchLightSwitch(true);
    }

    // Update is called once per frame
    void Update()
    {
        if (this.lightMode == 0)
        {
            TorchLightSwitch(true);
            LampLightSwitch(false);
        }
        else if (this.lightMode == 1)
        {
            TorchLightSwitch(false);
            LampLightSwitch(true);
        }
        
    }
    
    void TorchLightSwitch(bool on)
    {
        var light = this.torchLight.GetComponent<Light>();
        if (on)
        {
            Tween.LightIntensity(light, 3f, 0.15f);
            Tween.LightRange(light, 2.5f, 0.15f);
        }
        else
        {
            Tween.LightIntensity(light, 2f, 0.5f);
            Tween.LightRange(light, 2f, 0.5f);
        }
        
    }
    
    void LampLightSwitch(bool on)
    {
        var light = this.lampLight.GetComponent<Light>();
        if (on)
        {
            light.intensity = 1200f;
            light.range = 8f;
            lampLight.SetActive(true);
            // Tween.LightIntensity(light, 3f, 0.5f);
            // Tween.LightRange(light, 4.5f, 0.5f);
        }
        else
        {
            lampLight.SetActive(false);
        }
    }
    
}
