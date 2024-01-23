#include "../Compute/paramsurf.slang"

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


float geomNewton(float3 pos)
{
    float2 t = float2(1, 1);

    for (int i = 0; i < 100; i++)
    {

        float3 du = getdu(t.x, t.y);
        float3 dv = getdv(t.x, t.y);

        float3 pn = mapP(t.x, t.y);

        float2 b = float2(dot(pos - pn, du), dot(pos - pn, dv));

        float2x2 A = float2x2(dot(du, du), dot(du, dv), dot(dv, du), dot(dv, dv));
        
        float2 c = mul(inverse(A), b);

        float3 qn = pn + c.x * du + c.y * dv;
        float3 pn1 = mapP(t.x + c.x, t.y + c.y);

        float3 f1 = qn - pn;
        float3 f2 = pn1 - qn;

        float a0 = dot(pos - pn, f1);
        float a1 = dot(pos - pn, 2 * f2) - dot(f1, f1);
        float a2 = dot(-3 * f1, f2);
        float a3 = -2 * dot(f2, f2);
        float al = 1 - (a0 + a1 + a2 + a3) / (a1 + 2 * a2 + 3 * a3);

        if (al > 0 && al < 20){
            t.x = t.x + al * c.x;
            t.y = t.y + al * c.y;
        }

    }

    float3 pn = mapP(t.x, t.y);

    return length(pos - pn);

}

float map(float3 pos)
{
#if SHAPE == 0
    return abs(length(pos) - 1);
    return geomNewton(pos);
#endif
#if SHAPE == 1
    return geomNewton(pos);

#endif
    #if SHAPE == 2
    return geomNewton(pos);

#endif
    return 0;
}
