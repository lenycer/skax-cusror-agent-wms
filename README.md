<<<<<<< HEAD
# WMS 구축 프로젝트 — Cursor Agent 실습

## 프로젝트 개요

Cursor Agent 활용한 멀티 에이전트 개발 실습 프로젝트입니다. 5요소(Rules, Commands, Skills, Agents, Hooks)를 구축하고, 8명의 에이전트가 협업하여 WMS(창고관리시스템)를 개발하는 과정을 체험합니다.
=======
# WMS 구축 프로젝트 — Cursor Agent 기반실습

## 프로젝트 개요

Cursor Agent를 활용한 멀티 에이전트 개발 실습 프로젝트입니다. 하네스 5요소(Rules, Commands, Skills, Agents, Hooks)를 구축하고, 8명의 에이전트가 협업하여 WMS(창고관리시스템)를 개발하는 과정을 체험합니다.
>>>>>>> 6c440eb2a68ea19e223dfb8e98151d78f269b6ac

## 기술 스택

| 구분 | 스택 |
|------|------|
| 백엔드 | Java 17, Spring Boot 3.x, MyBatis, PostgreSQL |
| 프론트엔드 | Vue 3 (CDN, Options API), Vue Router (CDN, Hash History), Element Plus, Tailwind CSS, Axios |
| CORS | Spring Security (CORS 전용, 인증 없음) |
| 빌드 | Gradle |
| API 문서 | Springdoc OpenAPI (Swagger UI) |
| DB 스키마 | `wms`, 테이블 접두사 `twms_` |

## 저장소 구조

```
skax-devlab-wms/
├── .cursor/                          # Cursor 설정
│   ├── rules/                        # 코딩 규칙 (6개)
│   │   ├── 01-project-context.mdc    # 전역 컨텍스트 (alwaysApply)
│   │   ├── 02-java-backend.mdc      # Java 백엔드 규칙
│   │   ├── 03-mybatis-mapper.mdc     # MyBatis XML 규칙
│   │   ├── 04-frontend.mdc          # 프론트엔드 규칙
│   │   ├── 05-status-transition.mdc  # 상태 전이 규칙
│   │   └── 06-database.mdc          # DB SQL 규칙
│   ├── commands/                     # 슬래시 커맨드
│   ├── skills/                       # 재사용 워크플로우
│   ├── agents/                       # 에이전트 정의 (8개)
│   │   ├── orchestrator.md           # 오케스트레이터
│   │   ├── analyst.md                # 분석/설계
│   │   ├── db-architect.md           # DB 설계
│   │   ├── ui-designer.md            # UI 설계
│   │   ├── backend-developer.md      # 백엔드 개발
│   │   ├── frontend-developer.md     # 프론트엔드 개발
│   │   ├── test-backend.md           # 백엔드 테스트
│   │   └── test-integration.md       # 통합 테스트
│   └── hooks/                        # 자동 트리거
├── docs/
│   ├── 00.guide/                     # 실습 가이드 (00~09)
│   ├── 01.analysis/
│   │   ├── 01.rfp/                   # PRD 원문
│   │   ├── 02.requirements/          # 요구사항 정의서
│   │   ├── 03.tasks/                 # Task 정의서
│   │   └── 04.ui/                    # UI 설계서
│   ├── 99.references/                # 참조 문서
│   │   ├── document-standards.md     # 산출물 네이밍·구조·경로
│   │   ├── coding-standards.md       # 개발 표준 (패키지/API/DB)
│   │   ├── backend-config.md         # application.yml 기본 설정
│   │   ├── project-standards.md      # 프로젝트 표준 (도메인, 상태코드)
│   │   └── data-dictionary.md        # 데이터 사전 (db-architect 생성)
│   └── test-reports/                 # 테스트 리포트
├── backend/
│   ├── build.gradle
│   ├── settings.gradle
│   ├── gradlew, gradlew.bat
│   ├── gradle/wrapper/
│   └── src/main/
│       ├── java/com/execnt/wms/
│       │   ├── config/               # SecurityConfig (CORS 전용)
│       │   ├── controller/
│       │   ├── service/
│       │   ├── mapper/
│       │   └── exception/
│       └── resources/
│           ├── application.yml
│           └── mapper/               # MyBatis XML
├── frontend/
│   ├── index.html                    # SPA 진입점 (Vue app mount, CDN 임포트)
│   ├── app.js                        # Vue 앱 생성 + 컴포넌트/플러그인 등록
│   ├── router.js                     # Vue Router 라우팅 정의
│   ├── js/
│   │   ├── api.js                    # API 호출 중앙 집중
│   │   └── common.js                 # 공통 유틸리티
│   ├── views/                        # 페이지 컴포넌트
│   ├── components/                   # 재사용 컴포넌트
│   └── css/
├── database/
│   └── schemas/                      # DDL·초기 데이터 SQL
├── scripts/
│   ├── start-backend.sh              # 서버 기동 + health check
│   └── stop-backend.sh               # 서버 종료
└── README.md
```

## 참조 문서 체계

에이전트와 Rules는 아래 참조 문서를 공통 기준으로 사용합니다. 표준을 변경할 때는 참조 문서만 수정하면 전체에 반영됩니다.

