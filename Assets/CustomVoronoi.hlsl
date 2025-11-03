//This code (based on work by Inigo Quilez) implements a custom Voronoi noise function in HLSL.

#ifndef CUSTOM_VORONOI_INCLUDED
#define CUSTOM_VORONOI_INCLUDED

// 2D Random function
float2 random(float2 p)
{
    return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
}

void CustomVoronoi_float(float2 UV, float AngleOffset, float CellDensity, out float3 CellData, out float2 LocalUV)
{
    float2 p = UV * CellDensity;
    float2 i = floor(p);
    float2 f = frac(p);

    float minDist = 1.0;
    float2 res = 0.0;
    float2 resID = 0.0;

    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            float2 n = float2(x, y);
            float2 id = i + n;
            float2 r = random(id + AngleOffset);
            float2 pos = n + r;
            
            float2 diff = pos - f;
            float dist = dot(diff, diff);

            if (dist < minDist)
            {
                minDist = dist;
                res = diff;
                resID = id;
            }
        }
    }
    
    // CellData:
    // x (R): Distance to center (squared)
    // y (G): Cell ID (x)
    // z (B): Cell ID (y)
    CellData = float3(minDist, resID.x, resID.y);
    
    // LocalUV:
    // This is the vector from the pixel to the cell center.
    // It's our local UV map for the cell, ranging from approx -0.5 to 0.5.
    LocalUV = res;
}

#endif // CUSTOM_VORONOI_INCLUDED