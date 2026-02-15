#ifndef __GLPLATFORM_H__
#define __GLPLATFORM_H__

#include <SDL_opengles2.h>

// GLSL ES 1.00 preamble — matches the ES 2.0 context
// Uses: attribute, varying, gl_FragColor, texture2D
#define GLSL_VERT_PREAMBLE \
	"#version 100\n" \
	"precision mediump float;\n" \
	"#define VERT_IN attribute\n" \
	"#define V2F varying\n"

#define GLSL_FRAG_PREAMBLE \
	"#version 100\n" \
	"precision mediump float;\n" \
	"#define V2F varying\n" \
	"#define FRAG_OUT gl_FragColor\n" \
	"#define TEX2D texture2D\n"

inline void PlatformGLInit()
{
	// SDL loads all GLES2 functions automatically when an ES context is created.
}

#endif // __GLPLATFORM_H__
