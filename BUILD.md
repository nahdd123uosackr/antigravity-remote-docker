# Docker Image Build Guide

이 문서는 Antigravity Remote Docker 이미지를 빌드하는 방법을 설명합니다.
This guide explains how to build the Antigravity Remote Docker image.

## 빌드 방법 (Build Methods)

### 방법 1: Build Script 사용 (Using Build Script)

가장 간단한 방법입니다. 제공된 빌드 스크립트를 사용하세요:

```bash
./build.sh
```

#### 옵션 (Options):
```bash
# 커스텀 이미지 태그 지정
./build.sh --tag antigravity-remote:v1.0.0

# 캐시 없이 빌드
./build.sh --no-cache

# 도움말 보기
./build.sh --help
```

### 방법 2: Docker Compose 사용 (Using Docker Compose)

Docker Compose를 사용하여 빌드하고 실행:

```bash
docker-compose up -d --build
```

이 명령은 이미지를 빌드하고 자동으로 컨테이너를 시작합니다.

### 방법 3: Docker 명령어 직접 사용 (Using Docker Command Directly)

```bash
docker build -t antigravity-remote:latest .
```

## 빌드 요구사항 (Build Requirements)

### 필수 사항:
- Docker 20.10 이상
- 인터넷 연결 (외부 패키지 다운로드를 위해)
- 최소 10GB의 디스크 공간
- 빌드 시간: 약 10-20분 (인터넷 속도에 따라 다름)

### 선택 사항 (실행 시):
- NVIDIA GPU (GPU 가속을 위해)
- NVIDIA Container Toolkit (GPU 패스스루를 위해)

## 빌드 프로세스 (Build Process)

Dockerfile은 다음 단계를 수행합니다:

1. **Base Image**: NVIDIA CUDA 12.3.1 with Ubuntu 22.04
2. **System Dependencies**: X11, VNC, noVNC, XFCE 데스크톱 환경
3. **Google Chrome**: 최신 안정 버전 설치
4. **noVNC**: 웹 기반 VNC 클라이언트 (v1.4.0)
5. **Antigravity**: Google Antigravity 애플리케이션 설치
6. **Configuration**: VNC, 데스크톱, 자동 시작 설정

## 빌드 후 검증 (Verify Build)

빌드가 성공했는지 확인:

```bash
# 이미지 목록 확인
docker images antigravity-remote

# 이미지 상세 정보 확인
docker inspect antigravity-remote:latest
```

## 이미지 실행 (Running the Image)

### Docker Compose 사용:
```bash
docker-compose up -d
```

### Docker 명령어 직접 사용:
```bash
docker run -d \
  --gpus all \
  --name antigravity-remote \
  -p 6080:6080 \
  -p 5901:5901 \
  -e VNC_PASSWORD=your_password \
  -v $(pwd)/data/workspace:/home/antigravity/workspace \
  -v $(pwd)/data/config:/home/antigravity/.config \
  --restart unless-stopped \
  antigravity-remote:latest
```

### 접속 방법:
- **웹 브라우저**: http://localhost:6080
- **VNC 클라이언트**: localhost:5901

## 문제 해결 (Troubleshooting)

### 빌드 실패 시:

1. **네트워크 오류**:
   ```bash
   # 프록시 설정이 필요한 경우
   docker build --build-arg HTTP_PROXY=http://proxy:port -t antigravity-remote:latest .
   ```

2. **디스크 공간 부족**:
   ```bash
   # Docker 정리
   docker system prune -a
   ```

3. **캐시 문제**:
   ```bash
   # 캐시 없이 빌드
   ./build.sh --no-cache
   ```

## 추가 정보 (Additional Information)

- 빌드된 이미지 크기: 약 4-6GB
- 빌드 캐시를 사용하면 재빌드 시간이 크게 단축됩니다
- GPU 지원은 선택사항이며, CPU만으로도 실행 가능합니다

## 다음 단계 (Next Steps)

1. 빌드 완료 후 `.env` 파일 설정:
   ```bash
   cp .env.example .env
   # VNC_PASSWORD 등 설정 수정
   ```

2. 컨테이너 실행:
   ```bash
   docker-compose up -d
   ```

3. 로그 확인:
   ```bash
   docker-compose logs -f
   ```

자세한 사용 방법은 `README.md`를 참조하세요.
