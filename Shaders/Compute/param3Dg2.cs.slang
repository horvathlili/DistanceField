#include "paramsurf.slang"
#include "../Utils/geomNewton.slang"

RWTexture3D<float4> texp;
RWTexture3D<float4> texn;
RWTexture3D<float4> tex3;

RWStructuredBuffer<float4> data1;

cbuffer csCb
{
    int res;
    float boundingBox;
    int shape;
    int n;
    int nx;
};



[numthreads(8, 8, 8)]
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

        dv = cross(n, du);
    }
    if (du.x == 0 && du.z == 0 && du.y == 0)
    {
        n = float3(0, -1, 0);
        du = cross(n, dv);
    }
    
    float3 duu = getduu(uv.x, uv.y);
    float3 dvv = getdvv(uv.x, uv.y);

    float3 duv = getduv(uv.x, uv.y);
    
    float E = dot(du, du);
    float F = dot(du, dv);
    float G = dot(dv, dv);

    float L = dot(duu, n);
    float M = dot(duv, n);
    float N = dot(dvv, n);

    float g = (L * N - M * M) / (E * G - F * F); //gauss curvature
    float h = (L * G - 2 * M * F + N * E) / (2 * (E * G - F * F)); //mean curvature

    float kr = h + sqrt(max(h * h - g, 0));

    float kR = h - sqrt(max(h * h - g, 0));

    float r;

    if (abs(kr) < abs(kR))
    {
        r = kr;
        kr = kR;
        kR = r;
    }

    
    float l = -(M - kr * F) / (N - kr * G);

    float3 t = normalize(du) + l * normalize(dv);

    t = normalize(t);

   
    
    texp[threadId.xyz] = float4(p, kr);
    texn[threadId.xyz] = float4(n, kR);
    tex3[threadId.xyz] = float4(t, kR);

    int datai = threadId.x * res * res + threadId.y * res + threadId.z;
   
    data1[datai] = float4(kr, kR, 0, 0);
}



