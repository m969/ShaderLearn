// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagicFire/Burn"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_DistortionAmount("Distortion Amount", Range( 0 , 1)) = 0
		_ScrollSpeed("Scroll Speed", Range( 0 , 1)) = 0
		_Burn("Burn", Range( 0 , 1)) = 0.2243384
		_Hot("Hot", Color) = (1,0.04901961,0,0)
		_Warm("Warm", Color) = (0.9339623,0.773501,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_HeatWave("Heat Wave", Range( 0 , 0.1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1.1)) = 0.4844675
		_WiggleAmount("Wiggle Amount", Range( 0 , 0.01)) = 0.5698488
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _DistortionMap;
		uniform sampler2D _Mask;
		uniform float _HeatWave;
		uniform float _Burn;
		uniform float _WiggleAmount;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Warm;
		uniform float4 _Hot;
		uniform float4 _DistortionMap_ST;
		uniform float _DistortionAmount;
		uniform float _ScrollSpeed;
		uniform float _DissolveAmount;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 panner43 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + v.texcoord.xy);
			float2 temp_output_45_0 = (UnpackNormal( tex2Dlod( _DistortionMap, float4( panner43, 0, 0.0) ) )).xy;
			float4 tex2DNode32 = tex2Dlod( _Mask, float4( ( ( temp_output_45_0 * _HeatWave ) + v.texcoord.xy ), 0, 0.0) );
			float temp_output_33_0 = step( tex2DNode32.r , _Burn );
			v.vertex.xyz += ( ( ( ase_worldPos * ase_vertex3Pos ) * float3( temp_output_45_0 ,  0.0 ) * temp_output_33_0 ) * _WiggleAmount );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_DistortionMap = i.uv_texcoord * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
			float2 panner18 = ( ( _Time.y * _ScrollSpeed ) * float2( 1,0 ) + float2( 0,0 ));
			float2 uv_TexCoord10 = i.uv_texcoord + panner18;
			float4 lerpResult27 = lerp( _Warm , _Hot , tex2D( _Mask, ( ( (UnpackNormal( tex2D( _DistortionMap, uv_DistortionMap ) )).xy * _DistortionAmount ) + uv_TexCoord10 ) ).r);
			float4 temp_cast_1 = (4.0).xxxx;
			float2 panner43 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + i.uv_texcoord);
			float2 temp_output_45_0 = (UnpackNormal( tex2D( _DistortionMap, panner43 ) )).xy;
			float4 tex2DNode32 = tex2D( _Mask, ( ( temp_output_45_0 * _HeatWave ) + i.uv_texcoord ) );
			float temp_output_33_0 = step( tex2DNode32.r , _Burn );
			float temp_output_52_0 = step( tex2DNode32.r , ( 1.0 - ( _DissolveAmount / 1.1 ) ) );
			float temp_output_54_0 = ( temp_output_52_0 - step( tex2DNode32.r , ( 1.0 - _DissolveAmount ) ) );
			float4 temp_cast_2 = (temp_output_54_0).xxxx;
			float4 temp_cast_3 = (temp_output_54_0).xxxx;
			float4 temp_cast_4 = (temp_output_54_0).xxxx;
			float4 temp_cast_5 = (temp_output_54_0).xxxx;
			o.Emission = ( ( ( ( ( ( pow( lerpResult27 , temp_cast_1 ) * 4.0 ) * ( temp_output_33_0 + ( temp_output_33_0 - step( tex2DNode32.r , ( _Burn / 1.1 ) ) ) ) ) - temp_cast_2 ) - temp_cast_3 ) - temp_cast_4 ) - temp_cast_5 ).rgb;
			o.Alpha = temp_output_52_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15700
