set_project("pvz-portable")
set_xmakever("3.0.7")

set_policy("build.ccache", true)

option("pvz_debug")
    set_default(false)
    set_showmenu(true)
    set_description("Enable _PVZ_DEBUG macro (cheats, hidden features). Auto-enabled in debug mode.")
option_end()

option("limbo_page")
    set_default(true)
    set_showmenu(true)
    set_description("Enable limbo page to access hidden levels")
option_end()

option("console")
    set_default(false)
    set_showmenu(true)
    set_description("Show console on Windows. Auto-enabled in debug mode.")
option_end()

option("do_fix_bugs")
    set_default(false)
    set_showmenu(true)
    set_description("Community fixes for original game bugs of 1.2.0.1073 GOTY Edition")
option_end()

option("low_memory")
    set_default(false)
    set_showmenu(true)
    set_description("Enable low memory mode")
option_end()

option("downscale_count")
    set_default("1")
    set_showmenu(true)
    set_description("Image downscale count")
option_end()

set_languages("c99", "cxx20")
set_encodings("utf-8")

add_requires("libsdl2[sdlmain=false]", "libsdl2_mixer_x", "zlib", "libjpeg-turbo", "libpng")

target("pvz-portable")
    set_kind("binary")
    add_files(
        "src/*.cpp",
        "src/SexyAppFramework/*.cpp",
        "src/SexyAppFramework/graphics/*.cpp",
        "src/SexyAppFramework/imagelib/*.cpp",
        "src/SexyAppFramework/misc/*.cpp",
        "src/SexyAppFramework/paklib/*.cpp",
        "src/SexyAppFramework/sound/*.cpp",
        "src/SexyAppFramework/widget/*.cpp",
        "src/SexyAppFramework/fcaseopen/*.c",
        "src/Sexy.TodLib/*.cpp",
        "src/Lawn/*.cpp",
        "src/Lawn/Widget/*.cpp",
        "src/Lawn/System/*.cpp"
    )

    -- Excluded files (included by other .cpp, not compiled directly)
    remove_files(
        "src/Sexy.TodLib/TodDrawTriangle.cpp",
        "src/Sexy.TodLib/TodDrawTriangleInc.cpp"
    )

    add_includedirs(
        "src",
        "src/SexyAppFramework",
        "src/SexyAppFramework/sound/SDL-Mixer-X/include"
    )

    add_packages("libsdl2", "libsdl2_mixer_x", "zlib", "libjpeg-turbo", "libpng")

    if has_config("limbo_page")  then add_defines("_PVZ_LIMBO_PAGE") end
    if has_config("do_fix_bugs") then add_defines("DO_FIX_BUGS")     end
    if has_config("low_memory")  then add_defines("LOW_MEMORY")      end
    add_defines("IMG_DOWNSCALE=" .. (get_config("downscale_count") or "1"))

    if is_mode("debug") or has_config("pvz_debug") then
        add_defines("_PVZ_DEBUG")
    end

    add_files(
        "src/SexyAppFramework/platform/pc/Window.cpp",
        "src/SexyAppFramework/platform/pc/Input.cpp"
    )
    add_includedirs("src/SexyAppFramework/platform/pc")

    if is_plat("windows") then
        add_defines("WINDOWS")
        add_syslinks("ws2_32", "user32", "gdi32", "winmm", "imm32", "shlwapi")

        add_files("src/SexyAppFramework/LawnProject.rc")
        add_mrcflags('-DAPP_ICON_PATH="icon.ico"', {force = true})
    elseif is_plat("linux") then
        add_syslinks("m")
    end

package("libsdl2_mixer_x")
    set_sourcedir(path.join(os.scriptdir(), "src/SexyAppFramework/sound/SDL-Mixer-X"))

    add_deps("cmake")
    add_deps("libsdl2", "libopenmpt")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DMIXERX_ENABLE_LGPL=" .. (package:config("lgpl") and "ON" or "OFF"))
        table.insert(configs, "-DMIXERX_ENABLE_GPL=" .. (package:config("gpl") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <SDL2/SDL.h>
            #include <SDL2/SDL_mixer_ext.h>
            int main(int argc, char** argv) {
                Mix_Init(MIX_INIT_OGG);
                Mix_Quit();
                return 0;
            }
        ]]}, {configs = {defines = "SDL_MAIN_HANDLED"}}));
    end)
