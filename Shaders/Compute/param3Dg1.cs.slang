#include "paramsurf.slang"
#include "../Utils/geomNewton.slang"

RWTexture3D<float3> texp;
RWTexture3D<float3> texn;
RWTexture3D<float3> tex3;

RWStructuredBuffer<float4> data1;

cbuffer csCb
{
    int res;
    float boundingBox;
    int shape;
    int n;
    int nx;
};



[numthreads(8, 8,8)]
void main(uint3 threadId : SV_DispatchThreadID)
{
    
    
    if (any(threadId.xyz >= float3(res)))
        return;

    float3 pos = float3(-(float) boundingBox / 2.0);
    pos.x += (float) boundingBox / (float) res * (threadId.x + 0.5);
    pos.y += (float) boundingBox / (float) res * (threadId.y + 0.5);
    pos.z += (float) boundingBox / (float) res * (threadId.z + 0.5);


    float2 uv = geomNewton(pos);

    float3 p = mapP(uv.x, uv.y);

    float3 du = getdu(uv.x, uv.y);
    float3 dv = getdv(uv.x, uv.y);


    float3 n = normalize(cross(du, dv));

    if (dv.x == 0 && dv.z == 0 && dv.y == 0)
    {
        n = float3(0, 1, 0);
    }
    if (du.x == 0 && du.z == 0 && du.y == 0)
    {
        n = float3(0, -1, 0);
    }
    
    texp[threadId.xyz] = p;
    texn[threadId.xyz] = n;

    int datai = threadId.x * res*res + threadId.y*res+threadId.z;
  
   
    data1[datai] = float4(p, 0);
}


