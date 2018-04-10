﻿Shader "Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineScale ("アウトライン幅", Float) = 0.003
        _OutlineColor ("アウトラインの色(テクスチャ色に乗算)", Color) = (0, 0, 0, 0)
        _EmvironmentLightPower ("環境光の強さ", Float) = 0.05
        _EnvironmentLightColor ("環境光の色", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        UsePass "Unlit/UNLIT"

        Pass
        {
            Name "OUTLINE"
            Cull Front
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _OutlineScale;
            float3 _OutlineColor;
            float _EmvironmentLightPower;
            float3 _EnvironmentLightColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _OutlineScale);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= _OutlineColor.rgb + _EnvironmentLightColor * _EmvironmentLightPower;
                return col;
            }
            ENDCG
        }
    }
}
