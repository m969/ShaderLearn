Shader "Custom/Phong" {
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
			//计算环境光
			fixed3 ambient = s.Albedo * UNITY_LIGHTMODEL_AMBIENT;
			
			//计算漫反射光
			float diff = max(0, dot(s.Normal, lightDir));
			fixed3 finalDiffuse = s.Albedo * _LightColor0.rgb * diff * atten * viewDir;
			
			//计算镜面高光
			fixed3 r = normalize(reflect(-lightDir, s.Normal));
			float spec = pow(max(0, dot(r, viewDir)), _SpecPower);
			fixed3 finalSpec = _LightColor0.rgb * spec * atten;

			fixed4 c;
			c.rgb = ambient + finalDiffuse + finalSpec;
			c.a = 1.0;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

			//float3 r2 = normalize(2.5 * s.Normal * diff - lightDir);