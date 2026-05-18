---
description: "상태 전이 검증 – twms_status_transition 테이블 기반 유효성 검사, 이력 테이블 기록 규칙"
globs: []
alwaysApply: false
---



<!--
[목적] 상태 전이 로직 규칙. 에이전트가 상태 관련 작업이라고 판단하면 자동 로드.
[작동] Apply Intelligently — description 기반으로 에이전트가 관련성 판단.
-->

# 상태 전이 규칙

## 참조 문서
- docs/99.references/coding-standards.md — 상태 코드 체계 (INB_STATUS, OUT_STATUS, 코드값 정의)

## 원칙
- 모든 상태 변경은 twms_status_transition 테이블 기반으로 서버에서 검증
- 허용되지 않은 전이는 예외를 발생시키고 명확한 메시지 반환
- 상태 변경과 이력 기록은 같은 트랜잭션 내에서 처리

## 검증 흐름
1. StatusTransitionService.validateTransition(processType, fromStatus, toStatus) 호출
2. twms_status_transition에서 해당 전이가 존재하는지 조회
3. 존재하지 않으면 예외 발생: "허용되지 않은 상태 변경입니다: {from} → {to}"
4. 존재하면 상태 업데이트 + 이력 INSERT

## 이력 기록
- 입고: twms_inbound_history에 INSERT
- 출고: twms_outbound_history에 INSERT
- 기록 항목: order_no, from_status, to_status, changed_at, changed_by
