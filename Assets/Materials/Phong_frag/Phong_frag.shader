Shader "Unlit/Phong_frag"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_SpecularPower ("Specular Power", Range(1, 100)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
				fixed3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed3 normal : NORMAL;
				float3 worldPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _SpecularPower;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = normalize(UnityObjectToWorldNormal(v.normal));
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);

				//计算环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT * col.rgb;
				//计算漫反射光
				fixed diff = max(0, dot(lightDir, i.normal));
				fixed3 finalDiffuse = col.rgb * _LightColor0.rgb * diff;
				//计算镜面高光
				fixed3 r = normalize(reflect(-lightDir, i.normal));
				fixed spec = pow(max(0, dot(r, viewDir)), _SpecularPower);
				fixed3 finalSpec = _LightColor0.rgb * spec;

				col.rgb = ambient + finalDiffuse + finalSpec;
				return col;
			}
			ENDCG
		}
	}
}
