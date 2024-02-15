//#include "implicitsurf.slang"
#include "../Utils/newton.slang"

RWTexture3D<float3> texp;
RWTexture3D<float3> texn;
RWTexture3D<float3> tex3;

RWStructuredBuffer<float4> data1;

cbuffer csCb
{
    int res;
    float boundingBox;
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




    float3 p = newton(pos);



    float3 n = normalize(pos-p);

    
    texp[threadId.xyz] = p;
    texn[threadId.xyz] = n;

    int datai = threadId.x * res * res + threadId.y * res + threadId.z;
}




