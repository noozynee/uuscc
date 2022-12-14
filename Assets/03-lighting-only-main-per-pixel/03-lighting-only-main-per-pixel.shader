
Shader "uuscc/03-lighting-only-main-per-pixel"
{
    Properties
    {
        // [MainTexture] _BaseMap("Base Map", 2D) = "white"
    }
    
    SubShader
    {        
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex VSMain
            #pragma fragment PSMain

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct VSInput
            {                
                float4 posOS    : POSITION;
                float3 normalOS : NORMAL;
            };

            struct PSInput
            {                
                float4 posCS   : SV_POSITION;
                float3 normalWS : TEXCOORD0;
            };

            
            CBUFFER_START( UnityPerMaterial )                
            CBUFFER_END
            
            PSInput VSMain ( VSInput input )
            {
                PSInput output = (PSInput)0;

                output.posCS = TransformObjectToHClip( input.posOS.xyz );
                output.normalWS = TransformObjectToWorldNormal( input.normalOS );

                return output;
            }
            
            half4 PSMain( PSInput input ) : SV_Target
            {
                half3 dir = _MainLightPosition.xyz;
                half4 color = half4(1, 1, 1, 1);
                color.xyz = LightingLambert( color.xyz, dir, input.normalWS );

                return color;
            }

            ENDHLSL
        }
    }
}


