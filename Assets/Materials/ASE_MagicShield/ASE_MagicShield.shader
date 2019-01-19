// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagicFire/ASE_MagicShield"
{
	Properties
	{
		_Metallic("Metallic", Range( 0 , 1)) = 0.4823529
		_Opacity("Opacity", Range( 0 , 1)) = 0.4823529
		_Emission("Emission", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert alpha:fade keepalpha noshadow 
		struct Input
		{
			half filler;
		};

		uniform float _Emission;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Albedo = float4(0,1,0.462069,0).rgb;
			float3 temp_cast_1 = (_Emission).xxx;
			o.Emission = temp_cast_1;
			o.Specular = _Metallic;
			o.Gloss = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15700
0;327;1339;701;852.9137;325.7773;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;52;-272.8168,149.6888;Float;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0.4823529;0.502;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-272.9137,77.22269;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0.233;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-273.9137,-77.77731;Float;False;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;0;0.066;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;-272.9137,-243.7773;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,1,0.462069,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-273.9137,-0.7773132;Float;False;Property;_Metallic;Metallic;0;0;Create;True;0;0;False;0;0.4823529;0.515;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;203.3,-237.6;Float;False;True;2;Float;ASEMaterialInspector;0;0;Lambert;MagicFire/ASE_MagicShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;0;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;54;0
WireConnection;0;2;55;0
WireConnection;0;3;58;0
WireConnection;0;4;56;0
WireConnection;0;9;52;0
ASEEND*/
//CHKSM=DBB2E9DA7829473C722DCD9EFFC95DEA70B5465A