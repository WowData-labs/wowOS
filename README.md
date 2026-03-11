# wowOS

面向树莓派的数据主权 OS：Token 授权、分级脱敏、加密存储、审计日志，支持应用商店与 SDK。

- **[BUILD.md](BUILD.md)** — 镜像构建、烧录与上传代码到 GitHub
- **[DEV.md](DEV.md)** — 本地运行 API、mock_os、应用开发

## 快速开始

```bash
# 本地跑 API
pip3 install -r requirements.txt && python3 run_api.py
# 访问 http://localhost:8080/api/v1/health
```

推送至 `main` 分支后，[GitHub Actions](https://github.com/feiyaozuo/wowOS/actions) 会自动构建镜像，在对应 run 的 **Artifacts** 中下载 `wowos-image` 即可烧录。
