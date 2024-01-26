#include "../includes.slang"
#include "../Utils/param.slang"


cbuffer csCb
{
    int testres;
    float boundingBox;
    int res;
    int n;
    int m;
    int shape;
    float rs;
    int nx;
};

RWStructuredBuffer<float> data1;


float3 getQueryPoint(float3 p)
{
    float3 pos = float3(-(float) boundingBox / 2.0);
    pos.x += (float) boundingBox / (float) testres * (p.x + 0.5);
    pos.y += (float) boundingBox / (float) testres * (p.y + 0.5);
    pos.z += (float) boundingBox / (float) testres * (p.z + 0.5);

    return pos;
}

[numthreads(8, 8)]
void main(uint2 threadId : SV_DispatchThreadID)
{
    if (any(threadId.xy >= float2(testres)))
        return;

    float error = 0;
   

    for (int i = 0; i < testres; i++)
    {

        float3 pos = getQueryPoint(float3(threadId.xy, i));
        
        error = abs(map(pos) - abs(filter(pos)));
        //error = map(pos);
        data1[threadId.x * testres * testres + threadId.y * testres + i] = error;
  
    }

    
}

