Shader "Hidden/SceneDepth_ImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DepthPower ("Depth Power", Range(1, 5)) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite On ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			uniform sampler2D _MainTex;
			fixed _DepthPower;
			sampler2D _CameraDepthTexture;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				col = pow(Linear01Depth(col), _DepthPower);
				return col;
			}
			ENDCG
		}
	}
}
