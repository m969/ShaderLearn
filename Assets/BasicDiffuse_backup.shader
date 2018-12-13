Shader "MagicFire/BasicDiffuse_backup"
{
	Properties
	{
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue("My Slider", Range(0,5)) = 2.5
		_RampTex("Ramp Tex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf BasicDiffuse

		#pragma target 3.0

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		sampler2D _RampTex;

        struct Input
        {
            float2 uv_RampTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

		//基础漫反射光照模型
		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			//计算漫反射强度
			float diffuseLight = max(0.0, (dot(s.Normal, lightDir)));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (diffuseLight * atten * 0.5);
			col.a = s.Alpha;
			return col;
		}

		////半兰伯特光照模型
		//inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		//{
		//	float diffuseLight = max(0, dot(s.Normal, lightDir));
		//	float hLambert = diffuseLight * 0.5 + 0.5;

		//	float4 col;
		//	col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 0.5);
		//	col.a = s.Alpha;
		//	return col;
		//}

		////使用渐变纹理控制漫反射着色
		//inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		//{
		//	float diffuseLight = max(0, dot(s.Normal, lightDir));
		//	float hLambert = diffuseLight *0.5 + 0.5;
		//	float3 ramp = tex2D(_RampTex, float2(hLambert, 0)).rgb;
		//
		//	float4 col;
		//	col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
		//	col.a = s.Alpha;
		//	return col;
		//}

		////假BRDF
		//inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		//{
		//	float diffuseLight = dot(s.Normal, lightDir);
		//	float rimLight = dot(s.Normal, viewDir);
		//	float hLambert = diffuseLight * 0.5 + 0.5;
		//	float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;

		//	float4 col;
		//	col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
		//	col.a = s.Alpha;
		//	return col;
		//}

        ENDCG
    }
    FallBack "Diffuse"
}
