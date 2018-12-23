Shader "Custom/MetallicSoft" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RoughnessTex("Roughness Texture", 2D) = "white" {}
		_Roughness ("Roughness", Range(0, 1)) = 0.5
		_SpecPower ("Specular Power", Range(0,30)) = 2.0
		_Fresnel ("Fresnel Value", Range(0,1.0)) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf MetallicSoft

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RoughnessTex;
		half _Roughness;
		half _Fresnel;
		half _SpecPower;
		fixed4 _Color;

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
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingMetallicSoft(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize(lightDir + viewDir);
			fixed NdotL = max(0.05, (dot(s.Normal, normalize(lightDir))));
			fixed NdotH = saturate(dot(s.Normal, halfVector));
			fixed NdotV = saturate(dot(s.Normal, normalize(viewDir)));
			fixed VdotH = saturate(dot(halfVector, normalize(viewDir)));
			////Micro facets distribution
			//fixed geoEnum = 2.0 * NdotH;
			//fixed3 G1 = (geoEnum * NdotV) / NdotH;
			//fixed3 G2 = (geoEnum * NdotL) / NdotH;
			//fixed3 G = min(1.0, min(G1, G2));

			fixed roughness = tex2D(_RoughnessTex, fixed2(NdotH, _Roughness)).r;

			fixed fresnel = pow(1.0 - VdotH, 5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;

			//fixed3 spec = fixed3(fresnel * G * roughness * roughness) * _SpecPower;
			fixed3 spec = (fresnel * _LightColor0.rgb * roughness * roughness) * _SpecPower;

			fixed4 col;
			col.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (spec * _LightColor0.rgb) * (atten * 2.0);
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
