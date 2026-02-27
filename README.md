# DiggIndie Infrastructure

DiggIndie 프로젝트의 AWS 인프라를 Terraform Cloud로 관리합니다.

## 아키텍처

```
┌─────────────────────────────────────────────────┐
│  VPC (10.0.0.0/16)                              │
│                                                  │
│  ┌──────────────────┐  ┌──────────────────┐     │
│  │  Public Subnet A │  │  Public Subnet B │     │
│  │  10.0.1.0/24     │  │  10.0.2.0/24     │     │
│  │                  │  │                  │     │
│  │  ┌────────────┐  │  │                  │     │
│  │  │  EC2       │  │  │                  │     │
│  │  │  (Docker)  │  │  │                  │     │
│  │  └────────────┘  │  │                  │     │
│  └──────────────────┘  └──────────────────┘     │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │  RDS (PostgreSQL)                        │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │  ECS Cluster + Service (Fargate)         │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘

ECR Repository → Docker 이미지 저장소
```

## 리소스 목록

| 리소스 | 설명 |
|--------|------|
| VPC | 퍼블릭 서브넷 2개 (Multi-AZ) |
| EC2 | Ubuntu 22.04, Docker/Compose 설치 |
| RDS | PostgreSQL, db.t3.micro |
| ECR | Docker 이미지 레지스트리 |

## Terraform Cloud 설정

### Variables (Workspace > Variables)

**Environment Variables:**

| Key | Sensitive |
|-----|-----------|
| `AWS_ACCESS_KEY_ID` | ✅ |
| `AWS_SECRET_ACCESS_KEY` | ✅ |

**Terraform Variables:**

| Key | Default | Sensitive |
|-----|---------|-----------|
| `key_name` | - | ❌ |
| `db_password` | - | ✅ |

### 워크플로우

```
git push → Terraform Cloud Plan (자동) → Apply (Auto/Manual)
```

## 로컬 개발

```bash
# Terraform Cloud 로그인
terraform login

# 초기화
terraform init

# Plan (Cloud에서 원격 실행)
terraform plan

# Apply
terraform apply
```
