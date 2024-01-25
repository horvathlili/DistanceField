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
    float2 t;

    t = convertParam(0.5, 0.5);

    //now only works for 1 surface (for multiple all patches have to be handled separately)
    #if SHAPE == 1
    float db = 0;
    float minp = 100000;
    
        for (int i = 0; i <= nm[0].x; i++)
        {
            for (int j = 0; j <= nm[0].y; j++)
            {
                if (length(bij(i, j, db, 0) - pos) < minp)
                {
                    minp = length(bij(i, j, db, 0) - pos);
                    t = float2(i / nm[0].x, j / nm[0].y);

                }

            }
        }
        //db += (nm[l].x + 1) * (nm[l].y + 1);

    
#endif

    int i = 0;
    bool end = false;
    while(i  < 100 && !end )
    {

        float3 du = getdu(t.x, t.y);
        float3 dv = getdv(t.x, t.y);

        float3 pn = mapP(t.x, t.y);

        float2 b = float2(dot(pos - pn, du), dot(pos - pn, dv));

        float4 A = float4(dot(du, du), dot(du, dv), dot(dv, du), dot(dv, dv));
        
        if (A.x * A.w - A.y * A.z == 0)
        {
            return 0;
        }
        
        float X = 1.f / (float) (A.x * A.w - A.y * A.z);

        float2 c = float2(0);

        c.x = X * (A.w * b.x - A.y * b.y);
        c.y = X * (A.x * b.y - A.y * b.x);

        float3 qn = pn + c.x * du + c.y * dv;
        float3 pn1 = mapP(t.x + c.x, t.y + c.y);

        float3 f1 = qn - pn;
        float3 f2 = pn1 - qn;

        float a0 = dot(pos - pn, f1);
        float a1 = dot(pos - pn, 2 * f2) - dot(f1, f1);
        float a2 = dot(-3 * f1, f2);
        float a3 = -2 * dot(f2, f2);

        if ((a1 + 2 * a2 + 3 * a3) == 0)
            return 0;
        
        float al = 1 - (a0 + a1 + a2 + a3) / (a1 + 2 * a2 + 3 * a3);

        if (al > 0 && al < 20){
            t.x = t.x + al * c.x;
            t.y = t.y + al * c.y;
        }

        i++;

    }

    float3 pn = mapP(t.x, t.y);

    return length(pos - pn);

}

float map(float3 pos)
{
#if SHAPE == 0
    //return abs(length(pos) - 1);
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
