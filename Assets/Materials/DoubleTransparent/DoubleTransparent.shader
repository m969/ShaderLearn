// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MagicFire/DoubleTransparent" {
	Properties{
		_Color0("Color 0", Color) = (0,0,0,0)
		//_Cubemap("Cubemap", CUBE) = ""{}
	}
	SubShader{
		Tags { "Queue" = "Transparent" }
		LOD 200

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float4 _Color0;

			float4 vert(float4 vertPos : POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(vertPos);
			}

			float4 frag(float4 vertPos : SV_POSITION) : COLOR
			{
				return fixed4(_Color0.rgb * 0.5, _Color0.a);
			}
			ENDCG
		}

		//Pass
		//{
		//	Blend SrcAlpha OneMinusSrcAlpha
		//	ZWrite Off
		//	Cull Back
		//	CGPROGRAM
		//	#pragma vertex vert
		//	#pragma fragment frag
		//	#include "UnityCG.cginc"

		//	uniform float4 _FrontColor;

		//	float4 vert(float4 vertPos : POSITION) : SV_POSITION
		//	{
		//		return UnityObjectToClipPos(vertPos);
		//	}

		//	float4 frag(float4 vertPos : SV_POSITION) : COLOR
		//	{
		//		return _FrontColor;
		//	}
		//	ENDCG
		//}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 

		struct Input
		{
			half filler;
		};

		uniform float4 _Color0;

		void surf(Input i, inout SurfaceOutputStandard o)
		{
			o.Albedo = _Color0.rgb;
			o.Alpha = _Color0.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}