// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_PaulAndresSolisVillanueva"
{
	Properties
	{
		_MainText("MainText", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,0)
		[Toggle]_CustomAmbientLights("Custom/Ambient Lights", Float) = 0
		_ShadowStep("ShadowStep", Int) = 6
		_ShadowColor("ShadowColor", Color) = (0,0.4912767,1,0)
		_Bodyguard_Normal("Bodyguard_Normal", 2D) = "bump" {}
		_NormalScale("NormalScale", Range( 0 , 3)) = 3
		_InlineColor("InlineColor", Color) = (0,0,0,0)
		_InlineSize("InlineSize", Float) = 0.1
		_OutlineColor("OutlineColor", Color) = (0,0,0,0)
		_OutlineSize("OutlineSize", Float) = 0
		_SpecularTexture("Specular Texture", 2D) = "white" {}
		_SpecularColor("SpecularColor", Color) = (0,0,0,0)
		_SpecularSteps("SpecularSteps", Int) = 3
		_SpeculatePower("SpeculatePower", Range( 0 , 10)) = 0
		_AO_Texture("AO_Texture", 2D) = "white" {}
		_AO_Color("AO_Color", Color) = (0.3867925,0.1483668,0.06750623,0)
		_AO_Step("AO_Step", Range( 2 , 5)) = 3.340328
		_AO_Intensity("AO_Intensity", Range( 0 , 1)) = 0.3432126
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		_Bodyguard_Mask_0_A("Bodyguard_Mask_0_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_PantsColor("PantsColor", Int) = 0
		_Bodyguard_Mask_2_A("Bodyguard_Mask_2_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_ShirtColor("ShirtColor", Int) = 0
		_Bodyguard_Mask_4_A("Bodyguard_Mask_4_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_VestColor("VestColor", Int) = 0
		_Bodyguard_Mask_3_A("Bodyguard_Mask_3_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_FaceColor("FaceColor", Int) = 0
		_Bodyguard_Mask_1_A("Bodyguard_Mask_1_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_BeltColor("BeltColor", Int) = 0
		_Bodyguard_Mask_5_A("Bodyguard_Mask_5_A", 2D) = "white" {}
		[Enum(Light,0,Dark,1)]_AscColor("AscColor", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _OutlineSize;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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

		uniform sampler2D _Bodyguard_Normal;
		uniform float4 _Bodyguard_Normal_ST;
		uniform float _NormalScale;
		uniform float4 _AO_Color;
		uniform float4 _MainColor;
		uniform float _ToggleSwitch0;
		uniform sampler2D _AO_Texture;
		uniform float4 _AO_Texture_ST;
		uniform float _AO_Intensity;
		uniform float _AO_Step;
		uniform float _CustomAmbientLights;
		uniform int _ShadowStep;
		uniform float4 _ShadowColor;
		uniform sampler2D _SpecularTexture;
		uniform float4 _SpecularTexture_ST;
		uniform sampler2D _MainText;
		uniform float4 _MainText_ST;
		uniform float _SpeculatePower;
		uniform int _SpecularSteps;
		uniform float4 _SpecularColor;
		uniform float4 _InlineColor;
		uniform float _InlineSize;
		uniform int _PantsColor;
		uniform sampler2D _Bodyguard_Mask_0_A;
		uniform float4 _Bodyguard_Mask_0_A_ST;
		uniform int _AscColor;
		uniform sampler2D _Bodyguard_Mask_5_A;
		uniform float4 _Bodyguard_Mask_5_A_ST;
		uniform int _BeltColor;
		uniform sampler2D _Bodyguard_Mask_1_A;
		uniform float4 _Bodyguard_Mask_1_A_ST;
		uniform int _ShirtColor;
		uniform sampler2D _Bodyguard_Mask_2_A;
		uniform float4 _Bodyguard_Mask_2_A_ST;
		uniform int _FaceColor;
		uniform sampler2D _Bodyguard_Mask_3_A;
		uniform float4 _Bodyguard_Mask_3_A_ST;
		uniform int _VestColor;
		uniform sampler2D _Bodyguard_Mask_4_A;
		uniform float4 _Bodyguard_Mask_4_A_ST;
		uniform float4 _OutlineColor;
		uniform float _OutlineSize;


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 Outline260 = 0;
			v.vertex.xyz += Outline260;
			v.vertex.w = 1;
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
			float2 uv_Bodyguard_Normal = i.uv_texcoord * _Bodyguard_Normal_ST.xy + _Bodyguard_Normal_ST.zw;
			float3 normalizeResult184 = normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _Bodyguard_Normal, uv_Bodyguard_Normal ), _NormalScale ) )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g37 = dot( normalizeResult184 , ase_worldlightDir );
			float NormalTex239 = (dotResult5_g37*0.5 + 0.5);
			float4 MainColor108 = _MainColor;
			float2 uv_AO_Texture = i.uv_texcoord * _AO_Texture_ST.xy + _AO_Texture_ST.zw;
			float lerpResult102 = lerp( 0.0 , tex2D( _AO_Texture, uv_AO_Texture ).r , _AO_Intensity);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult87 = dot( ase_worldNormal , ase_worldlightDir );
			float BasicLight95 = saturate( dotResult87 );
			float lerpResult103 = lerp( lerpResult102 , 0.0 , BasicLight95);
			float temp_output_2_0_g8 = _AO_Step;
			float4 lerpResult107 = lerp( _AO_Color , MainColor108 , ( floor( ( (( _ToggleSwitch0 )?( lerpResult103 ):( lerpResult102 )) * temp_output_2_0_g8 ) ) / temp_output_2_0_g8 ));
			float4 AO113 = lerpResult107;
			float temp_output_2_0_g4 = (float)_ShadowStep;
			float4 ShadowColor246 = ( ase_lightAtten * ( floor( ( BasicLight95 * temp_output_2_0_g4 ) ) / temp_output_2_0_g4 ) * _ShadowColor );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_SpecularTexture = i.uv_texcoord * _SpecularTexture_ST.xy + _SpecularTexture_ST.zw;
			float4 tex2DNode124 = tex2D( _SpecularTexture, uv_SpecularTexture );
			float4 CustomLight250 = ( ( ase_lightColor * tex2DNode124 ) + ( tex2DNode124 * UNITY_LIGHTMODEL_AMBIENT ) );
			float2 uv_MainText = i.uv_texcoord * _MainText_ST.xy + _MainText_ST.zw;
			float4 Diffuse31 = ( tex2D( _MainText, uv_MainText ) * MainColor108 );
			float4 AmbienSceneLight77 = ( ( ase_lightColor * ase_lightAtten * Diffuse31 * BasicLight95 ) + ( Diffuse31 * UNITY_LIGHTMODEL_AMBIENT ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult4_g2 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult13 = dot( ase_worldNormal , normalizeResult4_g2 );
			float temp_output_2_0_g3 = (float)_SpecularSteps;
			float4 Specular23 = ( CustomLight250 + ( ( floor( ( ( pow( saturate( dotResult13 ) , exp2( _SpeculatePower ) ) * BasicLight95 ) * temp_output_2_0_g3 ) ) / temp_output_2_0_g3 ) * _SpecularColor ) );
			float dotResult43 = dot( ase_worldNormal , ase_worldViewDir );
			float4 lerpResult48 = lerp( Specular23 , _InlineColor , step( dotResult43 , _InlineSize ));
			float4 InlineSpecular257 = lerpResult48;
			Gradient gradient216 = NewGradient( 0, 2, 2, float4( 0.6367924, 0.8119867, 1, 0 ), float4( 0.07497215, 0, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_0_A = i.uv_texcoord * _Bodyguard_Mask_0_A_ST.xy + _Bodyguard_Mask_0_A_ST.zw;
			Gradient gradient220 = NewGradient( 0, 2, 2, float4( 0.5, 0.5, 0.5, 0 ), float4( 0, 0, 0, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_5_A = i.uv_texcoord * _Bodyguard_Mask_5_A_ST.xy + _Bodyguard_Mask_5_A_ST.zw;
			Gradient gradient223 = NewGradient( 0, 2, 2, float4( 0.2358491, 0.2358491, 0.2358491, 0 ), float4( 0, 0, 0, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_1_A = i.uv_texcoord * _Bodyguard_Mask_1_A_ST.xy + _Bodyguard_Mask_1_A_ST.zw;
			Gradient gradient226 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 0, 0.4339623, 0.4156578, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_2_A = i.uv_texcoord * _Bodyguard_Mask_2_A_ST.xy + _Bodyguard_Mask_2_A_ST.zw;
			Gradient gradient229 = NewGradient( 0, 2, 2, float4( 1, 0.8575528, 0.6352941, 0 ), float4( 0.5849056, 0.3399062, 0, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_3_A = i.uv_texcoord * _Bodyguard_Mask_3_A_ST.xy + _Bodyguard_Mask_3_A_ST.zw;
			Gradient gradient232 = NewGradient( 0, 2, 2, float4( 0.3130562, 0.6408836, 0.990566, 0 ), float4( 0.03092852, 0, 0.4150943, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_Bodyguard_Mask_4_A = i.uv_texcoord * _Bodyguard_Mask_4_A_ST.xy + _Bodyguard_Mask_4_A_ST.zw;
			float4 EachPartTex214 = ( ( ( SampleGradient( gradient216, (float)_PantsColor ) * tex2D( _Bodyguard_Mask_0_A, uv_Bodyguard_Mask_0_A ) ) + ( SampleGradient( gradient220, (float)_AscColor ) * tex2D( _Bodyguard_Mask_5_A, uv_Bodyguard_Mask_5_A ) ) + ( SampleGradient( gradient223, (float)_BeltColor ) * tex2D( _Bodyguard_Mask_1_A, uv_Bodyguard_Mask_1_A ) ) ) + ( ( SampleGradient( gradient226, (float)_ShirtColor ) * tex2D( _Bodyguard_Mask_2_A, uv_Bodyguard_Mask_2_A ) ) + ( SampleGradient( gradient229, (float)_FaceColor ) * tex2D( _Bodyguard_Mask_3_A, uv_Bodyguard_Mask_3_A ) ) + ( SampleGradient( gradient232, (float)_VestColor ) * tex2D( _Bodyguard_Mask_4_A, uv_Bodyguard_Mask_4_A ) ) ) );
			c.rgb = ( NormalTex239 * ( AO113 + (( _CustomAmbientLights )?( AmbienSceneLight77 ):( ( ShadowColor246 + CustomLight250 ) )) + InlineSpecular257 ) * EachPartTex214 ).rgb;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
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
4;62;1367;692;8881.783;2098.911;10.30693;True;True
Node;AmplifyShaderEditor.CommentaryNode;278;-1240.203,-938.5453;Inherit;False;1015.157;1331.884;Comment;3;97;110;98;Funciones Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1183.519,-15.56001;Inherit;False;736.7051;408.8983;BasicLight;5;88;85;86;87;95;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;86;-1133.519,214.3384;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;85;-1102.597,48.48272;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;243;-2732.793,602.0298;Inherit;False;2548.795;616.2526;Comment;16;12;185;16;13;15;14;17;19;18;20;35;236;21;23;252;251;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;87;-908.1565,155.5424;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-2682.793,843.1947;Inherit;False;Blinn-Phong Half Vector;-1;;2;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;185;-2592.948,669.5317;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;249;-2719.861,-697.7349;Inherit;False;834.2867;642.3591;Comment;6;24;124;26;25;242;27;CustomLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2438.929,940.7802;Inherit;False;Property;_SpeculatePower;SpeculatePower;16;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;110;-1188.962,-888.5453;Inherit;False;507.8444;257;MainColor;2;29;108;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;13;-2329.463,729.3929;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;88;-817.7065,52.04229;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-665.7032,83.64324;Inherit;True;BasicLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-1138.962,-838.5453;Inherit;False;Property;_MainColor;MainColor;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;124;-2669.861,-517.1994;Inherit;True;Property;_SpecularTexture;Specular Texture;13;0;Create;True;0;0;0;False;0;False;-1;264cc9ef54d8bf54e9d4f41915055c57;264cc9ef54d8bf54e9d4f41915055c57;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;27;-2635.795,-289.9217;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-2123.537,694.7104;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;24;-2658.097,-647.7349;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Exp2OpNode;15;-2112.698,815.0152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-1975.769,1012.893;Inherit;False;95;BasicLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;-1190.203,-560.7657;Inherit;False;915.1569;473.421;Diffuse;4;30;31;109;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2293.363,-308.3756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;17;-1972.885,723.9738;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2315.191,-588.1392;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-905.1165,-784.7073;Inherit;False;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1700.843,713.1355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-2038.574,-466.431;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;116;-2770.118,1749.316;Inherit;False;2073.375;656.7156;Comment;12;112;113;105;100;101;99;104;111;107;102;118;119;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;19;-1739.607,861.6666;Inherit;False;Property;_SpecularSteps;SpecularSteps;15;0;Create;True;0;0;0;False;0;False;3;3;False;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1148.912,-503.478;Inherit;True;Property;_MainText;MainText;2;0;Create;True;0;0;0;False;0;False;-1;418615141e6970344ab49489d6351044;418615141e6970344ab49489d6351044;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1092.693,-287.0721;Inherit;False;108;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;100;-2720.118,2064.935;Inherit;True;Property;_AO_Texture;AO_Texture;17;0;Create;True;0;0;0;False;0;False;-1;0c02644cdb3475440b3c4f20fa122390;0c02644cdb3475440b3c4f20fa122390;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;101;-2714.534,2291.031;Inherit;False;Property;_AO_Intensity;AO_Intensity;20;0;Create;True;0;0;0;False;0;False;0.3432126;0.3432126;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-774.3835,-347.983;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-1650.332,996.3734;Inherit;False;Property;_SpecularColor;SpecularColor;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-2747.416,2504.185;Inherit;False;1391.227;1140.033;Comment;4;76;70;79;77;Scene/AmbientLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;35;-1531.972,705.3926;Inherit;True;SimplePosterize;-1;;3;bd87e9d9ca3a744f99641f8bf7009d97;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;250;-1790.714,-471.7416;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;238;-2732.411,56.6329;Inherit;False;909.8119;452.8705;Comment;6;7;36;9;10;245;267;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;259;-1085.269,2942.524;Inherit;False;1328.888;649.6108;Comment;9;41;42;45;43;47;46;48;257;244;Inline;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;7;-2688.225,322.8953;Inherit;False;Property;_ShadowStep;ShadowStep;5;0;Create;True;0;0;0;False;0;False;6;4;False;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;102;-2358.117,2141.028;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;267;-2702.893,128.9558;Inherit;False;95;BasicLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1323.482,1018.506;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2567.312,1820.873;Inherit;False;95;BasicLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;-1239.889,835.0865;Inherit;False;250;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;112;-2201.726,1801.219;Inherit;False;315;303;AO con luz directa;1;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;240;-2745.575,1293.099;Inherit;False;1452.45;362.1521;Comment;6;181;182;184;191;183;239;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2676.005,3141.397;Inherit;False;1051.483;476.5875;Ambient Light;3;69;93;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-499.0466,-340.8311;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;235;-4928.395,410.4074;Inherit;False;1841.581;2670.67;Comment;34;219;220;221;224;230;229;216;233;232;227;226;223;193;234;231;228;225;222;195;194;218;198;196;197;209;213;208;206;212;207;211;210;199;214;Texture Atlas;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-2697.416,2554.185;Inherit;False;633.1058;543.5242;SceneLightColor;5;74;71;81;94;96;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GradientNode;223;-4856.513,1320.62;Inherit;False;0;2;2;0.2358491,0.2358491,0.2358491,0;0,0,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.LightAttenuation;81;-2668.876,2633.592;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-2437.665,2977.662;Inherit;False;31;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;36;-2455.322,118.1945;Inherit;True;SimplePosterize;-1;;4;bd87e9d9ca3a744f99641f8bf7009d97;0;2;1;FLOAT;0.52;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;216;-4868.638,460.4075;Inherit;False;0;2;2;0.6367924,0.8119867,1,0;0.07497215,0,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientNode;229;-4871.944,2172.478;Inherit;False;0;2;2;1,0.8575528,0.6352941,0;0.5849056,0.3399062,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.IntNode;219;-4836.531,584.456;Inherit;False;Property;_PantsColor;PantsColor;23;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;230;-4839.837,2296.527;Inherit;False;Property;_FaceColor;FaceColor;29;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;63;-2466.292,3409.191;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2548.186,2813.939;Inherit;False;95;BasicLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;220;-4829.942,918.5201;Inherit;False;0;2;2;0.5,0.5,0.5,0;0,0,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;-970.1221,917.7568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;227;-4833.386,1887.944;Inherit;False;Property;_ShirtColor;ShirtColor;25;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;103;-2151.726,1851.219;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;232;-4878.395,2598.264;Inherit;False;0;2;2;0.3130562,0.6408836,0.990566,0;0.03092852,0,0.4150943,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.LightAttenuation;9;-2222.75,89.6051;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;233;-4846.288,2722.313;Inherit;False;Property;_VestColor;VestColor;27;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2421.456,3289.784;Inherit;False;31;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-2695.575,1390.726;Inherit;False;Property;_NormalScale;NormalScale;8;0;Create;True;0;0;0;False;0;False;3;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;42;-1031.067,3363.915;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;41;-1035.269,3172.7;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GradientNode;226;-4865.493,1763.895;Inherit;False;0;2;2;1,1,1,0;0,0.4339623,0.4156578,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.IntNode;224;-4824.406,1444.668;Inherit;False;Property;_BeltColor;BeltColor;31;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.LightColorNode;71;-2459.44,2587.599;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;245;-2367.112,338.6737;Inherit;False;Property;_ShadowColor;ShadowColor;6;0;Create;True;0;0;0;False;0;False;0,0.4912767,1,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;221;-4797.835,1042.569;Inherit;False;Property;_AscColor;AscColor;33;1;[Enum];Create;True;0;2;Light;0;Dark;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;181;-2395.573,1349.469;Inherit;True;Property;_Bodyguard_Normal;Bodyguard_Normal;7;0;Create;True;0;0;0;False;0;False;-1;97931d4271ac99f4a8718f252e1e9f4c;97931d4271ac99f4a8718f252e1e9f4c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-701.1663,3464.777;Inherit;False;Property;_InlineSize;InlineSize;10;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;218;-4648.267,502.7305;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;193;-4590.232,727.8949;Inherit;True;Property;_Bodyguard_Mask_0_A;Bodyguard_Mask_0_A;22;0;Create;True;0;0;0;False;0;False;-1;ef4c5acc99318ae4d8e3b60da9168c48;ef4c5acc99318ae4d8e3b60da9168c48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;196;-4634.308,2432.686;Inherit;True;Property;_Bodyguard_Mask_3_A;Bodyguard_Mask_3_A;28;0;Create;True;0;0;0;False;0;False;-1;8db38c78959ad0b43b01114e9bfc701b;8db38c78959ad0b43b01114e9bfc701b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;222;-4611.472,943.7418;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;195;-4608.32,2021.465;Inherit;True;Property;_Bodyguard_Mask_2_A;Bodyguard_Mask_2_A;24;0;Create;True;0;0;0;False;0;False;-1;d8bc3172b29b1e34a84d9bce6c8ca705;d8bc3172b29b1e34a84d9bce6c8ca705;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2096.482,3308.033;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2276.867,2622.958;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2022.473,231.2605;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;234;-4658.024,2640.587;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;231;-4651.574,2214.801;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;198;-4581.512,1145.928;Inherit;True;Property;_Bodyguard_Mask_5_A;Bodyguard_Mask_5_A;32;0;Create;True;0;0;0;False;0;False;-1;99e13a9330c09934fac0f667615c22c7;99e13a9330c09934fac0f667615c22c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;43;-772.6096,3292.472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;104;-1831.708,2130.185;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;21;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;225;-4636.143,1362.943;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-758.2584,888.8494;Inherit;True;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;228;-4645.123,1806.218;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;-1875.672,2268.683;Inherit;False;Property;_AO_Step;AO_Step;19;0;Create;True;0;0;0;False;0;False;3.340328;3.340328;2;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-4615.97,2851.077;Inherit;True;Property;_Bodyguard_Mask_4_A;Bodyguard_Mask_4_A;26;0;Create;True;0;0;0;False;0;False;-1;96255b95831b1674db3a7201c7528296;96255b95831b1674db3a7201c7528296;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;194;-4593.245,1581.419;Inherit;True;Property;_Bodyguard_Mask_1_A;Bodyguard_Mask_1_A;30;0;Create;True;0;0;0;False;0;False;-1;e1fd0f19f8ebbc64d9efecc3ea917db4;e1fd0f19f8ebbc64d9efecc3ea917db4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-4163.364,989.806;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-4198.285,2276.58;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;-632.5344,2992.524;Inherit;False;23;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;246;-1745.843,232.8344;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;47;-524.6559,3339.135;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-1593.799,1799.316;Inherit;False;Property;_AO_Color;AO_Color;18;0;Create;True;0;0;0;False;0;False;0.3867925,0.1483668,0.06750623,0;0.3867925,0.1483668,0.06750623,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-4126.369,1886.372;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;118;-1581.358,2190.921;Inherit;True;SimplePosterize;-1;;8;bd87e9d9ca3a744f99641f8bf7009d97;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-542.6557,3131.135;Inherit;False;Property;_InlineColor;InlineColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;182;-2060.418,1343.099;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-1850.802,2925.656;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-4172.665,2784.114;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;279;312.7066,1230.204;Inherit;False;1450.751;521.2415;Comment;12;264;247;256;248;255;120;258;121;241;265;192;261;Suma de todo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-4150.307,1379.334;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1579.824,2025.005;Inherit;False;108;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-4227.787,650.2936;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;362.7066,1466.383;Inherit;False;250;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1579.189,2932.266;Inherit;True;AmbienSceneLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;107;-1249.92,2056.834;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;-3919.637,902.7611;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;262;-598.7563,2481.953;Inherit;False;773.8207;344.1849;Comment;4;50;49;60;260;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;184;-2068.371,1535.055;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;48;-215.8864,3168.607;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;247;385.8106,1357.519;Inherit;False;246;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;211;-3816.437,2201.794;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;-3599.34,1466.228;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;257;19.61912,3208.814;Inherit;False;InlineSpecular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-548.7563,2711.138;Inherit;False;Property;_OutlineSize;OutlineSize;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-920.7435,2070.161;Inherit;False;AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;248;639.3598,1510.7;Inherit;False;77;AmbienSceneLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;256;683.2366,1397.047;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;191;-1827.578,1402.251;Inherit;True;Half Lambert Term;-1;;37;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-521.7563,2535.138;Inherit;False;Property;_OutlineColor;OutlineColor;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;255;895.9547,1442.643;Inherit;False;Property;_CustomAmbientLights;Custom/Ambient Lights;4;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;258;981.3403,1551.415;Inherit;False;257;InlineSpecular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;1008.665,1357.035;Inherit;False;113;AO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;60;-315.6707,2531.953;Inherit;False;0;True;None;0;0;Front;True;True;True;True;0;False;-1;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;214;-3310.814,1510.461;Inherit;False;EachPartTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;-1517.125,1456.077;Inherit;False;NormalTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;1262.004,1280.204;Inherit;False;239;NormalTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;265;1255.868,1636.445;Inherit;False;214;EachPartTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;-48.93571,2532.394;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;272;-5054.636,-832.4846;Inherit;False;1428.03;463;Hice una funcion donde nomas uso todo en una textura, y aqui dependiendo del color 3, es la parte de la textura que se usa;4;270;269;268;276;Intento Fallido Del Atlas;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;1253.597,1386.981;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;277;-4740.265,-760.1736;Inherit;False;756.5293;745.2469;A la hora de juntarlos, no se junta porque suma los negros, aqui ya me atore y por tiempo lo deje;1;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;275;-4690.265,-267.9267;Inherit;True;ChooseText;0;;40;acdd73ff4cc974184a7c6b45a035a58a;0;2;9;COLOR;0,0,0,0;False;6;COLOR;1,1,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;1550.302,1557.168;Inherit;False;260;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;1527.457,1324.911;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;268;-4670.938,-712.1551;Inherit;True;ChooseText;0;;38;acdd73ff4cc974184a7c6b45a035a58a;0;2;9;COLOR;0,0,0,0;False;6;COLOR;1,1,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;270;-5003.636,-576.4844;Inherit;False;Constant;_Color3;Color 3;33;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;269;-5004.636,-782.4846;Inherit;False;Constant;_Color2;Color 2;33;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;273;-5013.053,-134.2384;Inherit;False;Constant;_Color4;Color 3;33;0;Create;True;0;0;0;False;0;False;0,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;274;-5014.053,-340.2382;Inherit;False;Constant;_Color5;Color 2;33;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;276;-4208.827,-474.63;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1895.043,1221.064;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Shader_PaulAndresSolisVillanueva;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;87;0;85;0
WireConnection;87;1;86;0
WireConnection;13;0;185;0
WireConnection;13;1;12;0
WireConnection;88;0;87;0
WireConnection;95;0;88;0
WireConnection;14;0;13;0
WireConnection;15;0;16;0
WireConnection;26;0;124;0
WireConnection;26;1;27;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;25;0;24;0
WireConnection;25;1;124;0
WireConnection;108;0;29;0
WireConnection;18;0;17;0
WireConnection;18;1;236;0
WireConnection;242;0;25;0
WireConnection;242;1;26;0
WireConnection;30;0;28;0
WireConnection;30;1;109;0
WireConnection;35;1;18;0
WireConnection;35;2;19;0
WireConnection;250;0;242;0
WireConnection;102;1;100;1
WireConnection;102;2;101;0
WireConnection;21;0;35;0
WireConnection;21;1;20;0
WireConnection;31;0;30;0
WireConnection;36;1;267;0
WireConnection;36;2;7;0
WireConnection;252;0;251;0
WireConnection;252;1;21;0
WireConnection;103;0;102;0
WireConnection;103;2;99;0
WireConnection;181;5;183;0
WireConnection;218;0;216;0
WireConnection;218;1;219;0
WireConnection;222;0;220;0
WireConnection;222;1;221;0
WireConnection;69;0;93;0
WireConnection;69;1;63;0
WireConnection;74;0;71;0
WireConnection;74;1;81;0
WireConnection;74;2;94;0
WireConnection;74;3;96;0
WireConnection;10;0;9;0
WireConnection;10;1;36;0
WireConnection;10;2;245;0
WireConnection;234;0;232;0
WireConnection;234;1;233;0
WireConnection;231;0;229;0
WireConnection;231;1;230;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;225;0;223;0
WireConnection;225;1;224;0
WireConnection;23;0;252;0
WireConnection;228;0;226;0
WireConnection;228;1;227;0
WireConnection;207;0;222;0
WireConnection;207;1;198;0
WireConnection;212;0;231;0
WireConnection;212;1;196;0
WireConnection;246;0;10;0
WireConnection;47;0;43;0
WireConnection;47;1;45;0
WireConnection;209;0;228;0
WireConnection;209;1;195;0
WireConnection;118;1;104;0
WireConnection;118;2;119;0
WireConnection;182;0;181;0
WireConnection;79;0;74;0
WireConnection;79;1;69;0
WireConnection;213;0;234;0
WireConnection;213;1;197;0
WireConnection;208;0;225;0
WireConnection;208;1;194;0
WireConnection;206;0;218;0
WireConnection;206;1;193;0
WireConnection;77;0;79;0
WireConnection;107;0;105;0
WireConnection;107;1;111;0
WireConnection;107;2;118;0
WireConnection;210;0;206;0
WireConnection;210;1;207;0
WireConnection;210;2;208;0
WireConnection;184;0;182;0
WireConnection;48;0;244;0
WireConnection;48;1;46;0
WireConnection;48;2;47;0
WireConnection;211;0;209;0
WireConnection;211;1;212;0
WireConnection;211;2;213;0
WireConnection;199;0;210;0
WireConnection;199;1;211;0
WireConnection;257;0;48;0
WireConnection;113;0;107;0
WireConnection;256;0;247;0
WireConnection;256;1;264;0
WireConnection;191;3;184;0
WireConnection;255;0;256;0
WireConnection;255;1;248;0
WireConnection;60;0;49;0
WireConnection;60;1;50;0
WireConnection;214;0;199;0
WireConnection;239;0;191;0
WireConnection;260;0;60;0
WireConnection;121;0;120;0
WireConnection;121;1;255;0
WireConnection;121;2;258;0
WireConnection;275;9;274;0
WireConnection;275;6;273;0
WireConnection;192;0;241;0
WireConnection;192;1;121;0
WireConnection;192;2;265;0
WireConnection;268;9;269;0
WireConnection;268;6;270;0
WireConnection;276;0;268;0
WireConnection;276;1;275;0
WireConnection;0;13;192;0
WireConnection;0;11;261;0
ASEEND*/
//CHKSM=463E757D45D13AA24B001DA9006E94C6133262B9