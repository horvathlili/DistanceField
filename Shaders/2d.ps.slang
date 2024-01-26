#ifndef FIELD
#define FIELD 1
#endif

#if FIELD == 1
    #include "Filter/filterparam.slang"
#endif
#if FIELD == 2
    #include "Filter/filterparamg2.slang"
#endif

#include "Utils/ray.slang"
#include "Utils/spheretrace.slang"

cbuffer psCb
{
    float4 eye;
    float4 center;
    float4 up;
    float ar;
    int res;
    float boundingBox;
    float4x4 viewproj;
    bool box;
    float rs;
    int minm;
    int nx;
};

Texture2D texturep;
Texture2D texturen;
Texture2D texture3;

struct psIn
{
    float4 pos : SV_POSITION;
    float3 col : COLOR;
    float3 pixelpos : POSITION;
};

struct PsOut
{
    float4 col : SV_TARGET;
    float depth : SV_Depth;
};

PsOut main(psIn input) : SV_TARGET
{
    PsOut o;

    float4 hitpos = sphereTrace(input.pixelpos);
   
    if (hitpos.w == 1)
    {
        o.col = float4(1, 1, 1, 1);
    }
    else
    {

        float3 La = float3(0.4, 0.4, 0.4);
        float3 Ld = float3(0.8, 0.8, 0.8);
        
        float3 Ka = float3(0.2, 0.4, 0.6);
        float3 Kd = float3(0.8, 0.8, 0.8);
            
        float3 light_dir = float3(-1, -1, -1);
        
        float3 ambient = La * Ka;
        float3 diffuse = clamp(dot(normalize(-light_dir), normalize(getNormal_filter(hitpos.xyz))), 0, 1) * Ld * Kd;

        o.col = float4(ambient + diffuse, 1);
        //o.col = -float4(getNormal_filter(hitpos.xyz), 1);

    }
  
    return o;
}
