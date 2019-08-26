Shaders.grayscale = love.graphics.newShader[[
  extern float factor;

  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );
	float brightness = (0.2126*pixel.r + 0.7152*pixel.g + 0.0722*pixel.b);
    
	pixel.r = pixel.r*(1-factor) + brightness*factor;
	pixel.g = pixel.g*(1-factor) + brightness*factor;
	pixel.b = pixel.b*(1-factor) + brightness*factor;
	
    return pixel;
  }
]]