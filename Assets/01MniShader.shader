Shader "CS0101/01MiniShader"
{
    Properties
    {
        _Float("Float", Float) = 0.0
        _Range("Range", Range(0.0, 1.0)) = 0.0
        _Vector("Vecotr", Vector) = (1, 1, 1, 1)
        _Color("Color", Color) = (0.5, 0.5, 0.5, 0.5)
        _MainTex("MainTex", 2D) = "white"{}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;// uv 插值
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;// 对应材质中的 Tiling (材质缩放) 和 Offset（材质便宜）

            v2f vert(appdata v)
            {
                v2f o;

                float4 pos_wolrd = mul(unity_ObjectToWorld, v.vertex);// 模型空间转世界空间
                float4 pos_view = mul(UNITY_MATRIX_V, pos_wolrd);// 世界空间转摄像机空间
                float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);// 摄像机空间转裁剪空间

                o.pos = pos_clip;
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // return float4(0.5, 1.0, 0.5, 1.0);
                float4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            
            ENDCG
        }
    }
}
