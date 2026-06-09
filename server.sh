#!/bin/bash
# ============================================================================
# 趣知 (QuZhi) 一键启动服务脚本
# ============================================================================
# 用途: 构建 Flutter Web 应用 + 启动所有必要的服务
# 使用: chmod +x server.sh && ./server.sh [start|stop|restart|status|build]
# ============================================================================

set -e

# ==================== 配置区 ====================

# 项目根目录（脚本所在目录）
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Flutter 项目目录
FLUTTER_DIR="$PROJECT_DIR/quzhi-flutter"

# Flutter Web 构建输出目录
FLUTTER_BUILD_DIR="$FLUTTER_DIR/build/web"

# PHP 可执行文件路径（自动检测，也可手动指定）
if command -v php &> /dev/null; then
    PHP_BIN="${PHP_BIN:-$(which php)}"
else
    PHP_BIN="${PHP_BIN:-}"
fi

# ThinkPHP 入口
THINK_CMD="$PROJECT_DIR/think"

# 日志目录
LOG_DIR="$PROJECT_DIR/runtime/logs"
mkdir -p "$LOG_DIR"

# PID 文件目录
PID_DIR="$PROJECT_DIR/runtime/pids"
mkdir -p "$PID_DIR"

# 各服务日志文件
QUEUE_LOG="$LOG_DIR/queue.log"
CRON_WRAPPER_LOG="$LOG_DIR/cron_wrapper.log"
FEED_REWARD_LOG="$LOG_DIR/feed_reward.log"
FLUTTER_WEB_LOG="$LOG_DIR/flutter_web.log"
API_SERVER_LOG="$LOG_DIR/api_server.log"

# 服务端口
WEB_PORT="${WEB_PORT:-8080}"
API_PORT="${API_PORT:-8081}"

# 信息流广告奖励结算间隔（秒）
FEED_REWARD_INTERVAL=5

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==================== 工具函数 ====================

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║            趣知 (QuZhi) 服务管理脚本                     ║"
    echo "║      Flutter Web + ThinkPHP 5.0 + FastAdmin             ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $1"
}

log_step() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ==================== 环境检测 ====================

detect_environment() {
    # 检测 Flutter
    if command -v flutter &> /dev/null; then
        FLUTTER_AVAILABLE=true
        FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1)
        log_info "Flutter: ${FLUTTER_VERSION}"
    else
        FLUTTER_AVAILABLE=false
        log_warn "Flutter CLI: 未安装（将使用已有构建产物）"
    fi

    # 检测 PHP
    if [ -n "$PHP_BIN" ] && $PHP_BIN -v > /dev/null 2>&1; then
        PHP_AVAILABLE=true
        PHP_VERSION=$($PHP_BIN -r "echo PHP_VERSION;" 2>/dev/null)
        log_info "PHP 版本: $PHP_VERSION"
    else
        PHP_AVAILABLE=false
        log_warn "PHP: 未安装（API 后端服务不可用）"
    fi

    # 检测 Python3
    if command -v python3 &> /dev/null; then
        PYTHON3_AVAILABLE=true
        log_info "Python3: $(python3 --version 2>/dev/null)"
    else
        PYTHON3_AVAILABLE=false
    fi

    # 检测 Bun
    if command -v bun &> /dev/null; then
        BUN_AVAILABLE=true
        log_info "Bun: $(bun --version 2>/dev/null)"
    else
        BUN_AVAILABLE=false
    fi
}

check_redis() {
    if [ "$PHP_AVAILABLE" = true ]; then
        if $PHP_BIN -m 2>/dev/null | grep -qi "redis"; then
            log_info "PHP Redis 扩展: 已安装"
        else
            log_warn "PHP Redis 扩展: 未安装（队列功能需要 Redis 扩展）"
        fi
    fi
    if command -v redis-cli &> /dev/null; then
        if redis-cli ping 2>/dev/null | grep -q "PONG"; then
            log_info "Redis 服务: 运行中"
        else
            log_warn "Redis 服务: 未运行或无法连接"
        fi
    else
        log_warn "Redis CLI: 未安装"
    fi
}

