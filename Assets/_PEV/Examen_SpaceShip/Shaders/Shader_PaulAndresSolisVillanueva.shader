// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_PaulAndresSolisVillanueva"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_Main_Tex_Color("Main_Tex_Color", Color) = (1,1,1,0)
		[Normal]_Normal_Map("Normal_Map", 2D) = "bump" {}
		_Normal_Intensity("Normal_Intensity", Range( 2 , 6)) = 5.67
		_SpecularTex("SpecularTex", 2D) = "white" {}
		_SpecularColor("SpecularColor", Color) = (0.8867924,0.1631364,0.1631364,0)
		_SpecularPower("SpecularPower", Range( 0 , 1)) = 0
		_Specular_Intensity("Specular_Intensity", Range( 0 , 3)) = 3
		_Cloaking("Cloaking", Range( 0 , 1)) = 0.6035187
		_Refraction_Intensity("Refraction_Intensity", Range( -0.5 , 0.5)) = 0.004513069
		_TransicionTex("TransicionTex", 2D) = "white" {}
		_Transicion_Color("Transicion_Color", Color) = (0,0.3981171,1,0)
		_Transicion_Width("Transicion_Width", Range( 0 , 1)) = 1
		_TransEmmisive_Intensity("TransEmmisive_Intensity", Range( 0 , 5)) = 1.294118
		_Invisibility_tint("Invisibility_tint", Color) = (0,0.3698164,0.972549,1)
		_Emmesive_Tex("Emmesive_Tex", 2D) = "white" {}
		_Emmesive_Intensity("Emmesive_Intensity", Range( 0 , 5)) = 5
		_Emmesive_Color("Emmesive_Color", Color) = (1,1,1,0)
		[Toggle]_RimLight_Toggle("RimLight_Toggle", Float) = 1
		_RimLight_Color("RimLight_Color", Color) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Normal_Map;
		uniform float4 _Normal_Map_ST;
		uniform float _Normal_Intensity;
		uniform float4 _Main_Tex_Color;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform sampler2D _SpecularTex;
		uniform float4 _SpecularTex_ST;
		uniform float _SpecularPower;
		uniform float _Specular_Intensity;
		uniform float4 _SpecularColor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Refraction_Intensity;
		uniform float4 _Invisibility_tint;
		uniform float4 _RimLight_Color;
		uniform float _RimLight_Toggle;
		uniform sampler2D _Emmesive_Tex;
		uniform float4 _Emmesive_Tex_ST;
		uniform float4 _Emmesive_Color;
		uniform float _Emmesive_Intensity;
		uniform float _Cloaking;
		uniform float _Transicion_Width;
		uniform float4 _Transicion_Color;
		uniform sampler2D _TransicionTex;
		uniform float _TransEmmisive_Intensity;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
		{
			float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
			UV = frac( sin(mul(UV, m) ) * 46839.32 );
			return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
		}
		
		//x - Out y - Cells
		float3 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity, inout float2 mr )
		{
			float2 g = floor( UV * CellDensity );
			float2 f = frac( UV * CellDensity );
			float t = 8.0;
			float3 res = float3( 8.0, 0.0, 0.0 );
		
			for( int y = -1; y <= 1; y++ )
			{
				for( int x = -1; x <= 1; x++ )
				{
					float2 lattice = float2( x, y );
					float2 offset = UnityVoronoiRandomVector( lattice + g, AngleOffset );
					float d = distance( lattice + offset, f );
		
					if( d < res.x )
					{
						mr = f - lattice - offset;
						res = float3( d, offset.x, offset.y );
					}
				}
			}
			return res;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_Normal_Map = i.uv_texcoord * _Normal_Map_ST.xy + _Normal_Map_ST.zw;
			float3 Normal200 = (WorldNormalVector( i , UnpackScaleNormal( tex2D( _Normal_Map, uv_Normal_Map ), _Normal_Intensity ) ));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult64 = dot( Normal200 , ase_worldlightDir );
			float DirectLight67 = ( saturate( dotResult64 ) * ase_lightAtten );
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float4 Diffuse47 = ( _Main_Tex_Color * tex2D( _Main_Tex, uv_Main_Tex ) );
			float2 uv_SpecularTex = i.uv_texcoord * _SpecularTex_ST.xy + _SpecularTex_ST.zw;
			float4 normalizeResult52 = normalize( tex2D( _SpecularTex, uv_SpecularTex ) );
			float4 temp_cast_0 = (exp2( _SpecularPower )).xxxx;
			float4 Specular70 = ( DirectLight67 * pow( saturate( normalizeResult52 ) , temp_cast_0 ) * _Specular_Intensity * _SpecularColor );
			float4 Visible75 = ( ( DirectLight67 * Diffuse47 ) + Specular70 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float3 objToWorldDir130 = mul( unity_ObjectToWorld, float4( Normal200, 0 ) ).xyz;
			float4 screenColor138 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( (ase_grabScreenPosNorm).xy + ( _Refraction_Intensity * (objToWorldDir130).xy ) ));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV161 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode161 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV161, 5.0 ) );
			float dotResult158 = dot( ase_worldNormal , ase_worldlightDir );
			float4 RimLight164 = ( fresnelNode161 * saturate( dotResult158 ) * _RimLight_Color * (( _RimLight_Toggle )?( 1.0 ):( 0.0 )) );
			float2 uv_Emmesive_Tex = i.uv_texcoord * _Emmesive_Tex_ST.xy + _Emmesive_Tex_ST.zw;
			float4 Emmesive82 = ( tex2D( _Emmesive_Tex, uv_Emmesive_Tex ) * _Emmesive_Color * _Emmesive_Intensity );
			float4 Invisibility144 = ( ( screenColor138 * _Invisibility_tint ) + RimLight164 + Emmesive82 );
			float2 uv3 = 0;
			float3 unityVoronoy3 = UnityVoronoi(i.uv_texcoord,3.06,4.48,uv3);
			float simplePerlin2D4 = snoise( i.uv_texcoord*2.38 );
			simplePerlin2D4 = simplePerlin2D4*0.5 + 0.5;
			float Noise_Intensity104 = ( i.uv_texcoord.x + ( (0.0 + (unityVoronoy3.x - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * 0.00746386 ) + ( simplePerlin2D4 * 0.1635199 ) );
			float temp_output_103_0 = ( _Transicion_Width * 0.5 );
			float temp_output_101_0 = ( ( Noise_Intensity104 * 0.5 ) + temp_output_103_0 );
			float temp_output_110_0 = (( 0.0 - temp_output_101_0 ) + (_Cloaking - 0.0) * (( 1.0 + temp_output_101_0 ) - ( 0.0 - temp_output_101_0 )) / (1.0 - 0.0));
			float temp_output_1_0_g10 = ( temp_output_110_0 - temp_output_103_0 );
			float help176 = saturate( ( ( Noise_Intensity104 - temp_output_1_0_g10 ) / ( ( temp_output_110_0 + temp_output_103_0 ) - temp_output_1_0_g10 ) ) );
			float4 lerpResult116 = lerp( Visible75 , Invisibility144 , help176);
			float4 temp_output_14_0_g13 = _Transicion_Color;
			float temp_output_20_0 = ( 1.0 - 0.0 );
			float temp_output_1_0_g12 = ( temp_output_20_0 - 0.3723013 );
			float temp_output_1_0_g15 = 0.0;
			float temp_output_4_0_g13 = 0.56;
			float4 lerpResult16_g13 = lerp( float4( 0,0,0,0 ) , temp_output_14_0_g13 , saturate( ( ( saturate( pow( saturate( ( ( ( 1.0 - abs( (-1.0 + (help176 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) - temp_output_1_0_g12 ) / ( temp_output_20_0 - temp_output_1_0_g12 ) ) ) , exp2( 1.050046 ) ) ) - temp_output_1_0_g15 ) / ( temp_output_4_0_g13 - temp_output_1_0_g15 ) ) ));
			float temp_output_1_0_g14 = temp_output_4_0_g13;
			float4 lerpResult17_g13 = lerp( temp_output_14_0_g13 , float4( 1,1,1,0 ) , saturate( ( ( saturate( pow( saturate( ( ( ( 1.0 - abs( (-1.0 + (help176 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) - temp_output_1_0_g12 ) / ( temp_output_20_0 - temp_output_1_0_g12 ) ) ) , exp2( 1.050046 ) ) ) - temp_output_1_0_g14 ) / ( 1.0 - temp_output_1_0_g14 ) ) ));
			float4 lerpResult18_g13 = lerp( lerpResult16_g13 , lerpResult17_g13 , step( temp_output_4_0_g13 , saturate( pow( saturate( ( ( ( 1.0 - abs( (-1.0 + (help176 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) - temp_output_1_0_g12 ) / ( temp_output_20_0 - temp_output_1_0_g12 ) ) ) , exp2( 1.050046 ) ) ) ));
			float2 panner188 = ( 1.0 * _Time.y * float2( 0.01,0.01 ) + i.uv_texcoord);
			float4 temp_output_170_0 = ( lerpResult18_g13 * tex2D( _TransicionTex, panner188 ) * _TransEmmisive_Intensity );
			float4 lerpResult118 = lerp( lerpResult116 , temp_output_170_0 , temp_output_170_0);
			float4 TransicionVar122 = lerpResult118;
			c.rgb = TransicionVar122.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
4;62;1436;817;1288.59;3214.497;2.257034;True;False
Node;AmplifyShaderEditor.CommentaryNode;193;-4337.614,-1478.401;Inherit;False;1553.089;834.8723;Noise_Intensity;12;11;1;8;4;3;5;7;6;12;104;13;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-4211.861,-1260.191;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;3;-3920.496,-1258.205;Inherit;True;1;1;1;2;3;True;1;True;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;3.06;False;2;FLOAT;4.48;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-4250.842,-985.2001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;5;-3723.901,-1248.276;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;4;-3916.524,-972.2475;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.38;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3724.13,-1072.401;Inherit;False;Constant;_Noise_Intensity;Noise_Intensity;0;0;Create;True;0;0;0;False;0;False;0.00746386;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3940.354,-731.964;Inherit;False;Constant;_Noise_Intensity2;Noise_Intensity2;1;0;Create;True;0;0;0;False;0;False;0.1635199;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3530.98,-1401.836;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-3485.603,-1224.446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3612.695,-884.8715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-3253.753,-1191.704;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;195;-4339.794,-566.8657;Inherit;False;2219.821;525.6777;Gradient;15;114;108;111;109;110;112;113;105;100;101;107;176;115;102;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-3125.754,-1399.704;Inherit;False;Noise_Intensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-4214.296,-285.1906;Inherit;False;104;Noise_Intensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-2179.373,-2883.519;Inherit;False;3320.507;1059.952;;11;83;42;71;49;68;75;93;94;96;198;199;When Visible;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-4289.794,-180.6557;Inherit;False;Property;_Transicion_Width;Transicion_Width;13;0;Create;True;0;0;0;False;0;False;1;0.666;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-3977.437,-398.836;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2128.776,-2833.345;Inherit;False;1109.7;280;Normal;4;43;46;44;200;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-3946.898,-174.1881;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2078.776,-2727.743;Inherit;False;Property;_Normal_Intensity;Normal_Intensity;4;0;Create;True;0;0;0;False;0;False;5.67;6;2;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-3786.792,-420.2749;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-3542.676,-317.8937;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-3694.471,-516.8657;Inherit;False;Property;_Cloaking;Cloaking;9;0;Create;True;0;0;0;False;0;False;0.6035187;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;108;-3535.863,-426.7949;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-1787.532,-2783.345;Inherit;True;Property;_Normal_Map;Normal_Map;3;1;[Normal];Create;True;0;0;0;False;0;False;-1;8fc276bac0dd42d45b56f9de5cf70f0b;8fc276bac0dd42d45b56f9de5cf70f0b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;110;-3321.197,-390.469;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;46;-1459.377,-2777.729;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-1234.868,-2731.122;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-3040.965,-176.0339;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;112;-3041.965,-301.0338;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;68;-962.5609,-2833.519;Inherit;False;1016.108;292.9514;Direct light;7;62;67;66;65;61;64;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-3352.788,-475.9937;Inherit;False;104;Noise_Intensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-898.0573,-2783.519;Inherit;False;200;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;196;-4350.554,-2895.432;Inherit;False;2034.653;1267.104;;2;143;163;Invisibility;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;114;-2838.965,-280.0339;Inherit;False;Inverse Lerp;-1;;10;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;61;-929.4817,-2694.078;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;71;-1359.968,-2498.76;Inherit;False;1633.278;675.1937;Specular;11;52;54;57;56;59;58;55;60;69;70;197;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;64;-636.9902,-2776.266;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;-4296.56,-2845.432;Inherit;False;1930.658;657.5611;Invisibility;15;137;130;131;134;132;135;133;138;140;139;144;165;166;190;192;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;115;-2605.182,-302.6172;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2000.407,-1651.823;Inherit;False;3331.996;998.8068;Comment;28;122;116;117;145;194;118;170;187;188;191;189;27;28;26;25;121;23;21;16;19;15;18;14;120;24;22;20;17;Transicion;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;163;-4300.554,-2153.687;Inherit;False;850.4839;525.9176;RimLight;9;156;158;159;162;160;157;161;164;168;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;62;-646.6594,-2636.064;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-4203.345,-2371.605;Inherit;False;200;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;65;-453.276,-2766.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-1342.933,-2347.632;Inherit;True;Property;_SpecularTex;SpecularTex;5;0;Create;True;0;0;0;False;0;False;-1;f38016b08b68efa409fc738f1bad346c;f38016b08b68efa409fc738f1bad346c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-2343.973,-210.1428;Inherit;False;help;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1951.72,-1238.784;Inherit;False;176;help;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;156;-4250.554,-2029.047;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;42;-2129.373,-2465.498;Inherit;False;695.7682;473.2307;Diffuse;4;47;41;40;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;157;-4276.474,-1885.338;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-300.9864,-2701.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;52;-1046.484,-2400.414;Inherit;False;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1014.114,-2038.209;Inherit;False;Property;_SpecularPower;SpecularPower;7;0;Create;True;0;0;0;False;0;False;0;0.264;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;130;-3927.25,-2430.448;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;132;-3705.689,-2599.435;Inherit;False;Property;_Refraction_Intensity;Refraction_Intensity;10;0;Create;True;0;0;0;False;0;False;0.004513069;0.008896488;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-1900.428,-1148.142;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;57;-761.244,-2144.179;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-143.8625,-2698.913;Inherit;False;DirectLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;54;-807.0942,-2371.738;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;158;-3995.041,-1940.357;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-2079.373,-2224.685;Inherit;True;Property;_Main_Tex;Main_Tex;1;0;Create;True;0;0;0;False;0;False;-1;cc8e67f05b81d374f9639b4ace3d78b1;cc8e67f05b81d374f9639b4ace3d78b1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;83;139.8508,-2869.847;Inherit;False;995.9077;448.4023;Emmesive;5;82;80;78;79;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;131;-3683.157,-2402.909;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;39;-2035.615,-2415.498;Inherit;False;Property;_Main_Tex_Color;Main_Tex_Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1888.682,-1432.248;Inherit;False;Constant;_Thickness;Thickness;3;0;Create;True;0;0;0;False;0;False;0;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;134;-3643.102,-2798.464;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-517.0976,-2105.504;Inherit;False;Property;_Specular_Intensity;Specular_Intensity;8;0;Create;True;0;0;0;False;0;False;3;1.51;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;135;-3417.786,-2717.1;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1776.902,-2317.51;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;405.4368,-2526.337;Inherit;False;Property;_Emmesive_Intensity;Emmesive_Intensity;17;0;Create;True;0;0;0;False;0;False;5;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1890.089,-1350.526;Inherit;False;Constant;_Fade;Fade;3;0;Create;True;0;0;0;False;0;False;0.3723013;0.385656;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;202.4909,-2630.023;Inherit;False;Property;_Emmesive_Color;Emmesive_Color;18;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0.8780921,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;168;-3867.235,-1747.329;Inherit;False;Property;_RimLight_Toggle;RimLight_Toggle;19;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;162;-4072.204,-1843.584;Inherit;False;Property;_RimLight_Color;RimLight_Color;20;0;Create;True;0;0;0;False;0;False;1,0,0,0;0.9837976,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;184.3636,-2820.74;Inherit;True;Property;_Emmesive_Tex;Emmesive_Tex;16;0;Create;True;0;0;0;False;0;False;-1;b30d9c999b067d040b70e1f848c7f691;b30d9c999b067d040b70e1f848c7f691;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-3399.009,-2493.036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-476.6735,-2427.824;Inherit;False;67;DirectLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;-420.4057,-2030.567;Inherit;False;Property;_SpecularColor;SpecularColor;6;0;Create;True;0;0;0;False;0;False;0.8867924,0.1631364,0.1631364,0;0.1411764,0.2243934,0.8117647,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;15;-1647.586,-1165.177;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;159;-3855.669,-1942.468;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;-1606.645,-1407.123;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;161;-4013.38,-2103.688;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;55;-456.6649,-2332.729;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-3249.917,-2606.386;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-3658.466,-1900.079;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1440.845,-1162.853;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-120.6616,-2277.131;Inherit;True;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;669.3538,-2763.094;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1461.095,-1336.247;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1623.685,-2300.254;Inherit;True;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;21;-1232.013,-1250.182;Inherit;True;Inverse Lerp;-1;;12;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;407.2064,-2194.077;Inherit;False;67;DirectLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;138;-3067.966,-2690.651;Inherit;False;Global;_GrabScreen0;Grab Screen 0;16;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-3633.213,-2023.691;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;370.5785,-2400.811;Inherit;True;47;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;139;-3257.12,-2372.902;Inherit;False;Property;_Invisibility_tint;Invisibility_tint;15;0;Create;True;0;0;0;False;0;False;0,0.3698164,0.972549,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;908.7687,-2706.375;Inherit;False;Emmesive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1323.14,-957.8165;Inherit;False;Constant;_Power;Power;2;0;Create;True;0;0;0;False;0;False;1.050046;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;100.5337,-2279.9;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;431.9641,-1981.713;Inherit;False;70;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;24;-1020.363,-1359.963;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-3031.983,-2291.209;Inherit;False;82;Emmesive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Exp2OpNode;23;-1017.307,-1012.984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-3156.125,-2452.408;Inherit;False;164;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-2941.289,-2499.219;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;598.644,-2240.382;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;790.4686,-2285.761;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;25;-879.747,-1369.398;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;189;-459.1674,-1579.27;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;166;-2852.743,-2365.683;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;121;-826.9968,-1135.38;Inherit;False;Property;_Transicion_Color;Transicion_Color;12;0;Create;True;0;0;0;False;0;False;0,0.3981171,1,0;0,0.3981171,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;188;-198.9072,-1473.704;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;26;-544.4536,-1379.912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;1012.86,-2093.892;Inherit;True;Visible;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-585.4221,-1245.288;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.56;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-2717.326,-2379.126;Inherit;False;Invisibility;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;130.4295,-999.9076;Inherit;False;75;Visible;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-23.94312,-1154.135;Inherit;False;Property;_TransEmmisive_Intensity;TransEmmisive_Intensity;14;0;Create;True;0;0;0;False;0;False;1.294118;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;65.10283,-885.5581;Inherit;False;144;Invisibility;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;107.5151,-760.1779;Inherit;False;176;help;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;187;20.05492,-1449.791;Inherit;True;Property;_TransicionTex;TransicionTex;11;0;Create;True;0;0;0;False;0;False;-1;21396ddfcd1194d11a345707eaabe8bb;21396ddfcd1194d11a345707eaabe8bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;28;-347.343,-1226.89;Inherit;True;TripleLerpFunction;-1;;13;1f875714d3afa44f6abb1d2e0e07c495;0;5;4;FLOAT;0;False;6;FLOAT;0;False;13;COLOR;0,0,0,0;False;14;COLOR;1,0.4745,0,0;False;15;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;116;351.3775,-903.7323;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;437.1944,-1167.528;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;118;717.1154,-1000.182;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;1085.442,-1000.296;Inherit;False;TransicionVar;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1817.489,-303.4711;Inherit;True;122;TransicionVar;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1386.787,-458.6519;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Shader_PaulAndresSolisVillanueva;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;5;0;3;0
WireConnection;4;0;8;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;10;0;4;0
WireConnection;10;1;11;0
WireConnection;13;0;12;1
WireConnection;13;1;6;0
WireConnection;13;2;10;0
WireConnection;104;0;13;0
WireConnection;100;0;105;0
WireConnection;103;0;102;0
WireConnection;101;0;100;0
WireConnection;101;1;103;0
WireConnection;109;1;101;0
WireConnection;108;1;101;0
WireConnection;44;5;43;0
WireConnection;110;0;107;0
WireConnection;110;3;108;0
WireConnection;110;4;109;0
WireConnection;46;0;44;0
WireConnection;200;0;46;0
WireConnection;113;0;110;0
WireConnection;113;1;103;0
WireConnection;112;0;110;0
WireConnection;112;1;103;0
WireConnection;114;1;112;0
WireConnection;114;2;113;0
WireConnection;114;3;111;0
WireConnection;64;0;63;0
WireConnection;64;1;61;0
WireConnection;115;0;114;0
WireConnection;65;0;64;0
WireConnection;176;0;115;0
WireConnection;66;0;65;0
WireConnection;66;1;62;0
WireConnection;52;0;197;0
WireConnection;130;0;192;0
WireConnection;14;0;120;0
WireConnection;57;0;56;0
WireConnection;67;0;66;0
WireConnection;54;0;52;0
WireConnection;158;0;156;0
WireConnection;158;1;157;0
WireConnection;131;0;130;0
WireConnection;135;0;134;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;15;0;14;0
WireConnection;159;0;158;0
WireConnection;20;0;17;0
WireConnection;55;0;54;0
WireConnection;55;1;57;0
WireConnection;137;0;135;0
WireConnection;137;1;133;0
WireConnection;160;0;161;0
WireConnection;160;1;159;0
WireConnection;160;2;162;0
WireConnection;160;3;168;0
WireConnection;16;0;15;0
WireConnection;59;0;69;0
WireConnection;59;1;55;0
WireConnection;59;2;60;0
WireConnection;59;3;58;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;80;2;81;0
WireConnection;19;0;20;0
WireConnection;19;1;18;0
WireConnection;47;0;41;0
WireConnection;21;1;19;0
WireConnection;21;2;20;0
WireConnection;21;3;16;0
WireConnection;138;0;137;0
WireConnection;164;0;160;0
WireConnection;82;0;80;0
WireConnection;70;0;59;0
WireConnection;24;0;21;0
WireConnection;23;0;22;0
WireConnection;140;0;138;0
WireConnection;140;1;139;0
WireConnection;199;0;198;0
WireConnection;199;1;93;0
WireConnection;94;0;199;0
WireConnection;94;1;96;0
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;166;0;140;0
WireConnection;166;1;165;0
WireConnection;166;2;190;0
WireConnection;188;0;189;0
WireConnection;26;0;25;0
WireConnection;75;0;94;0
WireConnection;144;0;166;0
WireConnection;187;1;188;0
WireConnection;28;4;27;0
WireConnection;28;6;26;0
WireConnection;28;14;121;0
WireConnection;116;0;117;0
WireConnection;116;1;145;0
WireConnection;116;2;194;0
WireConnection;170;0;28;0
WireConnection;170;1;187;0
WireConnection;170;2;191;0
WireConnection;118;0;116;0
WireConnection;118;1;170;0
WireConnection;118;2;170;0
WireConnection;122;0;118;0
WireConnection;0;13;86;0
ASEEND*/
//CHKSM=5DEFC1B50A246838C5D1A39CB1B8873ABF3FC391