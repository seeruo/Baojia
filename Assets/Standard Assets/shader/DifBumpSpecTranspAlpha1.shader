Shader "Dif_Bump_Spec_Transp_Alpha1" {
Properties {
	_Color ("Diffuse Color", Color) = (1,1,1,1)
	_MainTex ("Diffuse Map (RGB)", 2D) = "white" {}	
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_SpecMap ("Specular Map (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_TranspMap ("Transp Map (R)", 2D) = "white" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 400
	
	
CGPROGRAM
#pragma surface surf BlinnPhong alpha

sampler2D _MainTex;
sampler2D _BumpMap;
fixed4 _Color;
half _Shininess;
sampler2D _SpecMap;
sampler2D _TranspMap;

struct Input {
	float2 uv_MainTex;
	float2 uv_SpecMap;
	float2 uv_BumpMap;
	float2 uv_TranspMap;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 spec = tex2D(_SpecMap, IN.uv_SpecMap);
	fixed4 transp = tex2D(_TranspMap, IN.uv_TranspMap);
	_SpecColor = _SpecColor*spec;
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = spec.r;
	o.Alpha = transp.r * _Color.a;
	o.Specular = _Shininess;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG
}

FallBack "Transparent/VertexLit"
}