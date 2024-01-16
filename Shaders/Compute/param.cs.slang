#include "paramsurf.slang"

RWTexture2D<float3> texp;
RWTexture2D<float3> texn;



cbuffer csCb
{
    int res;
    float boundingBox;
};

float2 getUV(float x, float y)
{
    return float2(x / (float) res -1, y / (float) res -1);

}

[numthreads(8, 8)]
void main(uint2 threadId : SV_DispatchThreadID)
{
    
    
    if (any(threadId.xy >= float2(res)))
        return;

    float2 uv = getUV(threadId.x, threadId.y);

    float3 p = mapP(uv.x, uv.y);
    float3 n = getNormalP(uv.x, uv.y);
    
    texp[threadId.xy] = p;
    texn[threadId.xy] = n;
}


