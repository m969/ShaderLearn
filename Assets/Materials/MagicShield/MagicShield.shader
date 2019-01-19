Shader "MagicFire/MagicShield"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Point ("Point", Vector) = (0,0,0,0)
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 p_off : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform float4 _Point;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.p_off = float4(0, 0, 0, 0);
				if (abs(_Point.y - v.vertex.y) < 1.0)
					o.p_off = float4(1.0, 0, 0, 0);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				if (i.p_off.x > 0.5)
					col = (0, 0, 0, 0);
				float y = i.vertex.y / 500;
				return col;
			}
			ENDCG
		}
	}
}
