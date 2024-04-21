Shader "Enviroment/WallPlane"
    {
        Properties
        {
            [NoScaleOffset]_BaseMap("BaseMap", 2D) = "white" {}
            [NoScaleOffset]_NormalMap("NormalMap", 2D) = "white" {}
            _Scale("Scale", Float) = 1
            [ToggleUI]_UseLighting("UseLighting", Float) = 1
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
            Cull Back
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
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
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define _RECEIVE_SHADOWS_OFF 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
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
                     float3 WorldSpaceNormal;
                     float3 TangentSpaceNormal;
                     float3 WorldSpacePosition;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            #include "Assets/Shaders/LightingBreakdown.hlsl"
            
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
            
                void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
                {
                    Out = dot(A, B);
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Multiply_half_half(half A, half B, out half Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                struct Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float
                {
                float3 WorldSpaceNormal;
                float3 WorldSpacePosition;
                };
                
                void SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float IN, out float3 Lighting_1)
                {
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3;
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float;
                MainLight_half(IN.WorldSpacePosition, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float);
                float _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float;
                Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float);
                float _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float;
                Unity_Saturate_float(_DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float, _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float);
                half _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float;
                Unity_Multiply_half_half(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float, _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float);
                half3 _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3;
                Unity_Multiply_half3_half3(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, (_Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3);
                float3 _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3;
                Unity_Multiply_float3_float3((_Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3);
                float3 _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                Unity_Add_float3(SHADERGRAPH_AMBIENT_SKY, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3, _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3);
                Lighting_1 = _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
                {
                    Out = Predicate ? True : False;
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
                    float Smoothness;
                    float Occlusion;
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean = _UseLighting;
                    Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpaceNormal = IN.WorldSpaceNormal;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpacePosition = IN.WorldSpacePosition;
                    float3 _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3;
                    SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4, _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3);
                    UnityTexture2D _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[0];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_G_2_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[1];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[2];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_A_4_Float = 0;
                    float _Property_8003efbca7764711844ca24bad16117c_Out_0_Float = _Scale;
                    float _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float);
                    float _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2 = float2(_Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2, float2 (0, 0), _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2);
                    float4 _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.tex, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.samplerstate, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_R_4_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.r;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_G_5_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.g;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_B_6_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.b;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_A_7_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.a;
                    float3 _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3;
                    Unity_Multiply_float3_float3(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3);
                    float3 _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    Unity_Branch_float3(_Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean, _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3);
                    UnityTexture2D _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
                    float4 _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.tex, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.samplerstate, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4);
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_R_4_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.r;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_G_5_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.g;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_B_6_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.b;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_A_7_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.a;
                    surface.BaseColor = _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    surface.NormalTS = (_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.xyz);
                    surface.Emission = float3(0, 0, 0);
                    surface.Metallic = 0;
                    surface.Smoothness = 0.5;
                    surface.Occlusion = 1;
                    surface.Alpha = 1;
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
                
                    
                
                    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                    float3 unnormalizedNormalWS = input.normalWS;
                    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
                
                
                    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
                
                
                    output.WorldSpacePosition = input.positionWS;
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
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
            Cull Back
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 4.5
                #pragma exclude_renderers gles3 glcore
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
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define _RECEIVE_SHADOWS_OFF 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
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
                     float3 WorldSpaceNormal;
                     float3 TangentSpaceNormal;
                     float3 WorldSpacePosition;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            #include "Assets/Shaders/LightingBreakdown.hlsl"
            
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
            
                void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
                {
                    Out = dot(A, B);
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Multiply_half_half(half A, half B, out half Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                struct Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float
                {
                float3 WorldSpaceNormal;
                float3 WorldSpacePosition;
                };
                
                void SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float IN, out float3 Lighting_1)
                {
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3;
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float;
                MainLight_half(IN.WorldSpacePosition, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float);
                float _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float;
                Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float);
                float _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float;
                Unity_Saturate_float(_DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float, _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float);
                half _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float;
                Unity_Multiply_half_half(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float, _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float);
                half3 _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3;
                Unity_Multiply_half3_half3(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, (_Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3);
                float3 _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3;
                Unity_Multiply_float3_float3((_Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3);
                float3 _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                Unity_Add_float3(SHADERGRAPH_AMBIENT_SKY, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3, _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3);
                Lighting_1 = _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
                {
                    Out = Predicate ? True : False;
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
                    float Smoothness;
                    float Occlusion;
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean = _UseLighting;
                    Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpaceNormal = IN.WorldSpaceNormal;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpacePosition = IN.WorldSpacePosition;
                    float3 _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3;
                    SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4, _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3);
                    UnityTexture2D _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[0];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_G_2_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[1];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[2];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_A_4_Float = 0;
                    float _Property_8003efbca7764711844ca24bad16117c_Out_0_Float = _Scale;
                    float _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float);
                    float _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2 = float2(_Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2, float2 (0, 0), _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2);
                    float4 _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.tex, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.samplerstate, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_R_4_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.r;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_G_5_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.g;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_B_6_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.b;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_A_7_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.a;
                    float3 _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3;
                    Unity_Multiply_float3_float3(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3);
                    float3 _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    Unity_Branch_float3(_Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean, _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3);
                    UnityTexture2D _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
                    float4 _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.tex, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.samplerstate, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4);
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_R_4_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.r;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_G_5_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.g;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_B_6_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.b;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_A_7_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.a;
                    surface.BaseColor = _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    surface.NormalTS = (_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.xyz);
                    surface.Emission = float3(0, 0, 0);
                    surface.Metallic = 0;
                    surface.Smoothness = 0.5;
                    surface.Occlusion = 1;
                    surface.Alpha = 1;
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
                
                    
                
                    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                    float3 unnormalizedNormalWS = input.normalWS;
                    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
                
                
                    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
                
                
                    output.WorldSpacePosition = input.positionWS;
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
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
                Name "MotionVectors"
                Tags
                {
                    "LightMode" = "MotionVectors"
                }
            
            // Render State
            Cull Back
                ZTest LEqual
                ZWrite On
                ColorMask RG
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 3.5
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_MOTION_VECTORS
            
            
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
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
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
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            // GraphIncludes: <None>
            
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
            // GraphFunctions: <None>
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    surface.Alpha = 1;
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
                    #else
                    #endif
                
                
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
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
            
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
            Cull Back
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
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            // GraphIncludes: <None>
            
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
            
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[0];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_G_2_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[1];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[2];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_A_4_Float = 0;
                    float _Property_8003efbca7764711844ca24bad16117c_Out_0_Float = _Scale;
                    float _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float);
                    float _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2 = float2(_Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2, float2 (0, 0), _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2);
                    float4 _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.tex, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.samplerstate, _Property_93f03b5e6f234176862645a293bc6c4e_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4);
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_R_4_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.r;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_G_5_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.g;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_B_6_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.b;
                    float _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_A_7_Float = _SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.a;
                    surface.NormalTS = (_SampleTexture2D_943b514227894bd5a125ab2c3995ce2a_RGBA_0_Vector4.xyz);
                    surface.Alpha = 1;
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
                    #else
                    #endif
                
                
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
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
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
                     float3 positionWS;
                     float3 normalWS;
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
                     float3 WorldSpaceNormal;
                     float3 WorldSpacePosition;
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
                     float3 positionWS : INTERP3;
                     float3 normalWS : INTERP4;
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
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.texCoord1 = input.texCoord1.xyzw;
                    output.texCoord2 = input.texCoord2.xyzw;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            #include "Assets/Shaders/LightingBreakdown.hlsl"
            
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
            
                void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
                {
                    Out = dot(A, B);
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Multiply_half_half(half A, half B, out half Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                struct Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float
                {
                float3 WorldSpaceNormal;
                float3 WorldSpacePosition;
                };
                
                void SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float IN, out float3 Lighting_1)
                {
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3;
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float;
                MainLight_half(IN.WorldSpacePosition, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float);
                float _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float;
                Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float);
                float _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float;
                Unity_Saturate_float(_DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float, _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float);
                half _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float;
                Unity_Multiply_half_half(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float, _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float);
                half3 _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3;
                Unity_Multiply_half3_half3(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, (_Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3);
                float3 _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3;
                Unity_Multiply_float3_float3((_Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3);
                float3 _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                Unity_Add_float3(SHADERGRAPH_AMBIENT_SKY, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3, _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3);
                Lighting_1 = _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
                {
                    Out = Predicate ? True : False;
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean = _UseLighting;
                    Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpaceNormal = IN.WorldSpaceNormal;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpacePosition = IN.WorldSpacePosition;
                    float3 _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3;
                    SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4, _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3);
                    UnityTexture2D _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[0];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_G_2_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[1];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[2];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_A_4_Float = 0;
                    float _Property_8003efbca7764711844ca24bad16117c_Out_0_Float = _Scale;
                    float _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float);
                    float _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2 = float2(_Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2, float2 (0, 0), _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2);
                    float4 _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.tex, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.samplerstate, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_R_4_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.r;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_G_5_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.g;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_B_6_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.b;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_A_7_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.a;
                    float3 _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3;
                    Unity_Multiply_float3_float3(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3);
                    float3 _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    Unity_Branch_float3(_Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean, _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3);
                    surface.BaseColor = _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    surface.Emission = float3(0, 0, 0);
                    surface.Alpha = 1;
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
                
                    
                
                    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                    float3 unnormalizedNormalWS = input.normalWS;
                    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
                
                
                    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                
                
                    output.WorldSpacePosition = input.positionWS;
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
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
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            // GraphIncludes: <None>
            
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
            // GraphFunctions: <None>
            
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    surface.Alpha = 1;
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
                    #else
                    #endif
                
                
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
            Cull Back
            
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
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            // GraphIncludes: <None>
            
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
            // GraphFunctions: <None>
            
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    surface.Alpha = 1;
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
                    #else
                    #endif
                
                
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
            Cull Back
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
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
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
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
                     float3 positionWS;
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
                     float3 WorldSpaceNormal;
                     float3 WorldSpacePosition;
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
                     float3 positionWS : INTERP1;
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
                    output.texCoord0.xyzw = input.texCoord0;
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
                    output.texCoord0 = input.texCoord0.xyzw;
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
                float4 _BaseMap_TexelSize;
                float4 _NormalMap_TexelSize;
                float _Scale;
                float _UseLighting;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_BaseMap);
                SAMPLER(sampler_BaseMap);
                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);
            
            // Graph Includes
            #include "Assets/Shaders/LightingBreakdown.hlsl"
            
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
            
                void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
                {
                    Out = dot(A, B);
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Multiply_half_half(half A, half B, out half Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                struct Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float
                {
                float3 WorldSpaceNormal;
                float3 WorldSpacePosition;
                };
                
                void SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float IN, out float3 Lighting_1)
                {
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3;
                half3 _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float;
                half _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float;
                MainLight_half(IN.WorldSpacePosition, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float);
                float _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float;
                Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Direction_1_Vector3, _DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float);
                float _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float;
                Unity_Saturate_float(_DotProduct_d09cbd5d5aac49d586df4da8c3a657ca_Out_2_Float, _Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float);
                half _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float;
                Unity_Multiply_half_half(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_DistanceAtten_3_Float, _MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_ShadowAtten_4_Float, _Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float);
                half3 _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3;
                Unity_Multiply_half3_half3(_MainLightCustomFunction_bf337aaffe964b74829caa67239cd1eb_Color_2_Vector3, (_Multiply_1c4d47a89fbb49e0a854aa216ee6b691_Out_2_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3);
                float3 _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3;
                Unity_Multiply_float3_float3((_Saturate_82b3a3038bef44dcb5b293d653776a20_Out_1_Float.xxx), _Multiply_ecb8128c4bfd4e25a82765350c71a764_Out_2_Vector3, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3);
                float3 _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                Unity_Add_float3(SHADERGRAPH_AMBIENT_SKY, _Multiply_be8b0ec1ebb24d1da3ebc9123c665841_Out_2_Vector3, _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3);
                Lighting_1 = _Add_0575b3b615c646bebd5df45654b43d79_Out_2_Vector3;
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
                {
                    Out = Predicate ? True : False;
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
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean = _UseLighting;
                    Bindings_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpaceNormal = IN.WorldSpaceNormal;
                    _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4.WorldSpacePosition = IN.WorldSpacePosition;
                    float3 _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3;
                    SG_var8bitGetLight_93ab45f0c9d8c45a8b110ec8efe22d7d_float(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4, _var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3);
                    UnityTexture2D _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[0];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_G_2_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[1];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float = float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)))[2];
                    float _Split_8f3ad494e0004074b9d5a8202ee9e79c_A_4_Float = 0;
                    float _Property_8003efbca7764711844ca24bad16117c_Out_0_Float = _Scale;
                    float _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_R_1_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float);
                    float _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float;
                    Unity_Multiply_float_float(_Split_8f3ad494e0004074b9d5a8202ee9e79c_B_3_Float, _Property_8003efbca7764711844ca24bad16117c_Out_0_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2 = float2(_Multiply_7e1c85f200574f3899b3b24a0d578aaa_Out_2_Float, _Multiply_88e3151b3eeb48ed9e4f4aba5dbca237_Out_2_Float);
                    float2 _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_dfee767d8ad14cdea6d5feacb769385f_Out_0_Vector2, float2 (0, 0), _TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2);
                    float4 _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.tex, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.samplerstate, _Property_9257dd9d985242c584e82e1b9c414df2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_adf99e9ac4144fa8b7f902d8eed6fd2f_Out_3_Vector2) );
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_R_4_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.r;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_G_5_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.g;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_B_6_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.b;
                    float _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_A_7_Float = _SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.a;
                    float3 _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3;
                    Unity_Multiply_float3_float3(_var8bitGetLight_21e6350e49984c7e91f61c048d6dd1c4_Lighting_1_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3);
                    float3 _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    Unity_Branch_float3(_Property_a0bbd5a4841c4d8fb40b661d55284a04_Out_0_Boolean, _Multiply_a341bbd2964348f9a4279cc0e1023de3_Out_2_Vector3, (_SampleTexture2D_ee9fd5aa0eeb4b2994f9dfced2ecc1af_RGBA_0_Vector4.xyz), _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3);
                    surface.BaseColor = _Branch_9d8cf166532e42a3b26a613f0a973878_Out_3_Vector3;
                    surface.Alpha = 1;
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
                
                    
                
                    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                    float3 unnormalizedNormalWS = input.normalWS;
                    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
                
                
                    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                
                
                    output.WorldSpacePosition = input.positionWS;
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
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