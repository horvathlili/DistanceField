#include "paramsurf.slang"

RWTexture2D<float3> texp;
RWTexture2D<float3> texn;
RWTexture2D<float3> tex3;

RWStructuredBuffer<float4> data1;

cbuffer csCb
{
    int res;
    float boundingBox;
    int shape;
    int n;
    int m;
};

float2 getUV(float x, float y)
{
    return float2((x ) / (float) (res), (y ) / (float) (res));

}

[numthreads(8, 8)]
void main(uint2 threadId : SV_DispatchThreadID)
{
    
    
    if (any(threadId.xy >= float2(res)))
        return;

    float2 uv = getUV(threadId.x, threadId.y);

    float3 p = mapP(uv.x, uv.y);
    float3 n = getNormalP(uv.x, uv.y);

    float3 du = getdu(uv.x, uv.y);
    float3 dv = getdv(uv.x, uv.y);

    n = normalize(cross(du, dv));
    
    texp[threadId.xy] = p;
    texn[threadId.xy] = n;

    int datai = threadId.x * res + threadId.y;
  
   
   data1[datai] = float4(p,0);
}


