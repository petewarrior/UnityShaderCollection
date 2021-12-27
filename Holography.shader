// source https://forum.unity.com/threads/change-surface-color-based-on-the-angle-between-surface-normal-and-world-up.355215/

Shader "Custom/Holography"
{
        Properties{
        _MainTex("Texture", 2D) = "white" {}
        _ColorA ("Color 1", Color) = (1,1,1,1)
        _ColorB ("Color 2", Color) = (0,0,0,0)
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
        SubShader{
        Tags{ "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
        // AlphaToMask On
        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff// vertex:vert
        struct Input {
            float2 uv_MainTex;
            float3 customColor;
            float3 viewDir;
        };

        float3 _ColorA;
        float3 _ColorB;

        // void vert(inout appdata_full v, out Input o) {
        //     UNITY_INITIALIZE_OUTPUT(Input, o);
        // }
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            float x = dot(IN.viewDir, o.Normal);
            x = abs(x);
            float3 color = lerp(_ColorA, _ColorB, x);
            fixed4 t = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = t.rgb;
            o.Alpha = t.a;
            o.Albedo *= color;
        }
        ENDCG
    }
    
    FallBack "Diffuse"
}
