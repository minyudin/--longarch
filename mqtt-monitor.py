"""
╔══════════════════════════════════════════════════════════════════╗
║   MQTT 实时监控脚本 - 检测硬件数据是否到达 Broker                ║
╚══════════════════════════════════════════════════════════════════╝

用法:
  python mqtt-monitor.py              # 默认监听所有 device topic
  python mqtt-monitor.py --telemetry  # 只看传感器数据
  python mqtt-monitor.py --stats 10   # 每10秒打印一次统计

输出示例:
  [13:56:23] ✓ telemetry | SEN-ENV-DM01 | {"temperature":27.3,"humidity":74.1,"light":18500,"CO2":435}
  [13:56:23] ✓ telemetry | SEN-NPK-DM01 | {"N":3.5,"P":2.1,"K":5.8}

依赖:
  pip install paho-mqtt
"""
import sys
import json
import time
import threading
from collections import defaultdict, deque
from datetime import datetime
import paho.mqtt.client as mqtt

# ── 连接配置 ──────────────────────────────────────────
BROKER = "localhost"
PORT = 1883
USERNAME = "longarch"
PASSWORD = "longarch123"

# ── 订阅模式 ──────────────────────────────────────────
TOPICS = {
    "telemetry": "longarch/device/telemetry/#",
    "heartbeat": "longarch/device/heartbeat/#",
    "callback":  "longarch/device/callback/#",
    "command":   "longarch/device/command/#",
}

# ── ANSI 颜色 ────────────────────────────────────────
class C:
    GREEN  = "\033[92m"
    YELLOW = "\033[93m"
    CYAN   = "\033[96m"
    MAGENTA= "\033[95m"
    RED    = "\033[91m"
    GRAY   = "\033[90m"
    BOLD   = "\033[1m"
    RESET  = "\033[0m"

TOPIC_COLOR = {
    "telemetry": C.GREEN,
    "heartbeat": C.YELLOW,
    "callback":  C.CYAN,
    "command":   C.MAGENTA,
}

# ── 统计数据 ──────────────────────────────────────────
stats_lock = threading.Lock()
total_count = 0
device_count = defaultdict(int)          # deviceNo -> count
type_count = defaultdict(int)            # topic分类 -> count
last_seen = {}                           # deviceNo -> timestamp
recent_messages = deque(maxlen=50)       # 最近50条消息


def classify_topic(topic: str) -> str:
    """从 topic 里提取分类（telemetry/heartbeat/callback/command）"""
    parts = topic.split("/")
    if len(parts) >= 3:
        return parts[2]
    return "unknown"


def extract_device_no(topic: str) -> str:
    """从 topic 末段提取 deviceNo"""
    return topic.rsplit("/", 1)[-1] if "/" in topic else topic


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"{C.GREEN}{C.BOLD}[连接成功]{C.RESET} MQTT Broker {BROKER}:{PORT}")
        subscribe_list = userdata.get("topics", list(TOPICS.values()))
        for t in subscribe_list:
            client.subscribe(t, qos=1)
            print(f"  {C.GRAY}订阅 →{C.RESET} {t}")
        print(f"\n{C.BOLD}时间戳       | 类型       | 设备编号              | Payload{C.RESET}")
        print("─" * 100)
    else:
        print(f"{C.RED}[连接失败] rc={rc}{C.RESET}")


def on_message(client, userdata, msg):
    global total_count
    ts = datetime.now().strftime("%H:%M:%S")
    topic = msg.topic
    topic_type = classify_topic(topic)
    device_no = extract_device_no(topic)
    color = TOPIC_COLOR.get(topic_type, C.GRAY)

    try:
        payload_str = msg.payload.decode("utf-8")
        payload_obj = json.loads(payload_str)
        payload_preview = json.dumps(payload_obj, ensure_ascii=False, separators=(",", ":"))
        status_icon = f"{C.GREEN}✓{C.RESET}"
    except Exception as e:
        payload_preview = msg.payload.decode("utf-8", errors="replace")
        status_icon = f"{C.RED}✗ JSON解析失败: {e}{C.RESET}"

    # 截断过长的payload显示
    if len(payload_preview) > 80:
        payload_preview = payload_preview[:77] + "..."

    print(f"{C.GRAY}[{ts}]{C.RESET} {status_icon} "
          f"{color}{topic_type:<9}{C.RESET} | "
          f"{C.BOLD}{device_no:<21}{C.RESET} | {payload_preview}")

    with stats_lock:
        total_count += 1
        device_count[device_no] += 1
        type_count[topic_type] += 1
        last_seen[device_no] = time.time()
        recent_messages.append((ts, topic_type, device_no, payload_preview))