check_project() {
    log_info "项目目录: $PROJECT_DIR"
    if [ -d "$FLUTTER_DIR" ]; then
        log_info "Flutter 项目: $FLUTTER_DIR"
    else
        log_warn "Flutter 项目目录不存在: $FLUTTER_DIR"
    fi
    if [ -d "$PROJECT_DIR/application" ]; then
        log_info "ThinkPHP 项目: 已检测到"
    else
        log_warn "ThinkPHP 项目: application 目录不存在"
    fi
    if [ -d "$PROJECT_DIR/runtime" ]; then
        if [ ! -w "$PROJECT_DIR/runtime" ]; then
            log_warn "runtime 目录不可写，尝试修复权限..."
            chmod -R 755 "$PROJECT_DIR/runtime" 2>/dev/null || true
        fi
    fi
}

# ==================== Flutter Web 构建 ====================

build_flutter() {
    log_step "构建 Flutter Web 应用"

    if [ ! -d "$FLUTTER_DIR" ]; then
        log_error "Flutter 项目目录不存在: $FLUTTER_DIR"
        return 1
    fi

    if [ "$FLUTTER_AVAILABLE" = true ]; then
        log_info "使用 Flutter CLI 构建 Web 应用..."
        cd "$FLUTTER_DIR"
        log_info "安装 Flutter 依赖..."
        flutter pub get
        log_info "开始构建 Flutter Web..."
        flutter build web --release

        if [ -d "$FLUTTER_BUILD_DIR" ]; then
            log_info "Flutter Web 构建成功: $FLUTTER_BUILD_DIR"
            log_info "构建产物大小: $(du -sh "$FLUTTER_BUILD_DIR" | cut -f1)"
        else
            log_error "Flutter Web 构建失败: 构建目录不存在"
            return 1
        fi
    else
        if [ -d "$FLUTTER_BUILD_DIR" ] && [ -f "$FLUTTER_BUILD_DIR/index.html" ]; then
            log_info "Flutter CLI 不可用，使用已有构建产物"
            log_info "构建目录: $FLUTTER_BUILD_DIR"
            log_info "构建产物大小: $(du -sh "$FLUTTER_BUILD_DIR" | cut -f1)"
        else
            log_error "Flutter CLI 未安装且无已有构建产物"
            log_error "请安装 Flutter SDK 后运行: $0 build"
            return 1
        fi
    fi
}

# ==================== Flutter Web 静态文件服务 ====================

create_python_server_script() {
    cat > "$FLUTTER_BUILD_DIR/serve.py" << 'PYEOF'
#!/usr/bin/env python3
"""Flutter Web SPA 静态文件服务器，支持 HTML5 History API 路由回退"""
import http.server
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def do_GET(self):
        path = self.path.split('?')[0]
        if os.path.splitext(path)[1]:
            file_path = os.path.join(DIRECTORY, path.lstrip('/'))
            if os.path.isfile(file_path):
                return super().do_GET()
        self.path = '/index.html'
        return super().do_GET()

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization, token')
        if self.path.endswith('.js') or self.path.endswith('.css'):
            self.send_header('Cache-Control', 'public, max-age=86400')
        elif self.path.endswith('.png') or self.path.endswith('.jpg') or self.path.endswith('.svg'):
            self.send_header('Cache-Control', 'public, max-age=604800')
        super().end_headers()

    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    with http.server.HTTPServer(('0.0.0.0', PORT), SPAHandler) as httpd:
        print(f"Flutter Web server running on http://0.0.0.0:{PORT}")
        print(f"Serving directory: {DIRECTORY}")
        httpd.serve_forever()
PYEOF
    chmod +x "$FLUTTER_BUILD_DIR/serve.py"
}

