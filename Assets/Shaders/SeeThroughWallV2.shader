Shader "Enviroment/SeeThroughWallV2"
    {
        Properties
        {
            _player_position("player_position", Vector) = (0.5, 0.5, 0, 0)
            _size("size", Float) = 0.5
            _smoothness("smoothness", Range(0, 1)) = 0.5
            _opacity("opacity", Range(0, 1)) = 1
            [NoScaleOffset]_main_texture("main_texture", 2D) = "white" {}
            [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
            [HideInInspector]_CastShadows("_CastShadows", Float) = 1
            [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
            [HideInInspector]_Surface("_Surface", Float) = 1
            [HideInInspector]_Blend("_Blend", Float) = 0
            [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
            [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 1
            [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
            [HideInInspector]_DstBlend("_DstBlend", Float) = 0
            [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 0
            [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
            [HideInInspector]_ZTest("_ZTest", Float) = 4
            [HideInInspector]_Cull("_Cull", Float) = 0
            [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
            [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
            [HideInInspector]_QueueControl("_QueueControl", Float) = -1
            [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        }
        SubShader
        {
            Tags
            {
                "RenderPipeline"="UniversalPipeline"
                "RenderType"="Transparent"
                "UniversalMaterialType" = "Lit"
                "Queue"="Transparent"
                "DisableBatching"="False"
                "ShaderGraphShader"="true"
                "ShaderGraphTargetId"="UniversalLitSubTarget"
            }
            Pass
            {
                Name "Universal Forward"
                Tags
                {
                    "LightMode" = "UniversalForward"
                }
            
            // Render State
            Cull [_Cull]
                Blend [_SrcBlend] [_DstBlend]
                ZTest [_ZTest]
                ZWrite [_ZWrite]
                AlphaToMask [_AlphaToMask]
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma instancing_options renderinglayer
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
                #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
                #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
                #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
                #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                #pragma multi_compile_fragment _ _LIGHT_LAYERS
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                #pragma multi_compile_fragment _ _LIGHT_COOKIES
                #pragma multi_compile _ _FORWARD_PLUS
                #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
                #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
                #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SHADOW_COORD
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
                #define _FOG_FRAGMENT 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 uv1 : TEXCOORD1;
                     float4 uv2 : TEXCOORD2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float3 normalWS;
                     float4 tangentWS;
                     float4 texCoord0;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh;
                    #endif
                     float4 fogFactorAndVertexLight;
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord;
                    #endif
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 TangentSpaceNormal;
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV : INTERP0;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV : INTERP1;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh : INTERP2;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord : INTERP3;
                    #endif
                     float4 tangentWS : INTERP4;
                     float4 texCoord0 : INTERP5;
                     float4 fogFactorAndVertexLight : INTERP6;
                     float3 positionWS : INTERP7;
                     float3 normalWS : INTERP8;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS.xyzw = input.tangentWS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
                    output.positionWS.xyz = input.positionWS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS = input.tangentWS.xyzw;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
                    output.positionWS = input.positionWS.xyz;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                    float3 NormalTS;
                    float3 Emission;
                    float Metallic;
                    float3 Specular;
                    float Smoothness;
                    float Occlusion;
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 1, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.BaseColor = (_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.xyz);
                    surface.NormalTS = IN.TangentSpaceNormal;
                    surface.Emission = float3(0, 0, 0);
                    surface.Metallic = 0;
                    surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
                    surface.Smoothness = 0.5;
                    surface.Occlusion = 1;
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "GBuffer"
                Tags
                {
                    "LightMode" = "UniversalGBuffer"
                }
            
            // Render State
            Cull [_Cull]
                Blend [_SrcBlend] [_DstBlend]
                ZTest [_ZTest]
                ZWrite [_ZWrite]
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma instancing_options renderinglayer
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
                #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
                #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
                #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
                #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
                #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SHADOW_COORD
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
                #define _FOG_FRAGMENT 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 uv1 : TEXCOORD1;
                     float4 uv2 : TEXCOORD2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float3 normalWS;
                     float4 tangentWS;
                     float4 texCoord0;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh;
                    #endif
                     float4 fogFactorAndVertexLight;
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord;
                    #endif
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 TangentSpaceNormal;
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV : INTERP0;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV : INTERP1;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh : INTERP2;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord : INTERP3;
                    #endif
                     float4 tangentWS : INTERP4;
                     float4 texCoord0 : INTERP5;
                     float4 fogFactorAndVertexLight : INTERP6;
                     float3 positionWS : INTERP7;
                     float3 normalWS : INTERP8;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS.xyzw = input.tangentWS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
                    output.positionWS.xyz = input.positionWS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS = input.tangentWS.xyzw;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
                    output.positionWS = input.positionWS.xyz;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                    float3 NormalTS;
                    float3 Emission;
                    float Metallic;
                    float3 Specular;
                    float Smoothness;
                    float Occlusion;
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.BaseColor = (_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.xyz);
                    surface.NormalTS = IN.TangentSpaceNormal;
                    surface.Emission = float3(0, 0, 0);
                    surface.Metallic = 0;
                    surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
                    surface.Smoothness = 0.5;
                    surface.Occlusion = 1;
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "ShadowCaster"
                Tags
                {
                    "LightMode" = "ShadowCaster"
                }
            
            // Render State
            Cull [_Cull]
                ZTest LEqual
                ZWrite On
                ColorMask 0
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                     float3 normalWS : INTERP1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }
            
            // Render State
            Cull [_Cull]
                ZTest LEqual
                ZWrite On
                ColorMask R
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "DepthNormals"
                Tags
                {
                    "LightMode" = "DepthNormals"
                }
            
            // Render State
            Cull [_Cull]
                ZTest LEqual
                ZWrite On
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALS
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS;
                     float4 tangentWS;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 TangentSpaceNormal;
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 tangentWS : INTERP0;
                     float4 texCoord0 : INTERP1;
                     float3 normalWS : INTERP2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.tangentWS.xyzw = input.tangentWS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.tangentWS = input.tangentWS.xyzw;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 NormalTS;
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.NormalTS = IN.TangentSpaceNormal;
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "Meta"
                Tags
                {
                    "LightMode" = "Meta"
                }
            
            // Render State
            Cull Off
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature _ EDITOR_VISUALIZATION
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
                #define _FOG_FRAGMENT 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 uv1 : TEXCOORD1;
                     float4 uv2 : TEXCOORD2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                     float4 texCoord1;
                     float4 texCoord2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                     float4 texCoord1 : INTERP1;
                     float4 texCoord2 : INTERP2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.texCoord1.xyzw = input.texCoord1;
                    output.texCoord2.xyzw = input.texCoord2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.texCoord1 = input.texCoord1.xyzw;
                    output.texCoord2 = input.texCoord2.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                    float3 Emission;
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.BaseColor = (_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.xyz);
                    surface.Emission = float3(0, 0, 0);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "SceneSelectionPass"
                Tags
                {
                    "LightMode" = "SceneSelectionPass"
                }
            
            // Render State
            Cull Off
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENESELECTIONPASS 1
                #define ALPHA_CLIP_THRESHOLD 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "ScenePickingPass"
                Tags
                {
                    "LightMode" = "Picking"
                }
            
            // Render State
            Cull [_Cull]
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENEPICKINGPASS 1
                #define ALPHA_CLIP_THRESHOLD 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                // Name: <None>
                Tags
                {
                    "LightMode" = "Universal2D"
                }
            
            // Render State
            Cull [_Cull]
                Blend [_SrcBlend] [_DstBlend]
                ZTest [_ZTest]
                ZWrite [_ZWrite]
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float2 NDCPosition;
                     float2 PixelPosition;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float2 _player_position;
                float _size;
                float _smoothness;
                float _opacity;
                float4 _main_texture_TexelSize;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_main_texture);
                SAMPLER(sampler_main_texture);
            
            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A - B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Length_float2(float2 In, out float Out)
                {
                    Out = length(In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                {
                    Out = smoothstep(Edge1, Edge2, In);
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                    float x; Hash_Tchou_2_1_float(p, x);
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                    float2 p = UV * Scale.xy;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                    float AlphaClipThreshold;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_main_texture);
                    float4 _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.tex, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.samplerstate, _Property_8f8f7c907ebd4b6ab2822efc7fc43be5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_R_4_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.r;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_G_5_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.g;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_B_6_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.b;
                    float _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float = _SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.a;
                    float _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float = _smoothness;
                    float4 _ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
                    float2 _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2;
                    Unity_TilingAndOffset_float((_ScreenPosition_f701c59d42db441f8de9f7b92d445891_Out_0_Vector4.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2);
                    float2 _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2;
                    Unity_Multiply_float2_float2(_TilingAndOffset_3bfc1c75045343489df5076e7142a6b7_Out_3_Vector2, float2(2, 2), _Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2);
                    float2 _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2;
                    Unity_Subtract_float2(_Multiply_7934747de8ca4a8f894532b0e0998cac_Out_2_Vector2, float2(1, 1), _Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2);
                    float _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float;
                    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float);
                    float _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float = _size;
                    float _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float;
                    Unity_Multiply_float_float(_Divide_c4ee1e81296849b39d5d9d3d4b95fbce_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float, _Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float);
                    float2 _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2 = float2(_Multiply_81455da0e0214f829e53003ebc28eb8b_Out_2_Float, _Property_839bcce05ed14f5c90f8aa3eb5aa52c4_Out_0_Float);
                    float2 _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2;
                    Unity_Divide_float2(_Subtract_42eaeba216764bda9342a8b7e62639f9_Out_2_Vector2, _Vector2_45ab039a2e9f48b58c08767172f5d95f_Out_0_Vector2, _Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2);
                    float _Length_392a688396ba4683839e5f2d69602298_Out_1_Float;
                    Unity_Length_float2(_Divide_3c107a52ed81492f8d5befc776d150d2_Out_2_Vector2, _Length_392a688396ba4683839e5f2d69602298_Out_1_Float);
                    float _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float;
                    Unity_OneMinus_float(_Length_392a688396ba4683839e5f2d69602298_Out_1_Float, _OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float);
                    float _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float;
                    Unity_Saturate_float(_OneMinus_413879ae38fb452c8eaec40b3b7028af_Out_1_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float);
                    float _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float;
                    Unity_Smoothstep_float(0, _Property_9995dae2b8484f4ca91b2e4aa74299d7_Out_0_Float, _Saturate_85a4f0f5c7e84596b59d0d08272e8d21_Out_1_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float);
                    float _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float;
                    Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 25, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float);
                    float _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float;
                    Unity_Multiply_float_float(_Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _GradientNoise_f65ed86295354f2aada718c634437533_Out_2_Float, _Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float);
                    float _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float;
                    Unity_Add_float(_Multiply_a688c82408574c7581c9d84b68929086_Out_2_Float, _Smoothstep_22e5a9a848054fc1ba9bafb054a668fa_Out_3_Float, _Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float);
                    float _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float = _opacity;
                    float _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float;
                    Unity_Multiply_float_float(_Add_6c28ed7e002d4e0bac1534e56646b6d6_Out_2_Float, _Property_72a0943bad8f46bdb2de4dc5bdcb2830_Out_0_Float, _Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float);
                    float _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float;
                    Unity_Clamp_float(_Multiply_862917d1c8fc4cacac15f11304d537b0_Out_2_Float, 0, 1, _Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float);
                    float _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float;
                    Unity_OneMinus_float(_Clamp_111c41867f8a4cbc80124baf06c6d480_Out_3_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float);
                    float _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float;
                    Unity_Multiply_float_float(_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_A_7_Float, _OneMinus_1097cfd7448d46c7b0a24433c2234391_Out_1_Float, _Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float);
                    float _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    Unity_Clamp_float(_Multiply_7a3a498a38b8464bbaf5f4b432cb2db9_Out_2_Float, 0, 255, _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float);
                    surface.BaseColor = (_SampleTexture2D_615e5b88994f43e6a7f9df318c61ec61_RGBA_0_Vector4.xyz);
                    surface.Alpha = _Clamp_5e654fadca9d4e688f55af9abe8e6a04_Out_3_Float;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #else
                    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
                    #endif
                
                    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
                    output.NDCPosition.y = 1.0f - output.NDCPosition.y;
                
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
        }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
        FallBack "Hidden/Shader Graph/FallbackError"
    }