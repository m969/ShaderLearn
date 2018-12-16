using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralTextureTest : MonoBehaviour {
	#region Public Variables
	public int widthHeight = 512;
	public Texture2D generatedTexture;
	#endregion

	#region Private Variables
	private Material currentMaterial;
	private Vector2 centerPosition;
	#endregion

	// Use this for initialization
	void Start () {
		if (!currentMaterial)
		{
			currentMaterial = transform.GetComponent<Renderer>().sharedMaterial;
			if (!currentMaterial)
			{
				Debug.Log("Cannot find a material on: " + transform.name);
			}
		}
		if (currentMaterial)
		{
			centerPosition = new Vector2(0.5f, 0.5f);
			generatedTexture = GenerateParabola();
			currentMaterial.SetTexture("_MainTex", generatedTexture);
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	private Texture2D GenerateParabola()
	{
		Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);
		Vector2 centerPixelPosition = centerPosition * widthHeight;
		for (int x = 0; x < widthHeight; x++)
		{
			for (int y = 0; y < widthHeight; y++)
			{
				Vector2 currentPosition = new Vector2(x, y);
				float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);
				pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));
				Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
				proceduralTexture.SetPixel(x, y, pixelColor);
			}
		}
		proceduralTexture.Apply();
		return proceduralTexture;
	}
}
