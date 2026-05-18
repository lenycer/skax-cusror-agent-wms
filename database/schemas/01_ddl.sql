-- WMS 교육용 DDL (PostgreSQL)
-- 표준: docs/99.references/document-standards.md §2.5, coding-standards.md §6
-- 반복 적용: DROP 후 CREATE

DROP TABLE IF EXISTS wms.twms_inbound_order_line CASCADE;
DROP TABLE IF EXISTS wms.twms_outbound_order_line CASCADE;
DROP TABLE IF EXISTS wms.twms_inbound_order CASCADE;
DROP TABLE IF EXISTS wms.twms_outbound_order CASCADE;
DROP TABLE IF EXISTS wms.twms_order_status_hist CASCADE;
DROP TABLE IF EXISTS wms.twms_status_transition_rule CASCADE;
DROP TABLE IF EXISTS wms.twms_item CASCADE;
DROP TABLE IF EXISTS wms.twms_center CASCADE;
DROP TABLE IF EXISTS wms.twms_com_cd CASCADE;

DROP SCHEMA IF EXISTS wms CASCADE;
CREATE SCHEMA wms;

-- 공통 코드 (입고·출고 상태명 등 표시용)
CREATE TABLE wms.twms_com_cd (
    code_grp VARCHAR(32) NOT NULL,
    code_cd  VARCHAR(16) NOT NULL,
    code_nm  VARCHAR(200) NOT NULL,
    disp_ord INTEGER NOT NULL DEFAULT 0,
    use_yn   CHAR(1) NOT NULL DEFAULT 'Y',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_com_cd PRIMARY KEY (code_grp, code_cd),
    CONSTRAINT ck_com_cd_use_yn CHECK (use_yn IN ('Y', 'N'))
);

COMMENT ON TABLE wms.twms_com_cd IS '공통 코드 (상태·구분 등)';

-- 물류센터
CREATE TABLE wms.twms_center (
    center_cd VARCHAR(16) NOT NULL,
    center_nm VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_center PRIMARY KEY (center_cd)
);

COMMENT ON TABLE wms.twms_center IS '물류센터 마스터';

-- 상품(SKU)
CREATE TABLE wms.twms_item (
    sku_cd  VARCHAR(40) NOT NULL,
    item_nm VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_item PRIMARY KEY (sku_cd)
);

COMMENT ON TABLE wms.twms_item IS '상품 마스터';

-- 입고 주문 헤더
CREATE TABLE wms.twms_inbound_order (
    order_no   VARCHAR(32) NOT NULL,
    center_cd  VARCHAR(16) NOT NULL,
    status_cd  VARCHAR(8) NOT NULL,
    order_dt   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_inbound_order PRIMARY KEY (order_no),
    CONSTRAINT fk_inbound_order_center FOREIGN KEY (center_cd) REFERENCES wms.twms_center (center_cd),
    CONSTRAINT ck_inbound_order_status CHECK (status_cd IN ('00', '10', '20', '90'))
);

COMMENT ON TABLE wms.twms_inbound_order IS '입고 주문 헤더';

CREATE INDEX idx_inbound_order_center_status ON wms.twms_inbound_order (center_cd, status_cd);
CREATE INDEX idx_inbound_order_status ON wms.twms_inbound_order (status_cd);

-- 입고 주문 라인
CREATE TABLE wms.twms_inbound_order_line (
    order_no      VARCHAR(32) NOT NULL,
    line_no       INTEGER NOT NULL,
    sku_cd        VARCHAR(40) NOT NULL,
    qty_ordered   NUMERIC(14, 4) NOT NULL DEFAULT 0,
    qty_confirmed NUMERIC(14, 4) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_inbound_order_line PRIMARY KEY (order_no, line_no),
    CONSTRAINT fk_inbound_order_line_inbound_order FOREIGN KEY (order_no) REFERENCES wms.twms_inbound_order (order_no) ON DELETE CASCADE,
    CONSTRAINT fk_inbound_order_line_item FOREIGN KEY (sku_cd) REFERENCES wms.twms_item (sku_cd)
);

COMMENT ON TABLE wms.twms_inbound_order_line IS '입고 주문 라인';

-- 출고 주문 헤더
CREATE TABLE wms.twms_outbound_order (
    order_no   VARCHAR(32) NOT NULL,
    center_cd  VARCHAR(16) NOT NULL,
    status_cd  VARCHAR(8) NOT NULL,
    order_dt   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_outbound_order PRIMARY KEY (order_no),
    CONSTRAINT fk_outbound_order_center FOREIGN KEY (center_cd) REFERENCES wms.twms_center (center_cd),
    CONSTRAINT ck_outbound_order_status CHECK (status_cd IN ('00', '10', '20', '90'))
);

COMMENT ON TABLE wms.twms_outbound_order IS '출고 주문 헤더';

CREATE INDEX idx_outbound_order_center_status ON wms.twms_outbound_order (center_cd, status_cd);
CREATE INDEX idx_outbound_order_status ON wms.twms_outbound_order (status_cd);

-- 출고 주문 라인
CREATE TABLE wms.twms_outbound_order_line (
    order_no    VARCHAR(32) NOT NULL,
    line_no     INTEGER NOT NULL,
    sku_cd      VARCHAR(40) NOT NULL,
    qty_ordered NUMERIC(14, 4) NOT NULL DEFAULT 0,
    qty_picked  NUMERIC(14, 4) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_outbound_order_line PRIMARY KEY (order_no, line_no),
    CONSTRAINT fk_outbound_order_line_outbound_order FOREIGN KEY (order_no) REFERENCES wms.twms_outbound_order (order_no) ON DELETE CASCADE,
    CONSTRAINT fk_outbound_order_line_item FOREIGN KEY (sku_cd) REFERENCES wms.twms_item (sku_cd)
);

COMMENT ON TABLE wms.twms_outbound_order_line IS '출고 주문 라인';

-- 상태 전이 규칙 (F4)
CREATE TABLE wms.twms_status_transition_rule (
    order_kind     VARCHAR(16) NOT NULL,
    from_status_cd VARCHAR(8) NOT NULL,
    to_status_cd   VARCHAR(8) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_status_transition_rule PRIMARY KEY (order_kind, from_status_cd, to_status_cd),
    CONSTRAINT ck_status_transition_rule_kind CHECK (order_kind IN ('INBOUND', 'OUTBOUND'))
);

COMMENT ON TABLE wms.twms_status_transition_rule IS '허용 상태 전이 규칙';

-- 주문 상태 변경 이력 (F3/F4)
CREATE TABLE wms.twms_order_status_hist (
    hist_seq       BIGSERIAL NOT NULL,
    order_kind     VARCHAR(16) NOT NULL,
    order_no       VARCHAR(32) NOT NULL,
    from_status_cd VARCHAR(8) NOT NULL,
    to_status_cd   VARCHAR(8) NOT NULL,
    changed_by     VARCHAR(50),
    change_reason  VARCHAR(500),
    changed_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    CONSTRAINT pk_order_status_hist PRIMARY KEY (hist_seq),
    CONSTRAINT ck_order_status_hist_kind CHECK (order_kind IN ('INBOUND', 'OUTBOUND'))
);

COMMENT ON TABLE wms.twms_order_status_hist IS '입·출고 주문 상태 변경 이력';

CREATE INDEX idx_order_status_hist_changed_at ON wms.twms_order_status_hist (changed_at DESC);
CREATE INDEX idx_order_status_hist_order ON wms.twms_order_status_hist (order_kind, order_no);
CREATE INDEX idx_order_status_hist_order_changed ON wms.twms_order_status_hist (order_kind, order_no, changed_at);
