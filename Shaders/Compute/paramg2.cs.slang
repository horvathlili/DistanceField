#include "paramsurf.slang"

RWTexture2D<float4> texp;
RWTexture2D<float4> texn;
RWTexture2D<float4> tex3;

RWStructuredBuffer<float4> data1;

cbuffer csCb
{
    int res;
    float boundingBox;
};

float2 getUV(float x, float y)
{
    return float2(x / (float) (res ), y / (float) (res ));

}

[numthreads(8, 8)]
void main(uint2 threadId : SV_DispatchThreadID)
{
    
    
    if (any(threadId.xy >= float2(res)))
        return;

    float2 uv = getUV(threadId.x, threadId.y);

    float3 p = mapP(uv.x, uv.y);
   

    

    float e = 0.00001;

    float3 du = getdu(uv.x, uv.y);
    float3 dv = getdv(uv.x, uv.y);

    float3 n = normalize(cross(du, dv));

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

    float r = h + sqrt(abs(h * h - g));

    float R = h - sqrt(abs(h * h - g));

   

    
    float l = -(M - r * F) / (N - r * G);

    float3 t = normalize(dv) + l * normalize(du);

    t = normalize(t);

    
    
    
    texp[threadId.xy] = float4(p, r);
    texn[threadId.xy] = float4(n, R);
    tex3[threadId.xy] = float4(t, R);

    int datai = threadId.x * res + threadId.y;
  
   
    data1[datai] = float4(R, r,0,0);
}


