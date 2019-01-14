Shader "Custom/Sam" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_EmissionColor ("Emission Color", Color) = (1,1,1,1)
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Emission("Emission", Range(0,1)) = 0.0
		_Transparent("Transparent", Range(0,1)) = 0.0
		_Parallax("Height", Range(0.005, 0.08)) = 0.02
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Normalmap", 2D) = "bump" {}
		_ParallaxMap("Heightmap", 2D) = "black" {}
		_MaskTex("Mask Texture", 2D) = "white" {}
		_PowerMap("Power Map", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "AlphaTest" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha //vertex:vert

		sampler2D _MainTex;
		sampler2D _MaskTex;
		sampler2D _BumpMap;
		sampler2D _ParallaxMap;
		sampler2D _PowerMap;
		float _Parallax;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
			float2 uv_texcoord;
		};

		half _Glossiness;
		half _Metallic;
		half _Emission;
		half _Transparent;
		fixed4 _Color;
		fixed4 _EmissionColor;

		//void vert(inout appdata_full v, out Input o)
		//{
		//	UNITY_INITIALIZE_OUTPUT(Input, o);
		//	fixed4 maskMap = tex2D(_MaskTex, o.uv_MainTex);

		//	float2 uv_HeightMap = v.texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
		//	float Mask = tex2Dlod(_MaskTex, float4(uv_HeightMap, 0, 0.0)).r;
		//	float3 HeightMap_cast = (tex2Dlod(_HeightMap, float4(uv_HeightMap, 0, 0.0)).r).xxx * Mask;
		//	v.vertex.y += HeightMap_cast - 0.5;
		//}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 maskMap = tex2D(_MaskTex, IN.uv_MainTex);
			fixed4 parallaxMap = tex2D(_ParallaxMap, IN.uv_BumpMap);
			fixed4 powerMap0 = tex2D(_PowerMap, IN.uv_MainTex + fixed2(_Time.x, _Time.x));
			fixed4 powerMap1 = tex2D(_PowerMap, IN.uv_MainTex + fixed2(-_Time.x, _Time.x));

			half h = parallaxMap.w;
			float2 offset = ParallaxOffset(h, _Parallax * (1.0 - maskMap.r), IN.viewDir);
			IN.uv_MainTex += offset;
			IN.uv_BumpMap += offset;

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * (1.0 - maskMap.r) + (_EmissionColor * maskMap.r);
			o.Metallic = _Metallic * maskMap.r;
			o.Smoothness = _Glossiness * maskMap.r;
			o.Emission = _Emission * maskMap * _EmissionColor;
			o.Alpha = (1.0 - maskMap.r * ((powerMap1.r * powerMap0.r * 1.8) - 0.8));

			if (maskMap.r < 0.5)
			{
				fixed4 bumpMap = tex2D(_BumpMap, IN.uv_BumpMap) * fixed4(1.0, 1.0, 1.0, 1.0);
				o.Normal = UnpackNormal(bumpMap);
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
