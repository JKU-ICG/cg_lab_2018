/**
 * a phong shader implementation
 * Created by Samuel Gratzl on 29.02.2016.
 */
precision mediump float;

varying vec4 v_color;

void main() {
	gl_FragColor = v_color;

}
