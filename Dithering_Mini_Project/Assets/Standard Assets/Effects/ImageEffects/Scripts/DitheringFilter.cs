using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode, ImageEffectAllowedInSceneView, RequireComponent(typeof(Camera))]

public class DitheringFilter : MonoBehaviour
{
	public Material ditherMaterial;
	[Range(0.0f, 1.0f)] 
	public float ditherStrength = 0.1f;
	[Range(1, 64)]
	public int colourDepth = 4;

	private void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		ditherMaterial.SetFloat("_DitherStrength", ditherStrength);
		ditherMaterial.SetInt("_ColourDepth", colourDepth);
		Graphics.Blit(src, dest, ditherMaterial);
	}
	
	
}
