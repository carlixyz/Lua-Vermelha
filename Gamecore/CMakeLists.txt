cmake_minimum_required(VERSION 3.1)

project(LuaVermelha)

set(CMAKE_CXX_STANDARD 20)

include_directories(${CMAKE_SOURCE_DIR}/include/raylib)
include_directories(${CMAKE_SOURCE_DIR}/include/lua)

file(GLOB_RECURSE SOURCES
   source/*.h
   source/*.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES} )

if (MSVC)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /STACK:8388608 /NODEFAULTLIB:MSVCRT")
    #add_definitions(-DYAML_CPP_STATIC_DEFINE)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/lib/raylib.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/lib/lua-static.lib)
    target_link_libraries(${PROJECT_NAME} PRIVATE winmm)
    target_compile_options(${PROJECT_NAME} PRIVATE /wd4251 /wd4275)
    #target_link_options


    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/data/"
        "$<TARGET_FILE_DIR:${PROJECT_NAME}>/data/"
)
endif()

if(EMSCRIPTEN)

    target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/lib/libraylib.a)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/lib/liblua.a)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")

    add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/data/"
        "${CMAKE_BINARY_DIR}/data/"
)

    set(LINK_OPTS
      "-s USE_GLFW=3"
      "-s ASYNCIFY"
      "-s TOTAL_MEMORY=67108864"
      "-s ALLOW_MEMORY_GROWTH=1"
      "-s FORCE_FILESYSTEM=1"
      "-s WASM=1"
      "--preload-file data"
      "--preload-file data/NotoSansJP-Regular.ttf@/NotoSansJP-Regular.ttf"
      "-s EXPORTED_FUNCTIONS=['_main']"
      "-s EXPORTED_RUNTIME_METHODS=['ccall','cwrap','HEAPF32']"
      "--shell-file minshell.html"
      #"--shell-file shell.html"
      "-DPLATFORM_WEB"
    )

    string (REPLACE ";" " " LINK_OPTS_STR "${LINK_OPTS}")

    set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "${LINK_OPTS_STR}")
endif()

    # DO A Ctrl + Shift + B
    add_custom_target(run_bat ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Running build_webapp.bat..."
        COMMAND cmd.exe /C ${CMAKE_SOURCE_DIR}/build_output.bat
        COMMAND ${CMAKE_COMMAND} -E echo "Running build_HTML.bat..."
        COMMAND cmd.exe /C ${CMAKE_SOURCE_DIR}/build_HTML.bat
       # COMMAND cmd.exe /C ${CMAKE_SOURCE_DIR}/run_HTML.bat
    )
# This could work better if We change the way Emscripten gets enabled

