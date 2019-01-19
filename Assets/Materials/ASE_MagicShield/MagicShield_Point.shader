Shader "MagicFire/MagicShield_Point"
{
	Properties
	{
		_Point0("Point0", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
		};

		float4 _Point0;
		float4 _Array[20];

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float dist = 0;
			float3 color = float3(0.5,0.5,0.5);
			float3 ase_vertex3Pos = mul(unity_WorldToObject, float4(i.worldPos, 1));
			int count = 0;
			for (count = 0; count < 10; count++)
			{
				dist = distance(ase_vertex3Pos, _Array[count].xyz);
				color = (((dist < _Array[count].w) ? (dist * 0.2) : color)).xxx;
			}
			o.Emission = color;
			o.Alpha = color;
		}

		ENDCG
	}
}