start_flutter_web() {
    local pid_file="$PID_DIR/flutter_web.pid"
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_warn "Flutter Web 服务已在运行 (PID: $(cat "$pid_file"))"
        return
    fi

    if [ ! -d "$FLUTTER_BUILD_DIR" ] || [ ! -f "$FLUTTER_BUILD_DIR/index.html" ]; then
        log_error "Flutter Web 构建产物不存在，请先运行: $0 build"
        return 1
    fi

    log_info "启动 Flutter Web 服务 (端口: $WEB_PORT)..."

    if [ "$PYTHON3_AVAILABLE" = true ]; then
        create_python_server_script
        cd "$FLUTTER_BUILD_DIR"
        nohup python3 "$FLUTTER_BUILD_DIR/serve.py" "$WEB_PORT" > "$FLUTTER_WEB_LOG" 2>&1 &
        echo $! > "$pid_file"
    elif [ "$BUN_AVAILABLE" = true ]; then
        create_bun_server_script
        cd "$FLUTTER_BUILD_DIR"
        nohup bun run "$FLUTTER_BUILD_DIR/serve_bun.js" > "$FLUTTER_WEB_LOG" 2>&1 &
        echo $! > "$pid_file"
    else
        log_error "无法启动 Flutter Web 服务: 需要 python3 或 bun"
        return 1
    fi

    sleep 2
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_info "Flutter Web 服务启动成功 (PID: $(cat "$pid_file"), 端口: $WEB_PORT)"
        log_info "访问地址: http://localhost:$WEB_PORT"
    else
        log_error "Flutter Web 服务启动失败，查看日志: $FLUTTER_WEB_LOG"
        rm -f "$pid_file"
    fi
}

stop_flutter_web() {
    local pid_file="$PID_DIR/flutter_web.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            pkill -P "$pid" 2>/dev/null || true
            kill "$pid" 2>/dev/null
            sleep 1
            kill -9 "$pid" 2>/dev/null || true
            log_info "Flutter Web 服务已停止 (PID: $pid)"
        fi
        rm -f "$pid_file"
    else
        log_info "Flutter Web 服务未运行"
    fi
}

# ==================== PHP API 后端服务 ====================

start_api_server() {
    if [ "$PHP_AVAILABLE" != true ]; then
        log_warn "PHP 不可用，跳过 API 后端服务启动"
        return
    fi

    if [ ! -f "$THINK_CMD" ]; then
        log_warn "ThinkPHP 入口文件不存在: $THINK_CMD，跳过 API 服务"
        return
    fi

    local pid_file="$PID_DIR/api_server.pid"
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_warn "API 后端服务已在运行 (PID: $(cat "$pid_file"))"
        return
    fi

    log_info "启动 API 后端服务 (端口: $API_PORT)..."
    cd "$PROJECT_DIR"
    nohup $PHP_BIN think run -p $API_PORT > "$API_SERVER_LOG" 2>&1 &
    echo $! > "$pid_file"
    sleep 2
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_info "API 后端服务启动成功 (PID: $(cat "$pid_file"), 端口: $API_PORT)"
    else
        log_error "API 后端服务启动失败，查看日志: $API_SERVER_LOG"
        rm -f "$pid_file"
    fi
}

stop_api_server() {
    local pid_file="$PID_DIR/api_server.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
            sleep 1
            kill -9 "$pid" 2>/dev/null || true
            log_info "API 后端服务已停止 (PID: $pid)"
        fi
        rm -f "$pid_file"
    else
        log_info "API 后端服务未运行"
    fi
}

# ==================== 队列监听 ====================

start_queue() {
    if [ "$PHP_AVAILABLE" != true ]; then return; fi
    local pid_file="$PID_DIR/queue.pid"
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_warn "队列监听已在运行 (PID: $(cat "$pid_file"))"
        return
    fi
    log_info "启动队列监听 (Redis Queue)..."
    cd "$PROJECT_DIR"
    nohup $PHP_BIN think queue:listen --daemon > "$QUEUE_LOG" 2>&1 &
    echo $! > "$pid_file"
    sleep 2
    if kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_info "队列监听启动成功 (PID: $(cat "$pid_file"))"
    else
        log_error "队列监听启动失败，查看日志: $QUEUE_LOG"
        rm -f "$pid_file"
    fi
}

stop_queue() {
    local pid_file="$PID_DIR/queue.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null; sleep 1; kill -9 "$pid" 2>/dev/null || true
            log_info "队列监听已停止 (PID: $pid)"
        fi
        rm -f "$pid_file"
    else
        log_info "队列监听未运行"
    fi
}

# ==================== 信息流广告奖励异步结算 ====================

