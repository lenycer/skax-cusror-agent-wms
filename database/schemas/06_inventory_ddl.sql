-- WMS 재고 테이블 DDL (F5~F7, F6)
-- 표준: docs/99.references/document-standards.md §2.5, coding-standards.md §6
-- 선행: 01_ddl.sql ~ 05_init_sample.sql 적용 후 단독 실행
-- 반복 적용: DROP 후 CREATE
-- 초기 재고 INSERT 없음 (PRD §6.3, REQ-F6 §3.10)

DROP TABLE IF EXISTS wms.twms_inventory_hist CASCADE;
DROP TABLE IF EXISTS wms.twms_inventory CASCADE;

-- 재고 잔량 마스터 (F6)
CREATE TABLE wms.twms_inventory (
    center_cd   VARCHAR(16) NOT NULL,
    sku_cd      VARCHAR(40) NOT NULL,
    qty_on_hand NUMERIC(14, 4) NOT NULL DEFAULT 0,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP,
    created_by  VARCHAR(50),
    updated_by  VARCHAR(50),
    CONSTRAINT pk_inventory PRIMARY KEY (center_cd, sku_cd),
    CONSTRAINT fk_inventory_center FOREIGN KEY (center_cd) REFERENCES wms.twms_center (center_cd),
    CONSTRAINT fk_inventory_item FOREIGN KEY (sku_cd) REFERENCES wms.twms_item (sku_cd),
    CONSTRAINT ck_inventory_qty_on_hand CHECK (qty_on_hand >= 0)
);

COMMENT ON TABLE wms.twms_inventory IS '재고 잔량 (센터·SKU 단위)';

-- 재고 증감 이력 (F6)
CREATE TABLE wms.twms_inventory_hist (
    hist_seq       BIGSERIAL NOT NULL,
    center_cd      VARCHAR(16) NOT NULL,
    sku_cd         VARCHAR(40) NOT NULL,
    txn_type       VARCHAR(16) NOT NULL,
    qty_delta      NUMERIC(14, 4) NOT NULL,
    qty_after      NUMERIC(14, 4) NOT NULL,
    ref_order_kind VARCHAR(16) NOT NULL,
    ref_order_no   VARCHAR(32) NOT NULL,
    ref_line_no    INTEGER NOT NULL,
    changed_by     VARCHAR(50),
    changed_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP,
    created_by     VARCHAR(50),
    updated_by     VARCHAR(50),
    CONSTRAINT pk_inventory_hist PRIMARY KEY (hist_seq),
    CONSTRAINT ck_inventory_hist_txn_type CHECK (txn_type IN ('INBOUND', 'OUTBOUND')),
    CONSTRAINT ck_inventory_hist_ref_order_kind CHECK (ref_order_kind IN ('INBOUND', 'OUTBOUND'))
);

COMMENT ON TABLE wms.twms_inventory_hist IS '재고 증감 이력';

CREATE INDEX idx_inventory_hist_center_sku ON wms.twms_inventory_hist (center_cd, sku_cd, changed_at DESC);
CREATE INDEX idx_inventory_hist_ref_order ON wms.twms_inventory_hist (ref_order_kind, ref_order_no);

-- ---------------------------------------------------------------------------
-- 애플리케이션 계정 권한 (superuser 또는 테이블 OWNER로 실행)
-- 대상: backend application.yml 의 SPRING_DATASOURCE_USERNAME (기본 wms_developer)
-- 테이블만 이미 생성된 경우: 아래 GRANT 3줄만 단독 실행해도 됨
-- ---------------------------------------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON wms.twms_inventory TO wms_developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON wms.twms_inventory_hist TO wms_developer;

-- BIGSERIAL 시퀀스명은 환경마다 다를 수 있음 → 컬럼 기준으로 조회 후 GRANT
DO $$
DECLARE
    seq_name text;
BEGIN
    SELECT pg_get_serial_sequence('wms.twms_inventory_hist', 'hist_seq') INTO seq_name;
    IF seq_name IS NULL THEN
        RAISE EXCEPTION 'hist_seq 시퀀스 없음. 확인: SELECT pg_get_serial_sequence(''wms.twms_inventory_hist'', ''hist_seq'');';
    END IF;
    EXECUTE format('GRANT USAGE, SELECT, UPDATE ON SEQUENCE %s TO wms_developer', seq_name);
END $$;
