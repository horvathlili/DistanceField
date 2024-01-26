#include "../Compute/paramsurf.slang"

float2 geomNewton(float3 pos)
{
    float2 t;

    t = convertParam(0.5, 0.5);

    float d = 10000;

    for (int i = 0; i <= 20; i++)
    {
        for (int j = 0; j <= 20; j++)
        {

            float2 cc = convertParam(i / 20.f, j / 20.f);
            if (length(mapP(cc.x,cc.y) - pos) < d)
            {
                t = cc;
                d = length(mapP(cc.x, cc.y) - pos);

            }

        }
    }

    //now only works for 1 surface (for multiple all patches have to be handled separately)

        int i = 0;
    bool end = false;
    while (i < 100 && !end)
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

        if (al > 0 && al < 20)
        {
            t.x = t.x + al * c.x;
            t.y = t.y + al * c.y;
        }

        i++;

    }
    return t;

}