start_feed_reward() {
    if [ "$PHP_AVAILABLE" != true ]; then return; fi
    local pid_file="$PID_DIR/feed_reward.pid"
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_warn "信息流广告奖励结算已在运行"
        return
    fi
    log_info "启动信息流广告奖励异步结算 (每${FEED_REWARD_INTERVAL}秒)..."
    cd "$PROJECT_DIR"
    nohup bash -c "while true; do sleep ${FEED_REWARD_INTERVAL}; cd ${PROJECT_DIR} && ${PHP_BIN} think ad:reward --action=settle_feed --limit=50 >> ${FEED_REWARD_LOG} 2>&1; done" > /dev/null 2>&1 &
    echo $! > "$pid_file"
    sleep 1
    if kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log_info "信息流广告奖励结算启动成功 (间隔: ${FEED_REWARD_INTERVAL}s)"
    else
        log_error "信息流广告奖励结算启动失败"
        rm -f "$pid_file"
    fi
}

stop_feed_reward() {
    local pid_file="$PID_DIR/feed_reward.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            pkill -P "$pid" 2>/dev/null || true
            kill "$pid" 2>/dev/null; sleep 1; kill -9 "$pid" 2>/dev/null || true
            log_info "信息流广告奖励结算已停止 (PID: $pid)"
        fi
        rm -f "$pid_file"
    else
        log_info "信息流广告奖励结算未运行"
    fi
}

# ==================== 定时任务管理 ====================

CRON_TAG="advnet_cron"
CRON_FILE="/tmp/advnet_cron_${USER}.txt"

generate_crontab() {
    cat > "$CRON_FILE" << CRONINNER
# 趣知 (QuZhi) 定时任务
0 0 * * * cd ${PROJECT_DIR} && ${PHP_BIN} think invite:commission --action=daily >> ${LOG_DIR}/cron_daily.log 2>&1
0 0 * * 1 cd ${PROJECT_DIR} && ${PHP_BIN} think invite:commission --action=weekly >> ${LOG_DIR}/cron_weekly.log 2>&1
0 0 1 * * cd ${PROJECT_DIR} && ${PHP_BIN} think invite:commission --action=monthly >> ${LOG_DIR}/cron_monthly.log 2>&1
0 2 * * * cd ${PROJECT_DIR} && ${PHP_BIN} think invite:commission --action=summary >> ${LOG_DIR}/cron_summary.log 2>&1
*/30 * * * * cd ${PROJECT_DIR} && ${PHP_BIN} think ad:settle --action=settle --limit=500 >> ${LOG_DIR}/cron_ad_settle.log 2>&1
0 * * * * cd ${PROJECT_DIR} && ${PHP_BIN} think ad:settle --action=expire >> ${LOG_DIR}/cron_ad_expire.log 2>&1
CRONINNER
}

install_crontab() {
    if [ "$PHP_AVAILABLE" != true ]; then return; fi
    log_info "配置定时任务..."
    crontab -l 2>/dev/null | grep -v "think invite:commission" | grep -v "think ad:settle" > /tmp/cron_backup_${USER}.txt 2>/dev/null || true
    generate_crontab
    if [ -s /tmp/cron_backup_${USER}.txt ]; then
        cat /tmp/cron_backup_${USER}.txt "$CRON_FILE" | crontab -
    else
        crontab "$CRON_FILE"
    fi
    rm -f /tmp/cron_backup_${USER}.txt
    log_info "定时任务配置完成"
}

uninstall_crontab() {
    log_info "移除定时任务..."
    crontab -l 2>/dev/null | grep -v "think invite:commission" | grep -v "think ad:settle" | crontab - 2>/dev/null || true
    rm -f "$CRON_FILE"
    log_info "定时任务已移除"
}

# ==================== 目录权限 ====================

fix_permissions() {
    log_info "修复目录权限..."
    chmod -R 755 "$PROJECT_DIR/runtime" 2>/dev/null || true
    if [ -d "$PROJECT_DIR/public/uploads" ]; then
        chmod -R 755 "$PROJECT_DIR/public/uploads" 2>/dev/null || true
    fi
    log_info "目录权限修复完成"
}

# ==================== 主命令 ====================

do_build() {
    print_banner
    log_step "构建 Flutter Web 应用"
    detect_environment
    build_flutter
    echo ""
    log_info "========== 构建完成 =========="
    echo ""
    echo -e "${GREEN}构建产物:${NC}  $FLUTTER_BUILD_DIR"
    echo -e "${GREEN}启动服务:${NC}  $0 start"
    echo ""
}

