#include "../Compute/paramsurf.slang"
#include "geomNewton.slang"

float2x2 inverse(float2x2 m)
{
    return float2x2(m[1][1], -m[0][1],
             -m[1][0], m[0][0]) / (m[0][0] * m[1][1] - m[0][1] * m[1][0]);
}


float coneDist(float3 p)
{

    float2 c = float2(1, 0);
   float2 q = float2(length(p.xz), -p.y);
    float d = length(q - c * max(dot(q, c), 0.0));
    return d * ((q.x * c.y - q.y * c.x < 0.0) ? -1.0 : 1.0);
}


float geomNewtonk(float3 pos)
{
    float2 t = geomNewton(pos, 0);

    float3 pn = mapP(t.x, t.y);

    return length(pos - pn);

}

float map(float3 pos)
{
#if SHAPE == 0
    return abs(length(pos) - 1);
    //return geomNewtonk(pos);
#endif
#if SHAPE == 1
    return geomNewtonk(pos);

#endif
    #if SHAPE == 2
    float x = dot(pos , float3(0,0,1));
    float y = dot(pos, float3(1,0,0));

    return length(float2(x, y)) - 1;
    return geomNewtonk(pos);

#endif
    return 0;
}
