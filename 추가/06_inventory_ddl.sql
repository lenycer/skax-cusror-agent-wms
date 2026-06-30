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
