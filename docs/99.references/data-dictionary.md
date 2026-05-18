# 데이터 사전 — WMS (`wms` 스키마)

| 항목 | 내용 |
|------|------|
| 버전 | 1.0 |
| 기준 DDL | `database/schemas/01_ddl.sql` |
| 기준 초기값 | `database/schemas/02_init_code.sql` ~ `database/schemas/05_init_sample.sql` |
| 상태 코드 규격 | `docs/99.references/project-standards.md` §3 |

---

## 1. 스키마

| 이름 | 설명 |
|------|------|
| `wms` | 교육용 WMS 업무 객체 전용 스키마 |

테이블 접두어: **`twms_`** (`docs/99.references/project-standards.md` §2).

---

## 2. 테이블 정의 요약

### 2.1 `wms.twms_com_cd`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `code_grp` | VARCHAR(32) | N | 코드 그룹 (`INB_STATUS`, `OUT_STATUS` 등) |
| `code_cd` | VARCHAR(16) | N | 코드 값 (`00`,`10`,`20`,`90`) |
| `code_nm` | VARCHAR(200) | N | 코드명 (`주문생성`, `검수중`, …) |
| `disp_ord` | INTEGER | N | 정렬 순번 |
| `use_yn` | CHAR(1) | N | 사용 여부 `Y`\|`N` |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_com_cd` `(code_grp, code_cd)`

---

### 2.2 `wms.twms_center`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `center_cd` | VARCHAR(16) | N | 물류센터 코드 |
| `center_nm` | VARCHAR(200) | N | 센터명 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_center` `(center_cd)`

---

### 2.3 `wms.twms_item`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `sku_cd` | VARCHAR(40) | N | 상품 SKU |
| `item_nm` | VARCHAR(200) | N | 상품명 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_item` `(sku_cd)`

---

### 2.4 `wms.twms_inbound_order`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `order_no` | VARCHAR(32) | N | 입고 주문번호 |
| `center_cd` | VARCHAR(16) | N | 센터 |
| `status_cd` | VARCHAR(8) | N | 입고 상태 코드 (`CHECK` 로 `00`,`10`,`20`,`90` 제한) |
| `order_dt` | TIMESTAMP | N | 주문 일시 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_inbound_order` `(order_no)`  
**FK:** `fk_inbound_order_center` → `twms_center(center_cd)`

**인덱스:**

- `idx_inbound_order_center_status` `(center_cd, status_cd)`
- `idx_inbound_order_status` `(status_cd)`

---

### 2.5 `wms.twms_inbound_order_line`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `order_no` | VARCHAR(32) | N | 입고 주문번호 |
| `line_no` | INTEGER | N | 라인 번호 |
| `sku_cd` | VARCHAR(40) | N | SKU |
| `qty_ordered` | NUMERIC(14,4) | N | 예정 수량 |
| `qty_confirmed` | NUMERIC(14,4) | N | 확정 수량 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_inbound_order_line` `(order_no, line_no)`  
**FK:**  
- `fk_inbound_order_line_inbound_order` → `twms_inbound_order(order_no)` ON DELETE CASCADE  
- `fk_inbound_order_line_item` → `twms_item(sku_cd)`

---

### 2.6 `wms.twms_outbound_order`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `order_no` | VARCHAR(32) | N | 출고 주문번호 |
| `center_cd` | VARCHAR(16) | N | 센터 |
| `status_cd` | VARCHAR(8) | N | 출고 상태 코드 (`CHECK` 로 `00`,`10`,`20`,`90` 제한) |
| `order_dt` | TIMESTAMP | N | 주문 일시 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_outbound_order` `(order_no)`  
**FK:** `fk_outbound_order_center` → `twms_center(center_cd)`

**인덱스:**

- `idx_outbound_order_center_status` `(center_cd, status_cd)`
- `idx_outbound_order_status` `(status_cd)`

---

### 2.7 `wms.twms_outbound_order_line`

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `order_no` | VARCHAR(32) | N | 출고 주문번호 |
| `line_no` | INTEGER | N | 라인 번호 |
| `sku_cd` | VARCHAR(40) | N | SKU |
| `qty_ordered` | NUMERIC(14,4) | N | 출고 예정 수량 |
| `qty_picked` | NUMERIC(14,4) | N | 피킹 수량 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_outbound_order_line` `(order_no, line_no)`  
**FK:**  
- `fk_outbound_order_line_outbound_order` → `twms_outbound_order(order_no)` ON DELETE CASCADE  
- `fk_outbound_order_line_item` → `twms_item(sku_cd)`

---

### 2.8 `wms.twms_status_transition_rule` (F4)

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `order_kind` | VARCHAR(16) | N | `INBOUND` \| `OUTBOUND` |
| `from_status_cd` | VARCHAR(8) | N | 이전 상태 |
| `to_status_cd` | VARCHAR(8) | N | 이후 상태 |
| `created_at` | TIMESTAMP | N | 생성일시 |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자 |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_status_transition_rule` `(order_kind, from_status_cd, to_status_cd)`

---

### 2.9 `wms.twms_order_status_hist` (F3 / F4)

| 컬럼 | 타입 | NULL | 설명 |
|------|------|-----|------|
| `hist_seq` | BIGSERIAL | N | 이력 시퀀스 (PK 일부로 사용) |
| `order_kind` | VARCHAR(16) | N | `INBOUND` \| `OUTBOUND` |
| `order_no` | VARCHAR(32) | N | 주문번호 |
| `from_status_cd` | VARCHAR(8) | N | 변경 전 상태 |
| `to_status_cd` | VARCHAR(8) | N | 변경 후 상태 |
| `changed_by` | VARCHAR(50) | Y | 변경 주체(API body `changed_by`) |
| `change_reason` | VARCHAR(500) | Y | 사유(API body `change_reason`) |
| `changed_at` | TIMESTAMP | N | 상태 변경 발생 시각(비즈 의미 타임스탬프) |
| `created_at` | TIMESTAMP | N | 행 적재 일시 (`coding-standards` 공통) |
| `updated_at` | TIMESTAMP | Y | 수정일시 |
| `created_by` | VARCHAR(50) | Y | 생성자(시드·배치) |
| `updated_by` | VARCHAR(50) | Y | 수정자 |

**PK:** `pk_order_status_hist` `(hist_seq)`

**인덱스 (TASK-DB-F3):**

- `idx_order_status_hist_changed_at` `(changed_at DESC)`
- `idx_order_status_hist_order` `(order_kind, order_no)`
- `idx_order_status_hist_order_changed` `(order_kind, order_no, changed_at)`

---

## 3. 코드 그룹

| code_grp | 용도 |
|----------|------|
| `INB_STATUS` | 입고 상태 (`00`/`10`/`20`/`90`) |
| `OUT_STATUS` | 출고 상태 (`00`/`10`/`20`/`90`) |

---

## 4. 상태 전이 초기 규격

`database/schemas/04_init_transition.sql`에서 각 `order_kind`에 대해 `00→10`, `10→20`, `20→90` 세 건만 적재된다. 헤더 상태(`status_cd`)는 이 규칙과 무관하게 `CHECK` 로 코드셋만 강제하며, 잘못된 전이는 애플리케이션(F4)·규칙 테이블로 검증한다.

---

## 5. 참고

| 문서 | 용도 |
|------|------|
| `docs/99.references/coding-standards.md` §6 | 컬럼·PK/FK 네이밍, 공통 컬럼 |
| `docs/99.references/document-standards.md` §2.5 | SQL 파일 패턴 및 경로 |
