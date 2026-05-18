---
description: "DB 설계 표준 – 스키마 wms, 테이블 접두어 twms_, 공통 컬럼, PK/FK 네이밍, DDL/DML 순서"
globs: ["database/**/*.sql"]
alwaysApply: false
---


<!--
[목적] SQL 파일 작성 규칙. database/ 하위 .sql 파일 편집 시에만 로드된다.
[작동] database/ 하위 .sql 파일을 작업할 때 자동 적용.
-->

# 데이터베이스 SQL 규칙

## 참조 문서
- docs/99.references/coding-standards.md — DB 네이밍 규칙 (스키마, 테이블, 컬럼, PK/FK 패턴) 상세
- docs/99.references/document-standards.md — DDL/초기 데이터 파일 네이밍 규칙

## DDL
- 스키마: wms
- 테이블 접두사: twms_
- 컬럼명: snake_case
- 공통 컬럼: created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at, created_by, updated_by
- PK 네이밍: pk_테이블명
- FK 필요시 네이밍: fk_테이블명_참조테이블명

## DML
- INSERT 시 컬럼명 명시
- 한국어 데이터는 UTF-8 전제

## 주의
- DROP TABLE은 IF EXISTS 사용
- 실행 순서: DDL(01) → 초기데이터(02)
