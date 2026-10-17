# CloudLeak 授权网络渠道测试包

这些样本用于你控制的 GitHub、镜像仓库和网页。**真实渠道，不是真实凭据。**
文件内均为合成占位值。不要添加生产密钥、自己的 GitHub token、数据库密码或 SSH 私钥。

## 内容

- `config/demo.env`：三种唯一身份正样本；
- `config/clean.env`：负样本；
- `Dockerfile` / `.dockerignore`：仅复制上述配置的极小静态镜像；
- `docs/index.html`：GitHub Pages 正样本网页；
- `docs/clean.html`：GitHub Pages 负样本网页。

先只将本测试包上传到一个新建专用仓库，不要上传整个系统目录、临时数据库、个人项目或 Docker 登录配置。

## A. GitHub

在你自己的账号下新建 `cloudleak-fixture` 仓库，建议 Public。
上传本包所有文件并保持目录结构；确保 `.dockerignore` 也上传。
无需将真实访问 token 放进仓库。

在 CloudLeak 项目目录运行（替换 MY_GITHUB_NAME）：

```powershell
python -m cloudleak.cli --github MY_GITHUB_NAME/cloudleak-fixture --format json
```

公开小仓库先尝试匿名只读访问。只有限流或私有仓库才考虑本地配置访问凭据；
如需凭据，限制为单个测试仓库的只读权限，不粘贴到聊天或测试文件。
当前命令扫描仓库文件快照，提交历史与持续增量要另行执行和验收。

## B. Docker 镜像

先安装并启动 Docker Desktop，使用 Linux containers。
如果 `docker version` 没有 Server 信息，先修复 Docker 引擎启动问题。

在 Docker Hub 自己的账号下建 Public 仓库 `cloudleak-fixture`。
在本包目录的 PowerShell 执行：

```powershell
$DockerUser = "MY_DOCKER_HUB_NAME"
docker build --platform linux/amd64 -t "${DockerUser}/cloudleak-fixture:v1" .
docker login
docker push "${DockerUser}/cloudleak-fixture:v1"
```

`docker login` 在你自己的电脑交互登录。不要把密码、PAT 或 Docker 配置发送到聊天。
本镜像只是文件载体，没有 CMD，不需要也不能作为应用运行。
不需要购买服务器或域名。

在 CloudLeak 项目目录扫描公开镜像：

```powershell
python -m cloudleak.cli --oci registry-1.docker.io/MY_DOCKER_HUB_NAME/cloudleak-fixture --reference v1
```

当前匿名公开镜像路径最简单。私有镜像的 registry bearer-token 交互需要独立验证；
不要直接把 Docker Hub 登录密码/PAT 当成扫描器的 bearer token。

## C. 网页

在 GitHub `cloudleak-fixture` 仓库：

1. Settings → Pages；
2. Source = Deploy from a branch；
3. Branch = main（或实际默认分支），Folder = /docs；
4. Save；等待部署成功；
5. 以 Pages 设置页面实际给出的 URL 为准。

通常形如：

```text
https://MY_GITHUB_NAME.github.io/cloudleak-fixture/
https://MY_GITHUB_NAME.github.io/cloudleak-fixture/clean.html
```

在 CloudLeak 项目目录：

```powershell
python -m cloudleak.cli --url https://MY_GITHUB_NAME.github.io/cloudleak-fixture/
python -m cloudleak.cli --url https://MY_GITHUB_NAME.github.io/cloudleak-fixture/clean.html
```

不需要自建网站、安装 Nginx 或购买云主机。

## 授权范围

完成发布后，可告知Agent：

> 上述 GitHub 仓库、Docker Hub 仓库及 Pages 页面由我控制，
> 授权本项目读取其文件/镜像及测试提交进行检测和评测；
> 不使用任何真实凭据、不登录业务系统、不修改或删除远端内容。

授权仅覆盖列出的具体资源，不覆盖同一账号其他私有仓库或第三方资源。

## 验收与证据

1. 正样本应识别 AWS Access Key ID、GitHub PAT、数据库连接串三种身份；
2. 负样本应为零个发现；
3. 同一凭据在代码、网页、镜像中重复出现，跨源聚合时是一个身份、多条 occurrence；
4. 保存源 URL、提交 SHA、镜像 digest、发布日期证据、扫描开始/结束时间和脱敏报告；
5. 可额外发布一个新的纯合成值测量新内容从可访问到首次检出的时间；
6. 缺失发布时间应标记 unknown；Git提交时间、网页更新时间不必然等于真正公开时间。

自建靶场证明真实网络采集与端到端运行，不证明生产凭据可用性，也不代表真实泄露检出率。

- config/extended-20261017.env: extended synthetic type coverage (non-functional values only).
- config/clean-extended-20261017.env: matching clean control.

