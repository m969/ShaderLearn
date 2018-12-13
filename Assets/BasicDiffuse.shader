Shader "MagicFire/BasicDiffuse"
{
	Properties
	{
		_MainTint("MainTint", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf BasicDiffuse

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = c;
			c = _MainTint;
			fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * albedo.rgb;
            o.Alpha = c.a;
        }

		//基础漫反射光照模型
		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			//计算漫反射强度
			float diffuseLight = max(0.0, (dot(s.Normal, lightDir)));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (diffuseLight * atten * 2);
			col.a = s.Alpha;
			return col;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
