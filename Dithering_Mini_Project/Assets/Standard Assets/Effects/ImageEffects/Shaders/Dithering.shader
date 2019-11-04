Shader "AAU/Dither"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			int _ColourDepth;
			float _DitherStrength; //Sets the slider of the dither Strength to be between 0 and 1

			static const float4x4 ditherTable = float4x4 //Unity's built in dithertable, and we set the read vector to be 4x4
			(
				-4.0, 0.0, -3.0, 1.0,
				2.0, -2.0, 3.0, -1.0,
				-3.0, 1.0, -4.0, 0.0,
				3.0, -1.0, 2.0, -2.0
			);

			fixed4 frag (v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex,i.uv);
				uint2 pixelCoord = i.uv*_ScreenParams.xy; //warning that modulus is slow on integers, so use uint
				col += ditherTable[pixelCoord.x % 4][pixelCoord.y % 4] * _DitherStrength; //Algorithm for determining the dithering intesity.
				return round(col * _ColourDepth) / _ColourDepth;
			}
			ENDCG
		}
	}
}