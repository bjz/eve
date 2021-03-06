
-- Build dependency lists
local build_deps = function(deps, suffix)
  local d = {}
  for i,v in ipairs(deps) do
    d[i] = v..suffix
  end
  return d
end

local deps = {"gtest", "gtest_main", "glew", "libpng16", "zlib"}

solution "eve"
  language "C++"
  configurations {"Debug", "Optimized", "Release"}
  platforms {"x32", "x64"}
  location "build"
  flags {"StaticRuntime"}

  configuration "gmake"
    buildoptions "-std=c++11"
    flags "ExtraWarnings"

  configuration "x32"
    defines {"EVE_32"}

  configuration "x64"
    defines {"EVE_64"}

  configuration "linux"
    defines { "EVE_LINUX" }

  configuration "windows"
    defines { "EVE_WINDOWS" }
    links { "winmm", "shlwapi", "opengl32", "ws2_32", "Dbghelp.lib"}
  
  configuration {"windows", "x32"}
    libdirs {"extern/lib/win32", "lib/win32"}
    targetdir "lib/win32"
  configuration {"windows", "x64"}
    libdirs {"extern/lib/win64", "lib/win64"}
    targetdir "lib/win64"
  configuration {"linux", "x32"}
    libdirs {"extern/lib/linux32", "lib/linux32"}
    targetdir "lib/linux32"
  configuration {"linux", "x64"}
    libdirs {"extern/lib/linux64", "lib/linux64"}
    targetdir "lib/linux64"

  configuration "Debug"
    flags { "Symbols" }
    defines { "EVE_DEBUG" }

  configuration "Optimized"
    flags { "Symbols", "OptimizeSpeed" }
    defines { "EVE_OPTIMIZED" }
  
  configuration "Release"
    flags { "OptimizeSpeed" }
    defines { "EVE_RELEASE" }

  -- libraries
  project "eve"
    kind "StaticLib"
    includedirs { "include", "src", "extern/include" }
    files { "include/eve/**.h", "include/eve/**.inl", "src/**.h", "src/**.inl", "src/**.cpp" }
    configuration {"Debug"}
      targetname "eved"
    configuration {"Optimized"}
      targetname "eveo"
    configuration {"Release"}
      targetname "eve"

  -- tests
  project "tests"
    kind "ConsoleApp"
    includedirs { "include", "extern/include" }
    files { "tests/**.cpp" }
	  debugdir "tests"

    configuration "vs*"
      defines { "_VARIADIC_MAX=10" }

    configuration "Debug"
      links (build_deps(deps, "d"))
    configuration "not Debug"
      links (build_deps(deps, ""))

    configuration "Debug"
      targetname "testsd"
      links {"eved"}
    configuration "Optimized"
      targetname "testso"
      links {"eveo"}
    configuration "Release"
      targetname "tests"
      links {"eve"}
