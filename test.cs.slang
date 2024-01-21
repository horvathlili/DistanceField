#ifndef FIELD
#define FIELD 1
#endif

#if FIELD == 1
    #include "../Filter/filterparam.slang"
#endif
#if FIELD == 2
    #include "../Filter/filterparamg2.slang"
#endif

#include "param.slang"


cbuffer csCb
{
    int testres;
    float boundingbox;
    int res;
};


Texture2D texturep;
Texture2D texturen;
Texture2D texture3;


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
        error = abs(map(pos) - filter(pos));
    }

  
    
    
   
}

