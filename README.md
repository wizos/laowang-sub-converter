# LaoWang Sub Converter

一个可私有化部署的订阅转换和节点整理工具。前端提供控制台 UI，后端提供转换、合并、健康检测、短链接和目标客户端导出 API。

## 功能

- 订阅转换：把订阅地址转换成 Clash、Mihomo、Surge、Loon、Quantumult X、Shadowrocket、V2RayN、sing-box 等客户端格式。
- 订阅合并：批量拉取多个订阅，支持去重、排序、地区标识、关键词过滤和重命名。
- 节点检测：从服务器侧检测节点 TCP 连通性，导出在线节点。
- 短链接：把长订阅地址生成固定短码，支持访问统计和删除。
- 二维码：转换结果可生成订阅二维码，分享链接目标可生成单节点二维码。
- Docker 部署：提供 GHCR 多架构镜像和服务器一键脚本。

## 支持范围

输入协议：

```text
SS, SSR, VMess, VLESS, VLESS Reality, Trojan, Hysteria, Hysteria2,
TUIC, Snell, AnyTLS, HTTP, SOCKS5, Clash/Mihomo YAML, sing-box JSON
```

输出目标：

```text
Clash, Clash Meta, Mihomo, Stash, Clash Verge, FlClash,
Surge, Surfboard, Loon, Quantumult X, Shadowrocket,
V2RayN, V2RayNG, V2RayU, NekoBox, Hiddify, sing-box, SFA, SFI, SFM
```

注意：不同客户端原生支持的协议不同。转换器会尽量只输出目标客户端可识别的节点；如果没有可输出节点，接口会返回 `422`。

## 服务器一键部署

推荐在 Ubuntu、Debian、CentOS 等 Linux 服务器上执行：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo bash
```

默认参数：

```text
镜像：ghcr.io/tony-wang1990/laowang-sub-converter:latest
安装目录：/opt/laowang-sub-converter
数据目录：/opt/laowang-sub-converter/data
访问端口：3000
访问地址：http://服务器IP:3000
```

指定端口：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo env PORT=8080 bash
```

更新到最新镜像：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo bash -s update
```

查看状态：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo bash -s status
```

查看日志：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo bash -s logs
```

卸载容器，保留数据目录：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo bash -s uninstall
```

如果需要允许服务端拉取本机或内网订阅地址：

```bash
curl -fsSL https://raw.githubusercontent.com/tony-wang1990/laowang-sub-converter/main/scripts/deploy.sh | sudo env ALLOW_PRIVATE_SUBSCRIPTION_URLS=1 bash
```

## 手动 Docker 部署

```bash
docker run -d \
  --name laowang-sub-converter \
  -p 3000:3000 \
  -e DATA_DIR=/app/data \
  -v /opt/laowang-sub-converter/data:/app/data \
  --restart unless-stopped \
  ghcr.io/tony-wang1990/laowang-sub-converter:latest
```

Docker Compose：

```yaml
services:
  laowang-sub-converter:
    image: ghcr.io/tony-wang1990/laowang-sub-converter:latest
    container_name: laowang-sub-converter
    environment:
      NODE_ENV: production
      PORT: 3000
      DATA_DIR: /app/data
    ports:
      - "3000:3000"
    volumes:
      - ./data:/app/data
    restart: unless-stopped
```

## 环境变量

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `PORT` | `3000` | 服务监听端口 |
| `DATA_DIR` | `./data` 或 `/app/data` | 短链接数据目录 |
| `ALLOW_PRIVATE_SUBSCRIPTION_URLS` | `0` | 是否允许后端拉取 localhost、内网 IP、`.local` 等私有订阅地址 |

默认禁止私有地址是为了降低公开部署时的 SSRF 风险。仅在自用内网部署并明确需要时开启。

## 本地开发

要求 Node.js `>=20.19.0`。

```bash
npm install
npm run dev
```

单独启动后端：

```bash
npm run server
```

生产构建：

```bash
npm run build
npm run server
```

## API

订阅转换：

```http
GET /api/convert?target=clashmeta&url=https%3A%2F%2Fexample.com%2Fsub
```

常用参数：

| 参数 | 说明 |
| --- | --- |
| `target` | 目标客户端，如 `mihomo`、`singbox`、`surge`、`v2rayn` |
| `url` | 订阅地址，需要 URL 编码 |
| `emoji` | 是否追加地区标识，`1` 或 `0` |
| `udp` | 是否启用 UDP，`1` 或 `0` |
| `scert` | 是否跳过证书校验，`1` 或 `0` |
| `sort` | 是否按名称排序，`1` 或 `0` |
| `include` | 仅保留包含关键词的节点，多个关键词用 `|` 分隔 |
| `exclude` | 排除包含关键词的节点，多个关键词用 `|` 分隔 |
| `rename` | 重命名规则，如 `old->new` |
| `rulePreset` | 分流模板：`standard`、`developer`、`gaming`、`streaming` |

订阅合并：

```http
POST /api/merge
Content-Type: application/json

{
  "urls": ["https://example.com/sub1", "https://example.com/sub2"],
  "target": "clashmeta",
  "dedupe": true,
  "emoji": true,
  "sort": false,
  "rulePreset": "standard"
}
```

合并预览：

```http
POST /api/merge/preview
```

节点健康检测：

```http
POST /api/health/check
Content-Type: application/json

{
  "url": "https://example.com/sub",
  "timeout": 5000,
  "concurrent": 10,
  "exportTarget": "v2rayn"
}
```

也可以直接传原始节点内容：

```json
{
  "content": "ss://...\nvmess://...",
  "exportTarget": "clashmeta"
}
```

短链接：

```http
POST /api/shortlink
Content-Type: application/json

{
  "url": "https://example.com/api/convert?target=clashmeta&url=...",
  "code": "my-profile"
}
```

其他接口：

```http
GET /api/shortlink/list
DELETE /api/shortlink/:id
GET /api/targets
GET /healthz
```

## 测试和审计

```bash
npm test
npm run build
npm run audit
```

当前测试覆盖协议解析、目标客户端关键字段、订阅转换、合并、去重、健康检测和在线节点导出。

## 镜像发布

推送到 `main` 后，GitHub Actions 会构建并发布：

```text
ghcr.io/tony-wang1990/laowang-sub-converter:latest
ghcr.io/tony-wang1990/laowang-sub-converter:main
ghcr.io/tony-wang1990/laowang-sub-converter:sha-xxxxxxx
```

支持 `linux/amd64` 和 `linux/arm64`。

## License

MIT