def print_stats():
    """定期打印统计信息"""
    with stats_lock:
        if total_count == 0:
            return
        print(f"\n{C.BOLD}{C.CYAN}━━━━━ 统计汇总 ━━━━━{C.RESET}")
        print(f"总消息数: {C.BOLD}{total_count}{C.RESET}")
        print(f"按类型: ", end="")
        for t, cnt in sorted(type_count.items()):
            col = TOPIC_COLOR.get(t, C.GRAY)
            print(f"{col}{t}={cnt}{C.RESET}  ", end="")
        print()
        print(f"活跃设备 ({len(device_count)} 个):")
        sorted_devs = sorted(device_count.items(), key=lambda x: -x[1])
        for dev, cnt in sorted_devs[:15]:
            last_ago = int(time.time() - last_seen[dev])
            fresh = f"{C.GREEN}{last_ago}s前{C.RESET}" if last_ago < 60 else f"{C.YELLOW}{last_ago}s前{C.RESET}"
            print(f"  {dev:<25} {cnt:>4} 条  (最后: {fresh})")
        if len(sorted_devs) > 15:
            print(f"  ... 还有 {len(sorted_devs) - 15} 个设备")
        print(f"{C.CYAN}━━━━━━━━━━━━━━━━━━━━{C.RESET}\n")


def stats_thread(interval: int):
    """后台统计线程"""
    while True:
        time.sleep(interval)
        print_stats()


def main():
    # ── 解析命令行参数 ────────────────────────────────
    args = sys.argv[1:]
    topics_to_sub = list(TOPICS.values())

    if "--telemetry" in args:
        topics_to_sub = [TOPICS["telemetry"]]
    elif "--heartbeat" in args:
        topics_to_sub = [TOPICS["heartbeat"]]

    stats_interval = 0
    for i, a in enumerate(args):
        if a == "--stats" and i + 1 < len(args):
            try:
                stats_interval = int(args[i + 1])
            except ValueError:
                pass

    # ── 启动 MQTT 客户端 ──────────────────────────────
    print(f"{C.BOLD}╔══════════════════════════════════════════════════════════════════╗{C.RESET}")
    print(f"{C.BOLD}║   MQTT 实时监控  -  Ctrl+C 退出                                  ║{C.RESET}")
    print(f"{C.BOLD}╚══════════════════════════════════════════════════════════════════╝{C.RESET}")
    print(f"Broker : {BROKER}:{PORT}")
    print(f"User   : {USERNAME}")
    if stats_interval > 0:
        print(f"Stats  : 每 {stats_interval} 秒打印汇总")
    print()

    client = mqtt.Client(userdata={"topics": topics_to_sub})
    client.username_pw_set(USERNAME, PASSWORD)
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        client.connect(BROKER, PORT, keepalive=60)
    except Exception as e:
        print(f"{C.RED}无法连接到 {BROKER}:{PORT} — {e}{C.RESET}")
        print(f"{C.YELLOW}确认 Mosquitto 已启动，账号密码正确。{C.RESET}")
        sys.exit(1)

    # 后台统计线程
    if stats_interval > 0:
        t = threading.Thread(target=stats_thread, args=(stats_interval,), daemon=True)
        t.start()

    try:
        client.loop_forever()
    except KeyboardInterrupt:
        print(f"\n{C.YELLOW}[退出]{C.RESET} 最终统计:")
        print_stats()
        client.disconnect()


if __name__ == "__main__":
    main()
