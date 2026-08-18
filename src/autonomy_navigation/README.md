# 自主运动与导航模块

这个目录只属于“自主运动与导航控制”部分。其他同学通过 ROS 话题和结果文件与它连接，**不要直接修改本目录的代码**。

当前已实现的是第一阶段安全控制，以及三维激光 + IMU 定位建图接入：

```text
/scan -> cloud_to_scan -> /nav/scan2d --------> safety_guard -> /cmd_vel
                         -> /nav/livox_custom + /livox/imu -> FAST-LIO
                                               ^                 
                                     /nav/cmd_vel_raw ------------
```

- `cloud_to_scan.py`：将 Livox 三维点云投影为平面雷达扫描；不读取 Gazebo 真值里程计。安全控制使用最新一帧 `/nav/scan2d`，建图使用 5 帧稳定后的 `/nav/scan2d_stable`。
- `safety_guard.py`：限制速度；雷达丢失或前方障碍过近时停车。
- `mission_manager.py`：发布当前任务状态。后续的自动探索、门、电梯逻辑统一加在这里。
- `lio_mapping.launch`：启动 FAST-LIO，使用原始三维点云和 Livox IMU 建图定位；发布 `/nav/robot_pose`、`/nav/lio_odom` 和三维点云地图。仿真 `/scan` 是瞬时快照，适配器会将所有点时间置零，禁止把 10 Hz 发布周期伪造成扫描时长。

## 目录说明

```text
autonomy_navigation/
├── config/       参数，调整速度和安全距离时只改这里
├── launch/       启动文件
├── msg/          与感知模块交接的消息定义
├── scripts/      导航节点
└── README.md     对外接口说明
```

## 启动第一阶段

先在仓库根目录编译：

```bash
bash scripts/setup_localization_dependencies.sh
source /opt/ros/noetic/setup.bash
catkin_make -j
source devel/setup.bash
```

启动仿真后，在 `junior_ctrl` 终端输入 `2` 站立、`6` 切换到 `/cmd_vel` 控制模式。然后另开终端：

```bash
source /opt/ros/noetic/setup.bash
source devel/setup.bash
roslaunch autonomy_navigation navigation.launch
```

另开一个终端启动三维建图定位（不要再启动旧的 `mapping.launch`）：

```bash
source /opt/ros/noetic/setup.bash
source devel/setup.bash
roslaunch autonomy_navigation lio_mapping.launch
```

用于测试的命令必须发到 `/nav/cmd_vel_raw`，不能直接发 `/cmd_vel`：

```bash
rostopic pub -r 10 /nav/cmd_vel_raw geometry_msgs/Twist \
  "{linear: {x: 0.15, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.20}}"
```

按 `Ctrl-C` 停止测试命令。安全节点会在 0.30 秒内没有新速度命令、雷达未到达、雷达断流或前方 0.60 m 内有障碍物时输出零速度。因此，正常导航程序必须以至少 10 Hz 向 `/nav/cmd_vel_raw` 持续发布命令。

## 对外接口（给其他同学）

### 导航模块输入

| 接口 | 类型 | 提供者 | 用途 |
|---|---|---|---|
| `/scan` | `sensor_msgs/PointCloud` | 仿真环境 | 原始 Livox 点云 |
| `/trunk_imu` | `sensor_msgs/Imu` | 仿真环境 | 后续定位使用 |
| `/perception/danger_candidate` | `autonomy_navigation/DangerCandidate` | 感知模块 | 疑似危险源 |
| `generated_building/team_scene_info.json` | JSON 文件 | 仿真环境 | 起点、门、电梯公开信息 |

### 导航模块输出

| 接口 | 类型 | 使用者 | 说明 |
|---|---|---|---|
| `/cmd_vel` | `geometry_msgs/Twist` | A1 控制器 | **只有 safety_guard 可以发布** |
| `/nav/scan2d` | `sensor_msgs/LaserScan` | SLAM、导航 | 投影后的二维雷达 |
| `/nav/lio_odom` | `nav_msgs/Odometry` | 导航、感知 | 三维激光 + IMU 的定位结果 |
| `/nav/lio/cloud_registered` | `sensor_msgs/PointCloud2` | RViz、建图验证 | 当前帧在三维地图坐标系下的点云 |
| `/nav/status` | `std_msgs/String` | 全队 | 安全状态，例如 `NAVIGATING`、`SAFETY_STOP` |
| `/nav/mission_status` | `std_msgs/String` | 全队 | 任务阶段，例如 `READY`、`EXPLORING`、`ELEVATOR_RIDE` |
| `/nav/robot_pose` | `geometry_msgs/PoseWithCovarianceStamped` | 感知模块 | 三维定位后的机器人位姿，坐标系为 `nav_lio_map` |
| `/nav/danger_world` | `geometry_msgs/PointStamped` | 结果模块 | 第二阶段：世界坐标危险源 |

`/nav/robot_pose` 在启动 `lio_mapping.launch` 后发布 `nav_lio_map` 坐标系下的定位结果。`/nav/danger_world` 仍然保留，只有完成从 `nav_lio_map` 到 `world` 的公开起点对齐后才会发布。

## 感知模块交接消息

感知同学发现红色球体后，发布 `/perception/danger_candidate`：

```text
std_msgs/Header header
geometry_msgs/Point position
float32 confidence
string target_type
```

约定：

1. `header.stamp` 必须是图像/点云的采集时间，不是处理完成时间。
2. `header.frame_id` 必须写坐标系，通常为 `real_sense` 或 `base`。
3. `position` 是该坐标系下的米制三维坐标。
4. `target_type` 使用 `red_sphere`、`red_box`、`green_sphere` 三者之一。
5. 导航模块完成定位后负责将候选点转换到 `world` 坐标系、去重，并交给结果模块写入 `results/detected_danger.json`。

## 后续开发顺序

1. 接入 `move_base + DWA`，其原始输出必须重映射到 `/nav/cmd_vel_raw`。
2. 添加 `frontier_explorer.py`，自动选择未探索区域。
3. 在 `mission_manager.py` 中加入门、电梯状态机。
4. 对接识别候选点，发布 `/nav/danger_world`，再写最终 JSON。

## 重要规则

- 不读取 `danger_truth.json`、布局真值或 Gazebo world 文件。
- 不让感知、探索、测试脚本直接发布 `/cmd_vel`。
- 所有跨模块位置消息都必须带时间戳和 `frame_id`。
- 当前底层 `junior_ctrl` 和点云转换节点内部仍涉及真值话题；是否允许及如何移除，需要由组长/赛方确认，不能将这些话题作为本模块算法输入。
