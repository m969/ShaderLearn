// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagicFire/Water"
{
	Properties
	{
		_ColorShallow("Color (Shallow)", Color) = (0,0.2941177,0.2078431,0)
		_ColorDeep("Color (Deep)", Color) = (0,0.1803922,0.1254902,0)
		_Glossiness("Glossiness", Range( 0 , 1)) = 0.75
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalBlendStrength("Normal Blend Strength", Range( 0 , 1)) = 0
		_NormalMap1Strength("Normal Map 1 Strength", Range( 0 , 1)) = 0
		_NormalMap2Strength("Normal Map 2 Strength", Range( 0 , 1)) = 0
		_UVScale("UV Scale", Float) = 1
		_UV1Tiling("UV 1 Tiling", Float) = 0
		_UV2Tiling("UV 2 Tiling", Float) = 0
		_UV1Animator("UV 1 Animator", Vector) = (0,0,0,0)
		_UV2Animator("UV 2 Animator", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalMap;
		uniform float _NormalMap1Strength;
		uniform float2 _UV1Animator;
		uniform float _UVScale;
		uniform float _UV1Tiling;
		uniform float _NormalMap2Strength;
		uniform float2 _UV2Animator;
		uniform float _UV2Tiling;
		uniform float _NormalBlendStrength;
		uniform float4 _ColorDeep;
		uniform float4 _ColorShallow;
		uniform float _Glossiness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult19 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 _worldUV22 = ( appendResult19 / _UVScale );
			float2 panner29 = ( _Time.x * _UV1Animator + ( _worldUV22 * _UV1Tiling ));
			float2 _UV141 = panner29;
			float2 panner30 = ( _Time.x * _UV2Animator + ( _worldUV22 * _UV2Tiling ));
			float2 _UV242 = panner30;
			float3 lerpResult4 = lerp( UnpackScaleNormal( tex2D( _NormalMap, _UV141 ), _NormalMap1Strength ) , UnpackScaleNormal( tex2D( _NormalMap, _UV242 ), _NormalMap2Strength ) , _NormalBlendStrength);
			float3 _normalMap12 = lerpResult4;
			o.Normal = _normalMap12;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV14 = dot( _normalMap12, ase_worldViewDir );
			float fresnelNode14 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV14, 1.336 ) );
			float4 lerpResult11 = lerp( _ColorDeep , _ColorShallow , fresnelNode14);
			float4 _color16 = lerpResult11;
			o.Albedo = _color16.rgb;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15700
0;92;1412;480;2319;-185.4947;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;45;-1960.334,-1215.589;Float;False;1307.833;614.6536;UV 1 and 2;19;33;34;28;26;39;38;31;37;32;40;30;29;41;42;48;49;50;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1857.353,-584.6671;Float;False;1207.816;691.6169;Color;6;15;9;14;10;11;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1887.509,127.3669;Float;False;1234.871;652.6294;Normal Map;10;5;1;6;7;3;2;4;12;43;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1664.718,-1592.372;Float;False;1003.104;344.3098;World UV;5;18;19;20;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-1478.434,419.6586;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-892.5334,-411.2758;Float;False;_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1637.535,-900.2913;Float;False;Property;_UV2Tiling;UV 2 Tiling;9;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-1154.927,-419.7842;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-899.501,-1091.395;Float;False;_UV1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-895.501,-929.3951;Float;False;_UV2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-331.2917,-93.32761;Float;False;Property;_Glossiness;Glossiness;2;0;Create;True;0;0;False;0;0.75;0.79;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1421.534,-1165.589;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-895.6389,310.3587;Float;False;_normalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;48;-1677.718,-1174.945;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-1197.334,-1111.889;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1841.319,672.0699;Float;False;Property;_NormalMap2Strength;Normal Map 2 Strength;6;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-1103.509,310.9968;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;51;-1677.718,-954.2146;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1829.295,365.4403;Float;True;Property;_NormalMap;Normal Map;3;0;Create;True;0;0;False;0;None;f9b742b3aabf4744d8997ecc849ccbdb;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-904.6137,-1509.062;Float;False;_worldUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;40;-1459.85,-956.6362;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;52;-1490.849,-930.3856;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1841.319,584.0704;Float;False;Property;_NormalMap1Strength;Normal Map 1 Strength;5;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1418.934,-916.0895;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1474.458,650.2872;Float;False;Property;_NormalBlendStrength;Normal Blend Strength;4;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-1196.334,-967.8888;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;49;-1484.578,-1174.945;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;14;-1516.598,-146.0497;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1.336;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;-264.5653,-170.9892;Float;False;12;_normalMap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1638.633,-1147.188;Float;False;Property;_UV1Tiling;UV 1 Tiling;8;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1333.614,-1519.062;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;28;-1910.334,-1008.889;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;37;-1640.835,-828.2912;Float;False;Property;_UV2Animator;UV 2 Animator;11;0;Create;True;0;0;False;0;0,0;1,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;18;-1614.718,-1542.372;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;2;-1485.134,217.5576;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-1515.598,-348.8681;Float;False;Property;_ColorShallow;Color (Shallow);0;0;Create;True;0;0;False;0;0,0.2941177,0.2078431,0;0,0.3773581,0.2365346,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1807.353,-151.7233;Float;False;12;_normalMap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1332.614,-1367.062;Float;False;Property;_UVScale;UV Scale;7;0;Create;True;0;0;False;0;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-1518.016,-534.6673;Float;False;Property;_ColorDeep;Color (Deep);1;0;Create;True;0;0;False;0;0,0.1803922,0.1254902,0;0,0.160377,0.1115665,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;39;-1635.153,-682.9353;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;50;-1270.119,-813.7495;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1828.743,183.4357;Float;False;41;_UV1;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1827.933,263.4472;Float;False;42;_UV2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-239.034,-261.7652;Float;False;16;_color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1907.334,-1117.889;Float;False;22;_worldUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;38;-1338.752,-755.934;Float;False;Property;_UV1Animator;UV 1 Animator;10;0;Create;True;0;0;False;0;0,0;0.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1109.614,-1518.062;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;36,-260;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MagicFire/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;44;0
WireConnection;3;5;6;0
WireConnection;16;0;11;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;11;2;14;0
WireConnection;41;0;29;0
WireConnection;42;0;30;0
WireConnection;31;0;49;0
WireConnection;31;1;34;0
WireConnection;12;0;4;0
WireConnection;48;0;26;0
WireConnection;29;0;31;0
WireConnection;29;2;38;0
WireConnection;29;1;40;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;7;0
WireConnection;51;0;26;0
WireConnection;22;0;20;0
WireConnection;40;0;28;1
WireConnection;52;0;51;0
WireConnection;32;0;52;0
WireConnection;32;1;33;0
WireConnection;30;0;32;0
WireConnection;30;2;50;0
WireConnection;30;1;39;0
WireConnection;49;0;48;0
WireConnection;14;0;15;0
WireConnection;19;0;18;1
WireConnection;19;1;18;3
WireConnection;2;0;1;0
WireConnection;2;1;43;0
WireConnection;2;5;5;0
WireConnection;39;0;28;1
WireConnection;50;0;37;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;0;0;17;0
WireConnection;0;1;13;0
WireConnection;0;4;46;0
ASEEND*/
//CHKSM=7100C32559CDE8FAB5229FE7EE1AE0F696009C2B