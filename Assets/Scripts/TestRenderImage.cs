using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour {
    public Shader currentShader;
    [Range(0f, 10f)]
    public float grayScaleAmount = 1f;
    [Range(0f, 1f)]
    public float depthPower = 1f;
    [Range(0f, 2f)]
    public float brightnessAmount = 1f;
    [Range(0f, 2f)]
    public float saturationAmount = 1f;
    [Range(0f, 3f)]
    public float contrastAmount = 1f;

    private Material currentMaterial;


    public Material material
    {
        get
        {
            if (currentMaterial == null)
            {
                currentMaterial = new Material(currentShader);
                currentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return currentMaterial;
        }
    }


    // Use this for initialization
    void Start () {
		if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        if (!currentShader && !currentShader.isSupported)
        {
            enabled = false;
        }
	}
	
	// Update is called once per frame
	void Update () {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
	}

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (currentShader != null)
        {
            //if (grayScaleAmount > 0)
            //    material.SetFloat("_LuminosityAmount", grayScaleAmount / 10);
            //if (depthPower > 0)
            //    material.SetFloat("_DepthPower", depthPower);
            material.SetFloat("_BrightnessAmount", brightnessAmount);
            material.SetFloat("_satAmount", saturationAmount);
            material.SetFloat("_conAmount", contrastAmount);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    void OnDisable()
    {
        if (currentMaterial)
            DestroyImmediate(currentMaterial);
    }
}