7;29;1906;1014;713.4093;1335.337;1.3;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-2313.752,1033.081;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1727.709,-50.71591;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;43;-2012.124,1036.831;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1782.952,187.0613;Float;False;Property;_ScrollSpeed;Scroll Speed;4;0;Create;True;0;0;False;0;0;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1899.126,-501.4871;Float;True;Property;_DistortionMap;Distortion Map;2;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1457.308,-2.615963;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1567.72,-454.3032;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1689.021,1002.183;Float;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1212.643,-234.4653;Float;False;Property;_DistortionAmount;Distortion Amount;3;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;45;-1350.702,984.7393;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1352.161,1243.24;Float;False;Property;_HeatWave;Heat Wave;9;0;Create;True;0;0;False;0;0;0.005;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;-1192.584,21.36896;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-1206.319,-442.703;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-967.2062,992.0026;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-857.4443,-397.6289;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-861.3554,-90.9819;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-970.4528,1361.708;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;4;-596.029,-571.5336;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;None;e1b1eaa7062b2884da5dd30fcde617a4;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-580.0944,-239.6129;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-677.8526,1196.408;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;182.9943,809.8756;Float;False;Property;_Burn;Burn;5;0;Create;True;0;0;False;0;0.2243384;0.57;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;201.7203,1201.586;Float;False;Constant;_DivideAmount;Divide Amount;7;0;Create;True;0;0;False;0;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;364.8339,-882.9926;Float;False;Property;_Warm;Warm;7;0;Create;True;0;0;False;0;0.9339623,0.773501,0,0;0.7720588,0.4632353,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;194.4417,550.1274;Float;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-215.5122,-375.3708;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;709.0419,945.1273;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;182.065,1679.423;Float;False;Property;_DissolveAmount;Dissolve Amount;10;0;Create;True;0;0;False;0;0.4844675;0.22;0;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;362.2344,-695.7936;Float;False;Property;_Hot;Hot;6;0;Create;True;0;0;False;0;1,0.04901961,0,0;0.7279412,0.6777383,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;57;695.7105,1673.724;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;33;719.7534,583.527;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;719.7343,-739.9936;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;37;1021.042,933.9273;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;723.6339,-499.4944;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;1055.749,-744.1342;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;51;1195.606,1879.298;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;1308.665,796.6671;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;50;1190.59,1594.576;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;53;1572.289,1890.544;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1377.926,-740.8439;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;52;1567.396,1628.282;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;1550.643,581.9273;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1967.37,-121.3783;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;2102.48,1598.512;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;2550.525,-387.6703;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;2510.946,600.2491;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;58;2556.637,-124.7127;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;2836.081,-256.2272;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;2764.358,816.1;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;3045.715,250.3239;Float;False;Property;_WiggleAmount;Wiggle Amount;11;0;Create;True;0;0;False;0;0.5698488;0.0009;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;3112.376,-144.3617;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;3037.498,1029.971;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;36;3349.386,-820.7969;Float;True;Property;_Albedo;Albedo;8;0;Create;True;0;0;False;0;None;1ccf5fe447b9e074089df21063ac1fd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;3409.391,119.0436;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;3305.863,1258.859;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3685.79,-59.29973;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MagicFire/Burn;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;44;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;6;0;5;0
WireConnection;42;0;5;0
WireConnection;42;1;43;0
WireConnection;45;0;42;0
WireConnection;18;1;21;0
WireConnection;7;0;6;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;10;1;18;0
WireConnection;11;0;8;0
WireConnection;11;1;10;0
WireConnection;49;0;46;0
WireConnection;49;1;48;0
WireConnection;32;0;4;0
WireConnection;32;1;49;0
WireConnection;2;0;4;0
WireConnection;2;1;11;0
WireConnection;38;0;34;0
WireConnection;38;1;39;0
WireConnection;57;0;56;0
WireConnection;57;1;39;0
WireConnection;33;0;32;1
WireConnection;33;1;34;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;27;2;2;1
WireConnection;37;0;32;1
WireConnection;37;1;38;0
WireConnection;29;0;27;0
WireConnection;29;1;31;0
WireConnection;51;0;56;0
WireConnection;40;0;33;0
WireConnection;40;1;37;0
WireConnection;50;0;57;0
WireConnection;53;0;32;1
WireConnection;53;1;51;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;52;0;32;1
WireConnection;52;1;50;0
WireConnection;41;0;33;0
WireConnection;41;1;40;0
WireConnection;35;0;30;0
WireConnection;35;1;41;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;55;0;35;0
WireConnection;55;1;54;0
WireConnection;61;0;60;0
WireConnection;61;1;58;0
WireConnection;64;0;55;0
WireConnection;64;1;54;0
WireConnection;59;0;61;0
WireConnection;59;1;45;0
WireConnection;59;2;33;0
WireConnection;65;0;64;0
WireConnection;65;1;54;0
WireConnection;63;0;59;0
WireConnection;63;1;62;0
WireConnection;66;0;65;0
WireConnection;66;1;54;0
WireConnection;0;0;36;0
WireConnection;0;2;66;0
WireConnection;0;9;52;0
WireConnection;0;11;63;0
ASEEND*/
//CHKSM=3AB5AB83A077A0CCEEDC1AD42603BA2553166E3C