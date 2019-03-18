﻿Shader "MagicFire/GreenBambooSword"
{
	Properties
	{
		_Color ("Color", COLOR) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_SpecPower ("SpecPower", Range(1, 20)) = 10
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 worldPos : TEXCOORD1;
				float3 normal : NORMAL;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _SpecPower;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = half2(o.uv.x - _Time.x, o.uv.y - _Time.x);
				o.normal = UnityObjectToWorldNormal(v.normal);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
				fixed3 normal = normalize(i.normal);

				fixed4 col = tex2D(_MainTex, i.uv);
				//col = max(0.5, col.r) * _Color;
				//col = (col.r + 0.5) * _Color;
				col = (col.r + 0.1) * 2 * _Color;

				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT * col.rgb;

				half diff = max(0, dot(lightDir, normal));
				fixed3 diffColor = col.rgb * diff;

				fixed3 r = normalize(reflect(-lightDir, normal));
				half spec =  pow(max(0, dot(viewDir, r)), _SpecPower);
				fixed3 specColor = spec * (_Color.rgb);

				col.rgb = ambientColor + diffColor + specColor;

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}