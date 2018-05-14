/**
 * a phong shader implementation
 * Created by Samuel Gratzl on 29.02.2016.
 */
attribute vec3 a_position;
attribute vec3 a_normal;

uniform mat4 u_modelView;
uniform mat3 u_normalMatrix;
uniform mat4 u_projection;

//TASK 3-3 light position as uniform
//vec3 lightPos = vec3(0, -2, 2);
uniform vec3 u_lightPos;
//TASK 5-3 second light source
uniform vec3 u_light2Pos;


/**
 * definition of a material structure containing common properties
 */
struct Material {
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	vec4 emission;
	float shininess;
};

/**
 * definition of the light properties related to material properties
 */
struct Light {
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
};

//TASK 2-1 use uniform for material
//Material material = Material(vec4(0.24725, 0.1995, 0.0745, 1.),
//														vec4(0.75164, 0.60648, 0.22648, 1.),
//														vec4(0.628281, 0.555802, 0.366065, 1.),
//														vec4(0., 0., 0., 0.),
//														0.4);
uniform Material u_material;
//TASK 3-1 use uniform for light
//Light light = Light(vec4(0., 0., 0., 1.),
//										vec4(1., 1., 1., 1.),
//										vec4(1., 1., 1., 1.));
uniform Light u_light;
//TASK 5-5 use uniform for 2nd light
uniform Light u_light2;

varying vec4 v_color;

vec4 calculateSimplePointLight(Light light, Material material, vec3 lightVec, vec3 normalVec, vec3 eyeVec) {
	lightVec = normalize(lightVec);
	normalVec = normalize(normalVec);
	eyeVec = normalize(eyeVec);

		//TASK 1-1 implement phong shader
	//compute diffuse term
	float diffuse = max(dot(normalVec,lightVec),0.0);

	//compute specular term
	vec3 reflectVec = reflect(-lightVec,normalVec);
	float spec = pow( max( dot(reflectVec, eyeVec), 0.0) , material.shininess);


	vec4 c_amb  = clamp(light.ambient * material.ambient, 0.0, 1.0);
	vec4 c_diff = clamp(diffuse * light.diffuse * material.diffuse, 0.0, 1.0);
	vec4 c_spec = clamp(spec * light.specular * material.specular, 0.0, 1.0);
	vec4 c_em   = material.emission;

	return c_amb + c_diff + c_spec + c_em;
}

void main() {
	vec4 eyePosition = u_modelView * vec4(a_position,1);

  vec3 normalVec = u_normalMatrix * a_normal;

  vec3 eyeVec = -eyePosition.xyz;
	//TASK 3-4 light position as uniform
	vec3 lightVec = u_lightPos - eyePosition.xyz;
	//TASK 5-4 second light source position
	vec3 light2Vec = u_light2Pos - eyePosition.xyz;

	v_color =
		calculateSimplePointLight(u_light, u_material, lightVec, normalVec, eyeVec)
		+ calculateSimplePointLight(u_light2, u_material, light2Vec, normalVec, eyeVec);

	gl_Position = u_projection * eyePosition;


}
