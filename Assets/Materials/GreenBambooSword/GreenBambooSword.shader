Shader "MagicFire/GreenBambooSword"
{
	Properties
	{
		_Color ("Color", COLOR) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0
		_Opacity ("Opacity", Range(0, 1)) = 1
		_Emission ("Emission", Range(0, 100)) = 0
	}
	SubShader
	{
		//Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 worldPos : TEXCOORD1;
				float3 normal : NORMAL;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Smoothness;
			fixed _Opacity;
			float _Emission;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = half2(o.uv.x - _Time.x, o.uv.y - _Time.x);
				//o.normal = UnityObjectToWorldNormal(v.normal);
				o.normal = mul(unity_ObjectToWorld, v.normal);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
				fixed3 normal = normalize(i.normal);

				fixed4 col = tex2D(_MainTex, i.uv);
				fixed p = col.r;
				//col = max(0.5, col.r) * _Color;
				//col = (col.r + 0.5) * _Color;
				col = (col.r + 0.1)  * _Color;

				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.rgb * col.rgb * 0.2;

				half diff = max(0, dot(lightDir, normal));
				fixed3 diffColor = col.rgb * diff;

				fixed3 r = normalize(reflect(-lightDir, normal));
				half spec =  pow(max(0, dot(viewDir, r)), _Smoothness * 40 + 1);
				fixed3 specColor = spec * (_LightColor0.rgb);

				col.rgb = ambientColor + diffColor + specColor + _Color.rgb * _Emission * 0.01 * p;
				// col.rgb = lightDir;

				col.a = _Opacity;
				return col;
			}
			ENDCG
		}
	}
}
