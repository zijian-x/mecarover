#include "interpolation.hpp"

#include <geometry_msgs/msg/twist.h>
#include <mecarover/mrlogger/mrlogger.h>
#include <rcl/allocator.h>
#include <rcl/node.h>
#include <rclc/executor.h>
#include <rclc/executor_handle.h>
#include <rclc/publisher.h>
#include <rclc/subscription.h>
#include <rclc/timer.h>
#include <rclc/types.h>

#include "rcl_ret_check.hpp"
#include "wheel_vel_msg.hpp"

extern "C" {
// TODO: extract as config
static constexpr uint8_t N_HANDLE = 2;

static rclc_executor_t interpolation_exe;
static rcl_subscription_t sub_odometry;
static rcl_subscription_t sub_cmd_vel;
static geometry_msgs__msg__Twist odometry_msg{};
static geometry_msgs__msg__Twist cmd_vel_msg{};
static rcl_publisher_t pub_wheel_vel;

static void pose_callback(const void* arg) {
  const auto* pose_msg =
      reinterpret_cast<const geometry_msgs__msg__Twist*>(arg);
  log_message(log_debug, "pose_cb pose: [x: %.2f, y: %.2f, theta: %.2f]",
              pose_msg->linear.x, pose_msg->linear.y, pose_msg->angular.z);

  wheel_vel_msg wheel_msg;
  wheel_msg[0] = 1.3;
  wheel_msg[1] = 2.5;
  wheel_msg[2] = 3.7;
  wheel_msg[3] = 7.3;
  rcl_ret_check(rcl_publish(&pub_wheel_vel, &wheel_msg.msg, NULL));
}

rclc_executor_t* interpolation_init(rcl_node_t* node, rclc_support_t* support,
                                    const rcl_allocator_t* allocator) {
  rclc_executor_init(&interpolation_exe, &support->context, N_HANDLE,
                     allocator);

  rclc_subscription_init_default(
      &sub_odometry, node,
      ROSIDL_GET_MSG_TYPE_SUPPORT(geometry_msgs, msg, Twist), "odometry");
  rclc_executor_add_subscription(&interpolation_exe, &sub_odometry,
                                 &odometry_msg, &pose_callback, ON_NEW_DATA);

  rclc_subscription_init_default(
      &sub_cmd_vel, node,
      ROSIDL_GET_MSG_TYPE_SUPPORT(geometry_msgs, msg, Twist), "cmd_vel");
  rclc_executor_add_subscription(&interpolation_exe, &sub_cmd_vel, &cmd_vel_msg,
                                 &pose_callback, ON_NEW_DATA);

  rclc_publisher_init_default(
      &pub_wheel_vel, node,
      ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, Float64MultiArray),
      "wheel_vel");

  return &interpolation_exe;
}
}
