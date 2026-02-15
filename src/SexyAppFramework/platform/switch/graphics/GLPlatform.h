#ifndef __GLPLATFORM_H__
#define __GLPLATFORM_H__

#include <switch.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES2/gl2.h>

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
}

#endif // __GLPLATFORM_H__
