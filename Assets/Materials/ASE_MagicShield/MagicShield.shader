Shader "MagicFire/MagicShield"
{
	Properties
	{
		_Main("Main", 2D) = "bump" {}
		_Emission("Emission", Color) = (0,0,0,0)
		_Light("Light", Range(0 , 2)) = 0.4
		_Opacity("Opacity", Range(0 , 1)) = 0.4823529
		_Eimssion("Eimssion", Range(0 , 1)) = 2
		_Smoothness("Smoothness", Range(0 , 1)) = 1
		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Emission;
		uniform float _Eimssion;
		uniform sampler2D _Main;
		uniform float4 _Main_ST;
		uniform float _Opacity;
		uniform float _Light;
		uniform float _Smoothness;
		uniform float4 _Array[20];

		inline half4 LightingStandardCustomLighting(inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi)
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Main = i.uv_texcoord * _Main_ST.xy + _Main_ST.zw;
			float2 panner72 = (0.5 * _Time.y * float2(0.1,0.1) + uv_Main);
			float4 tex2DNode69 = tex2D(_Main, panner72);
			SurfaceOutputStandard s82 = (SurfaceOutputStandard)0;
			float4 temp_output_75_0 = ((tex2DNode69 * _Emission) + _Light);
			s82.Albedo = temp_output_75_0.rgb;
			float3 ase_worldNormal = i.worldNormal;
			s82.Normal = ase_worldNormal;
			s82.Emission = temp_output_75_0.rgb;
			s82.Metallic = 0.0;
			s82.Smoothness = _Smoothness;
			s82.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi82 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g82 = UnityGlossyEnvironmentSetup(s82.Smoothness, data.worldViewDir, s82.Normal, float3(0,0,0));
			gi82 = UnityGlobalIllumination(data, s82.Occlusion, s82.Normal, g82);
			#endif

			float3 surfResult82 = LightingStandard(s82, viewDir, gi82).rgb;
			surfResult82 += s82.Emission;

			c.rgb = surfResult82;
			c.a = (tex2DNode69 * _Opacity).r;
			return c;
		}

		inline void LightingStandardCustomLighting_GI(inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi)
		{
			s.GIData = data;
		}

		void surf(Input i , inout SurfaceOutputCustomLightingCustom o)
		{
			float dist = 0;
			float3 color = float3(0, 0, 0);
			float3 color1 = float3(0.5, 0.5, 0.5);
			float3 ase_vertex3Pos = mul(unity_WorldToObject, float4(i.worldPos, 1));
			int count = 0;
			for (count = 0; count < 10; count++)
			{
				float3 hitPos = mul(unity_WorldToObject, float4(_Array[count].xyz, 1));
				dist = distance(ase_vertex3Pos, hitPos);
				color = (((dist < _Array[count].w) ? (dist * color1) : color)).xxx;
			}
			o.SurfInput = i;
			o.Emission = (_Emission * _Eimssion).rgb + color;
		}

		ENDCG
	}
}