#include <metal_stdlib>
using namespace metal;

// ── Mode constants (must match MetalRenderer.swift) ──────────────────────────
constant uint kModeFullField  = 0;
constant uint kModeSplitQuad  = 1;
constant uint kModeStripeH    = 2;
constant uint kModeStripeV    = 3;
constant uint kModeGrayWedge  = 4;
constant uint kModePatches    = 5;
// kModeMarker = 6 handled CPU-side (black bg + SwiftUI text overlay)

// ── Shared parameter block ────────────────────────────────────────────────────
struct RenderParams {
    float4 color0;       // primary / TL quadrant
    float4 color1;       // secondary / TR quadrant
    float4 color2;       // tertiary / BL quadrant
    float4 color3;       // quaternary / BR quadrant
    uint   mode;
    uint   stripeCount;  // stripes per axis
    uint   wedgeSteps;   // gray-wedge step count
    uint   _pad;         // explicit pad → 80 bytes, 16-byte aligned
};

// ── Vertex ────────────────────────────────────────────────────────────────────
struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertexMain(uint id [[vertex_id]]) {
    // Full-screen quad (2 triangles, 6 vertices, CCW)
    const float2 pos[6] = {
        float2(-1,+1), float2(+1,+1), float2(-1,-1),
        float2(+1,+1), float2(+1,-1), float2(-1,-1)
    };
    const float2 uvs[6] = {
        float2(0,0), float2(1,0), float2(0,1),
        float2(1,0), float2(1,1), float2(0,1)
    };
    VertexOut out;
    out.position = float4(pos[id], 0.0, 1.0);
    out.uv       = uvs[id];
    return out;
}

// ── Fragment ──────────────────────────────────────────────────────────────────
fragment float4 fragmentMain(VertexOut          in [[stage_in]],
                              constant RenderParams &p [[buffer(0)]]) {
    float2 uv = in.uv;

    if (p.mode == kModeFullField) {
        return p.color0;
    }

    if (p.mode == kModeSplitQuad) {
        bool left = uv.x < 0.5;
        bool top  = uv.y < 0.5;
        if ( top &&  left) return p.color0;
        if ( top && !left) return p.color1;
        if (!top &&  left) return p.color2;
        return p.color3;
    }

    if (p.mode == kModeStripeH) {
        uint stripe = uint(floor(uv.y * float(p.stripeCount)));
        return (stripe % 2 == 0) ? p.color0 : p.color1;
    }

    if (p.mode == kModeStripeV) {
        uint stripe = uint(floor(uv.x * float(p.stripeCount)));
        return (stripe % 2 == 0) ? p.color0 : p.color1;
    }

    if (p.mode == kModeGrayWedge) {
        // Rec.709-legal range baked in: black=16/255, white=235/255
        const float legalBlack = 16.0  / 255.0;
        const float legalWhite = 235.0 / 255.0;
        float steps  = float(max(p.wedgeSteps, 2u) - 1);
        float t      = floor(uv.x * float(p.wedgeSteps)) / steps;
        t            = clamp(t, 0.0, 1.0);
        float gray   = legalBlack + t * (legalWhite - legalBlack);
        return float4(gray, gray, gray, 1.0);
    }

    if (p.mode == kModePatches) {
        // 4-column × 2-row grid cycling through color0–color3
        uint col = uint(floor(uv.x * 4.0));
        uint row = uint(floor(uv.y * 2.0));
        uint idx = (row * 4 + col) % 4;
        if (idx == 0) return p.color0;
        if (idx == 1) return p.color1;
        if (idx == 2) return p.color2;
        return p.color3;
    }

    return p.color0; // fallback
}
