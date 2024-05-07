
if(NOT "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitinfo.txt" IS_NEWER_THAN "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git"  clone --no-checkout "https://github.com/gabime/spdlog.git" "spdlog"
    WORKING_DIRECTORY "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/gabime/spdlog.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  checkout v1.9.2 --
  WORKING_DIRECTORY "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'v1.9.2'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitinfo.txt"
    "/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/fabian/Schreibtisch/Workspace/ros2/agent/build/micro_ros_agent/agent/src/xrceagent-build/spdlog/src/spdlog-stamp/spdlog-gitclone-lastrun.txt'")
endif()