| 참조 문서 | 경로 | 내용 | 성격 |
|--------|------|------|------|
| 산출물 표준 | `docs/99.references/document-standards.md` | 산출물 경로, 파일 네이밍, 문서 구조, 참조 규칙 | 범용 |
| 개발 표준 | `docs/99.references/coding-standards.md` | 패키지/클래스/API/DB 네이밍, 응답 포맷 | 범용 |
| 백엔드 설정 | `docs/99.references/backend-config.md` | application.yml 기본 설정, CORS/Security | 프로젝트 |
| 프로젝트 표준 | `docs/99.references/project-standards.md` | 도메인 정의, 상태코드, 네이밍 적용 (analyst가 생성) | 프로젝트 |
| 데이터 사전 | `docs/99.references/data-dictionary.md` | 테이블·컬럼 의미, 공통코드 (db-architect가 생성) | 프로젝트 |

## API 응답 규약

```json
// 성공
{ "success": true, "data": { ... } }

// 실패
{ "success": false, "message": "에러 사유" }
```

## 에이전트 구성

8명의 에이전트가 역할별로 분리되어 순차적으로 협업합니다.

```
orchestrator (전체 조율)
  │
  ├─ analyst (분석/설계 + project-standards.md 생성)
  │
  ├─ db-architect ─┐
  │                ├─ (병렬 가능)
  ├─ ui-designer  ─┘
  │
  ├─ backend-developer (구현 + 서버 기동 확인 + REQ §5 갱신)
  │
  ├─ test-backend (API 테스트)
  │
  ├─ frontend-developer (화면 구현)
  │
  └─ test-integration (UI 시나리오 기반 E2E 테스트)
```

## PRD 기능 범위

| 기능 ID | 기능명 | 설명 |
|---------|--------|------|
| F1 | 입고 관리 | 입고 주문 목록/상세 조회, 상태 전이 (주문생성→검수중→검수완료→입고확정) |
| F2 | 출고 관리 | 출고 주문 목록/상세 조회, 상태 전이 (주문생성→피킹중→피킹완료→출고확정) |
| F3 | 대시보드 | 입고/출고 상태별 건수, 최근 이력, 주문별 이력 추적 |
| F4 | 상태 전이 | twms_status_transition 테이블 기반 검증, 이력 기록, 트랜잭션 보장 |

## CORS / Security 설정

- JWT 인증, 로그인 화면, 사용자 관리 등 인증/인가 로직은 없음
- 단, 프론트엔드(Live Server ~5500)와 백엔드(bootRun ~8080)가 다른 포트에서 실행되므로 CORS 허용을 위한 SecurityConfig가 포함됨
- SecurityConfig는 CORS 전용: 모든 Origin 허용, 인증 없이 전체 경로 permitAll
- 상세 설정은 docs/99.references/backend-config.md 참조

## 제외 사항

- 인증/로그인/JWT 없음
- 외부 시스템 연동 없음
- 마스터 관리 화면 없음 (INSERT로 직접 투입)

## 실습 가이드

`docs/00.guide/` 폴더의 가이드를 순서대로 따릅니다.

| 단계 | 파일 | 내용 |
|------|------|------|
| 00 | `00-overview.md` | 전체 구조 이해 |
| 01 | `01-repository-layout.md` | 저장소 구조 |
| 02 | `02-rules.md` | Rules 작성 |
| 03 | `03-commands.md` | Commands 작성 |
| 04 | `04-skills.md` | Skills 작성 |
| 05 | `05-agents.md` | Agents 정의 |
| 06 | `06-hooks.md` | Hooks 설정 |
| 07 | `07-verification.md` | 검증 |
| 08 | `08-sequential-dev.md` | 에이전트 순차 개발 (사람이 7명을 순서대로 호출) |
| 09 | `09-orchestration.md` | 오케스트레이터 자동 완성 (1명에게 전체 위임) |

## 로컬 실행

**백엔드**

```bash
cd backend
./gradlew build       # 컴파일 확인
./gradlew bootRun     # 개발 서버 기동 (http://localhost:8080)
```

Swagger UI: `http://localhost:8080/swagger-ui.html`

**프론트엔드**

SPA 구조이므로 index.html 하나를 정적 서버로 제공합니다.
Cursor/VS Code의 Live Server 확장을 사용합니다.

1. Cursor에서 Live Server 확장 설치
2. frontend/index.html 열기
3. 우클릭 → "Open with Live Server" (또는 하단 상태바 "Go Live" 클릭)
4. 브라우저에서 http://localhost:5500 접속

Vue Router의 Hash History 모드를 사용하므로 별도 서버 설정 없이 동작합니다.

> **CORS 참고**: 프론트(5500)와 백엔드(8080)가 다른 포트이므로 브라우저가 CORS를 검사합니다. 백엔드의 SecurityConfig가 이를 허용합니다. curl은 정상인데 브라우저에서 API 호출이 실패하면 개발자 도구 Network 탭에서 CORS 에러를 확인하세요.

**데이터베이스**

DB 접속 정보는 `backend/src/main/resources/application.yml`에 정의되어 있습니다. 기본값은 `docs/99.references/backend-config.md`를 참고하세요. 스키마 적용 순서는 `database/schemas/` 하위 SQL 파일의 번호 순서를 따릅니다.

## 헬퍼 스크립트

| 스크립트 | 용도 |
|---------|------|
| `scripts/start-backend.sh` | 서버 기동 + health check 대기 (최대 60초) |
| `scripts/stop-backend.sh` | PID 기반 서버 종료 |

에이전트(backend-developer, test-backend, test-integration)가 서버 기동/종료 시 사용합니다.
