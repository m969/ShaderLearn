Shader "Custom/BlinnPhong" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecPower ("Specular Power", Range(1.0, 20.0)) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Phong
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		float4 _Color;
		float _SpecPower;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVector = normalize(lightDir + viewDir);
			float diff = max(0, dot(s.Normal, lightDir));
			float spec = min(pow(max(0, dot(s.Normal, halfVector)), _SpecPower), 1);
			fixed3 finalDiffuseColor = _LightColor0.rgb * diff * atten;
			fixed3 finalSpecColor = _LightColor0.rgb * spec * atten;
			fixed4 c;
			c.rgb = s.Albedo * finalDiffuseColor * viewDir + finalSpecColor;
			c.a = 1.0;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
