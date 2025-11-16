#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture0;
uniform float progress;
uniform int direction;
uniform float edgeWidth;

varying vec2 fragTexCoord;
varying vec4 fragColor;

void main()
{
    vec4 color = texture2D(texture0, fragTexCoord);
    float alpha = 1.0;
    float t = progress;
    float e = edgeWidth;

    // calculate fade zone alpha
    if (direction == 0) { // right>left
        float d = (1.0 - fragTexCoord.x) - t;
        alpha = smoothstep(0.0, e, d);
    }
    else if (direction == 1) { // left>right
        float d = fragTexCoord.x - t;
        alpha = smoothstep(0.0, e, d);
    }
    else if (direction == 2) { // down>up
        float d = (1.0 - fragTexCoord.y) - t;
        alpha = smoothstep(0.0, e, d);
    }
    else if (direction == 3) { // up>down
        float d = fragTexCoord.y - t;
        alpha = smoothstep(0.0, e, d);
    }

    gl_FragColor = vec4(color.rgb, color.a * alpha) * fragColor;
}