do_start() {
    print_banner

    log_step "1. 环境检测"
    detect_environment
    check_project
    check_redis

    log_step "2. 修复目录权限"
    fix_permissions

    log_step "3. 构建 / 检查 Flutter Web"
    build_flutter

    log_step "4. 启动服务"

    # 1. 启动 Flutter Web 服务
    start_flutter_web

    # 2. 启动 API 后端服务
    start_api_server

    # 3. 启动队列监听
    start_queue

    # 4. 启动信息流广告奖励异步结算
    start_feed_reward

    # 5. 安装定时任务
    install_crontab

    echo ""
    log_info "========== 服务启动完成 =========="
    echo ""

    local flutter_pid_file="$PID_DIR/flutter_web.pid"
    if [ -f "$flutter_pid_file" ] && kill -0 "$(cat "$flutter_pid_file")" 2>/dev/null; then
        echo -e "  ${GREEN}●${NC} Flutter Web:    http://localhost:$WEB_PORT"
    else
        echo -e "  ${RED}●${NC} Flutter Web:    未启动"
    fi

    if [ "$PHP_AVAILABLE" = true ]; then
        local api_pid_file="$PID_DIR/api_server.pid"
        if [ -f "$api_pid_file" ] && kill -0 "$(cat "$api_pid_file")" 2>/dev/null; then
            echo -e "  ${GREEN}●${NC} API 后端:      http://localhost:$API_PORT/api"
            echo -e "  ${GREEN}●${NC} 后台管理:      http://localhost:$API_PORT/admin"
        else
            echo -e "  ${RED}●${NC} API 后端:      未启动"
        fi
    else
        echo -e "  ${YELLOW}●${NC} API 后端:      PHP 不可用，已跳过"
    fi

    echo ""
}

do_stop() {
    print_banner
    echo ""
    log_info "========== 停止所有服务 =========="
    stop_flutter_web
    stop_api_server
    stop_queue
    stop_feed_reward
    uninstall_crontab
    echo ""
    log_info "========== 所有服务已停止 =========="
}

do_restart() {
    do_stop
    sleep 2
    do_start
}

do_status() {
    print_banner
    echo ""

    local flutter_pid_file="$PID_DIR/flutter_web.pid"
    if [ -f "$flutter_pid_file" ] && kill -0 "$(cat "$flutter_pid_file")" 2>/dev/null; then
        echo -e "  Flutter Web:     ${GREEN}运行中${NC} (PID: $(cat "$flutter_pid_file"), 端口: $WEB_PORT)"
    else
        echo -e "  Flutter Web:     ${RED}未运行${NC}"
    fi

    local api_pid_file="$PID_DIR/api_server.pid"
    if [ -f "$api_pid_file" ] && kill -0 "$(cat "$api_pid_file")" 2>/dev/null; then
        echo -e "  API 后端:        ${GREEN}运行中${NC} (PID: $(cat "$api_pid_file"), 端口: $API_PORT)"
    else
        echo -e "  API 后端:        ${RED}未运行${NC}"
    fi

    local queue_pid_file="$PID_DIR/queue.pid"
    if [ -f "$queue_pid_file" ] && kill -0 "$(cat "$queue_pid_file")" 2>/dev/null; then
        echo -e "  队列监听:        ${GREEN}运行中${NC} (PID: $(cat "$queue_pid_file"))"
    else
        echo -e "  队列监听:        ${RED}未运行${NC}"
    fi

    echo ""
}

show_help() {
    print_banner
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  start     构建 Flutter Web + 启动所有服务"
    echo "  stop      停止所有服务"
    echo "  restart   重启所有服务"
    echo "  status    查看所有服务状态"
    echo "  build     仅构建 Flutter Web（不启动服务）"
    echo "  help      显示帮助信息"
    echo ""
    echo "环境变量:"
    echo "  WEB_PORT   Flutter Web 服务端口 (默认: 8080)"
    echo "  API_PORT   API 后端服务端口 (默认: 8081)"
    echo "  PHP_BIN    PHP 可执行文件路径 (默认: 自动检测)"
    echo ""
}

# ==================== 入口 ====================

case "${1:-help}" in
    start)   do_start ;;
    stop)    do_stop ;;
    restart) do_restart ;;
    status)  do_status ;;
    build)   do_build ;;
    help|--help|-h) show_help ;;
    *)       log_error "未知命令: $1"; show_help; exit 1 ;;
esac
