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
		//	fixed4 maskColor = tex2D(_MaskTex, o.uv_MainTex);

		//	float2 uv_HeightMap = v.texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
		//	float Mask = tex2Dlod(_MaskTex, float4(uv_HeightMap, 0, 0.0)).r;
		//	float3 HeightMap_cast = (tex2Dlod(_HeightMap, float4(uv_HeightMap, 0, 0.0)).r).xxx * Mask;
		//	v.vertex.y += HeightMap_cast - 0.5;
		//}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 maskColor = tex2D(_MaskTex, IN.uv_MainTex);

			half h = tex2D(_ParallaxMap, IN.uv_BumpMap).w;
			float2 offset = ParallaxOffset(h, _Parallax * (1.0 - maskColor.r), IN.viewDir);
			IN.uv_MainTex += offset;
			IN.uv_BumpMap += offset;

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * (1.0 - maskColor.r) + (_EmissionColor * maskColor.r);
			o.Metallic = _Metallic * maskColor.r;
			o.Smoothness = _Glossiness * maskColor.r;
			o.Emission = _Emission * maskColor * _EmissionColor;
			o.Alpha = (1.0 - maskColor.r * _Transparent);

			if (maskColor.r < 0.5)
			{
				fixed4 normalMap = tex2D(_BumpMap, IN.uv_BumpMap) * fixed4(1.0, 1.0, 1.0, 1.0);
				o.Normal = UnpackNormal(normalMap);
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
