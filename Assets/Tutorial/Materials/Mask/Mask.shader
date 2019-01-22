Shader "Tutorial/Mask" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {} //add
	}
		SubShader{
			Tags { "RenderType" = "Opaque" "Queue" = "Transparent"} //modified
			Blend SrcAlpha OneMinusSrcAlpha //add

			CGPROGRAM
			#pragma surface surf Standard keepalpha //modified
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _MaskTex; //add

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutputStandard o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				fixed4 m = tex2D(_MaskTex, IN.uv_MainTex); //add
				c = c * m; //add
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
			ENDCG
	}
		FallBack "Diffuse"
}