#define PI 3.1415926535897932384626433832795
#define AA 1

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

vec2 iterate(in vec2 p, in vec4 t) {
    return p - 0.05 * cos(t.xz + p.x * p.y + cos(t.yw + 1.5 * 3.1415927 * p.yx) + p.yx * p.yx);
}

void main() {
    vec2 fragCoord = gl_FragCoord.xy;

    float time = uTime * 6.283185 / 60.0;
    vec4 t = time * vec4(1.0, -1.0, 1.0, -1.0) + vec4(0.0, 2.0, 3.0, 1.0);
    vec3 tot = vec3(0.0);
    tot /= float(AA * AA);

    #if AA>1
    for(int m = 0; m < AA; m++) for(int n = 0; n < AA; n++) {
        // pixel coordinates
            vec2 o = vec2(float(m), float(n)) / float(AA) - 0.5;
            vec2 p = (-uResolution.xy + 2.0 * (fragCoord + o)) / uResolution.y;
        #else    
            vec2 p = (-uResolution.xy + 2.0 * fragCoord) / uResolution.y;
        #endif

            p *= .8;

            vec2 z = p;
            vec3 s = vec3(0.0);
            for(int i = 0; i < 100; i++) {
                z = iterate(z, t);

                float d = dot(z - p, z - p);
                s.x += 1.0 / (0.1 + d);
                s.y += sin(atan(p.x - z.x, p.y - z.y));
                s.z += exp(-0.2 * d);
            }
            s /= 100.0;

            vec3 col = 0.5 + 0.5 * cos(vec3(0.0, 0.4, 0.8) + 2.5 + s.z * 6.2831);

            col *= 0.5 + 0.5 * s.y;
            col *= s.x;
            col *= 0.94 + 0.06 * sin(10.0 * length(z));

            // vec3 nor = normalize(vec3(dFdx(s.x), 0.02, dFdy(s.x)));
            // float dif = dot(nor, vec3(0.7, 0.1, 0.7));
            // col -= 0.05 * vec3(dif);
            // col *= 3.2 / (3.0 + col);
            tot += col;
    #if AA>1
        }
    tot /= float(AA * AA);
    #endif

    vec2 q = fragCoord / uResolution.xy;
    q = vUv;
    // tot *= 0.3 + 0.7 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.2);
    gl_FragColor = vec4(tot, 1.0);
}