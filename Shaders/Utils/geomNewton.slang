#include "../Compute/paramsurf.slang"

float2 geomNewton(float3 pos, float k)
{
    float2 t;

    t = convertParam(0.5, 0.5);

    float d = 10000;

    for (int i = 0; i <= 20; i++)
    {
        for (int j = 0; j <= 20; j++)
        {

            float2 cc = convertParam(i / 20.f, j / 20.f);
            if (length(mapP(k+cc.x,cc.y) - pos) < d)
            {
                t = cc;
                d = length(mapP(k+cc.x, cc.y) - pos);

            }

        }
    }

    //return t;

    int i = 0;
    bool end = false;
    while (i < 10 && !end)
    {

        float3 du = getdu(k+t.x, t.y);
        float3 dv = getdv(k+t.x, t.y);

        float3 pn = mapP(k+t.x, t.y);

        float2 b = float2(dot(pos - pn, du), dot(pos - pn, dv));

        float4 A = float4(dot(du, du), dot(du, dv), dot(dv, du), dot(dv, dv));
        
        
        
        float X = 1.f / (float) (A.x * A.w - A.y * A.z);
        if (A.x * A.w - A.y * A.z == 0)
        {
            return t;
        }
        float2 c = float2(0);

        c.x = X * (A.w * b.x - A.y * b.y);
        c.y = X * (A.x * b.y - A.y * b.x);

        float3 qn = pn + c.x * du + c.y * dv;
        float3 pn1 = mapP(k+t.x + c.x, t.y + c.y);

      /*  float3 f1 = qn - pn;
        float3 f2 = pn1 - qn;

        float a0 = dot(pos - pn, f1);
        float a1 = dot(pos - pn, 2 * f2) - dot(f1, f1);
        float a2 = dot(-3 * f1, f2);
        float a3 = -2 * dot(f2, f2);

       */
        //float al = 1 - (a0 + a1 + a2 + a3) / (a1 + 2 * a2 + 3 * a3);

        float al = 0.6;
        
       // if ((a1 + 2 * a2 + 3 * a3) == 0)
          //  return 0;
        

        if (al > 0 && al < 20)
        {
            t.x = t.x + al * c.x;
            t.y = t.y + al * c.y;
        }

        float2 limit = 0.99*convertParam(1, 1);

        if (t.x > limit.x)
        {
            t.x = limit.x;
        }

        if (t.y > limit.y)
        {
            t.y = limit.y;
        }

       limit = convertParam(0, 0)+0.01;

        if (t.x < limit.x)
        {
            t.x = limit.x;
        }

        if (t.y < limit.y)
        {
            t.y = limit.y;
        }

        
        i++;
        
        if (length(pn1-pn) < 0.00001)
            end = true;

    }
    return t;

}
