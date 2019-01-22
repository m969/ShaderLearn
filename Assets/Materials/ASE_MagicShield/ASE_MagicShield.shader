// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagicFire/ASE_MagicShield"
{
	Properties
	{
		_Main("Main", 2D) = "bump" {}
		_Emission("Emission", Color) = (0,0,0,0)
		_Light("Light", Range( 0 , 2)) = 0.4
		_Opacity("Opacity", Range( 0 , 1)) = 0.4823529
		_Eimssion("Eimssion", Range( 0 , 1)) = 2
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
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

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Main = i.uv_texcoord * _Main_ST.xy + _Main_ST.zw;
			float2 panner72 = ( 0.5 * _Time.y * float2( 0.1,0.1 ) + uv_Main);
			float4 tex2DNode69 = tex2D( _Main, panner72 );
			SurfaceOutputStandard s82 = (SurfaceOutputStandard ) 0;
			float4 temp_output_75_0 = ( ( tex2DNode69 * _Emission ) + _Light );
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
			Unity_GlossyEnvironmentData g82 = UnityGlossyEnvironmentSetup( s82.Smoothness, data.worldViewDir, s82.Normal, float3(0,0,0));
			gi82 = UnityGlobalIllumination( data, s82.Occlusion, s82.Normal, g82 );
			#endif

			float3 surfResult82 = LightingStandard ( s82, viewDir, gi82 ).rgb;
			surfResult82 += s82.Emission;

			c.rgb = surfResult82;
			c.a = ( tex2DNode69 * _Opacity ).r;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Emission = ( _Emission * _Eimssion ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15700
0;413;1437;615;1064.039;328.5625;1.3;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-1533.9,-259.775;Float;False;0;67;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;72;-1254.897,-257.5706;Float;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;67;-1347.901,-80.65779;Float;True;Property;_Main;Main;0;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;False;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;69;-1060.901,-80.65779;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;-994.9147,131.2992;Float;False;Property;_Emission;Emission;1;0;Create;True;0;0;False;0;0,0,0,0;0,0.7103448,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-571.8195,-9.11129;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-705.4192,102.2888;Float;False;Property;_Light;Light;2;0;Create;True;0;0;False;0;0.4;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-189.8168,263.6888;Float;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;False;0;0.4823529;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-394.0457,-173.8674;Float;False;Property;_Eimssion;Eimssion;4;0;Create;True;0;0;False;0;2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-519.348,188.7582;Float;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;1;0.62;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-372.1685,-7.772804;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-55.04565,-190.8674;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-55.49084,-99.11319;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;82;-146.348,-7.241821;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;203.3,-237.6;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;MagicFire/ASE_MagicShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;72;0;73;0
WireConnection;69;0;67;0
WireConnection;69;1;72;0
WireConnection;70;0;69;0
WireConnection;70;1;77;0
WireConnection;75;0;70;0
WireConnection;75;1;65;0
WireConnection;78;0;77;0
WireConnection;78;1;79;0
WireConnection;84;0;69;0
WireConnection;84;1;52;0
WireConnection;82;0;75;0
WireConnection;82;2;75;0
WireConnection;82;4;83;0
WireConnection;0;2;78;0
WireConnection;0;9;84;0
WireConnection;0;13;82;0
ASEEND*/
//CHKSM=6ED3B6DF6EA802D0AC3F45F73918C74667F19A1F