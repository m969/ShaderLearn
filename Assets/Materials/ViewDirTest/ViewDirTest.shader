Shader "Custom/ViewDirTest" {
	Properties {
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomLight

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = fixed4(1,1,1,1);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline float4 LightingCustomLight(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diffLight = dot(s.Normal, lightDir);
			//diffLight = floor(diffLight*10) / 10;
			float rim = dot(s.Normal, viewDir);
			/*float hRim = max(0, rim * 0.8 + 0.2);*/
			//if (rim < 0.2)
			//	rim = 0;
			//else
			//	rim = 1;
			rim = ceil(rim * 2) / 2;
			float4 col;
			col.rgb = viewDir;//s.Albedo * rim;
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
