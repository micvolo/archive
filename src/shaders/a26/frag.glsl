#define PI 3.1415926535897932384626433832795

varying vec2 vUv;
uniform float uTime;

float square(vec2 uv, float size) {
    float halfSize = size / 2.;
    float left = step(0.5 - halfSize, uv.x);
    float right = step(uv.x, 0.5 + halfSize);

    float top = step(0.5 - halfSize, uv.y);
    float bottom = step(uv.y, 0.5 + halfSize);

    return left * right * top * bottom;
}

vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

float normalSin(float val) {
    return sin(val) * 0.5 + 0.5;
}

void main() {
    vec2 uv = vUv;
    vec3 color = vec3(vUv, 1.0);
    float repeat = normalSin(uTime);

    float dist = distance(vec2(0.5), uv);
    uv.x += mix(sin(dist * 40. - uTime * 8.) * 0.2, 0., repeat);
    uv.y += mix(cos(dist * 40. - uTime * 8.) * 0.2, 0., repeat);
    float squares = square(uv, 0.6 + sin(uTime) * 0.2);
    squares -= square(uv, 0.2 + cos(uTime) * 0.2);

    float paletteOffset = dist - uTime * 0.2;

    vec3 firstPalette = palette(paletteOffset, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(2.0, 1.0, 0.0), vec3(0.5, 0.20, 0.25));
    vec3 secondPalette = palette(paletteOffset * 2., vec3(0.8, 0.5, 0.4), vec3(0.2, 0.4, 0.2), vec3(2.0, 1.0, 1.0), vec3(0.0, 0.25, 0.25));

    color = firstPalette;
    color = secondPalette;
    // color = vec3(squares);
    color = mix(firstPalette, secondPalette, smoothstep(0.4, .6, vUv.x));

    float cornerFade = smoothstep(0.5, .2, dist);
    // color = mix(vec3(0.), color, squares * cornerFade);
    gl_FragColor = vec4(color, 1.0);
}