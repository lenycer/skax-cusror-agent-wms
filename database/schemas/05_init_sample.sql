-- 샘플 주문·라인·이력 (REQ-F1/F2/F3 §5.4 시드 전제·대시보드 분포)
-- 재실행 시 동일 결과를 위해 주문 영역 초기화(마스터·코드·전이 규칙 유지).
DELETE FROM wms.twms_order_status_hist WHERE created_by = 'seed';
DELETE FROM wms.twms_inbound_order;
DELETE FROM wms.twms_outbound_order;

-- 입고 헤더
INSERT INTO wms.twms_inbound_order (order_no, center_cd, status_cd, order_dt, created_by)
VALUES
    ('IB-20260514-0001', 'CTR01', '00', '2026-05-14 09:00:00', 'seed'),
    ('IB-INVALID-TRANS', 'CTR01', '90', '2026-05-13 08:00:00', 'seed'),
    ('IB-CTR02-001', 'CTR02', '00', '2026-05-14 08:30:00', 'seed'),
    ('IB-CTR02-010', 'CTR02', '10', '2026-05-14 07:00:00', 'seed'),
    ('IB-CTR01-020', 'CTR01', '20', '2026-05-13 10:00:00', 'seed')
ON CONFLICT (order_no) DO UPDATE
SET status_cd = EXCLUDED.status_cd,
    center_cd = EXCLUDED.center_cd,
    order_dt = EXCLUDED.order_dt,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';

-- 입고 라인
INSERT INTO wms.twms_inbound_order_line (order_no, line_no, sku_cd, qty_ordered, qty_confirmed, created_by)
VALUES
    ('IB-20260514-0001', 1, 'SKU-AAA', 10, 0, 'seed'),
    ('IB-20260514-0001', 2, 'SKU-BBB', 5, 0, 'seed'),
    ('IB-INVALID-TRANS', 1, 'SKU-AAA', 1, 1, 'seed'),
    ('IB-CTR02-001', 1, 'SKU-CCC', 3, 0, 'seed'),
    ('IB-CTR02-010', 1, 'SKU-AAA', 8, 0, 'seed'),
    ('IB-CTR01-020', 1, 'SKU-BBB', 12, 10, 'seed'),
    ('IB-CTR01-020', 2, 'SKU-CCC', 4, 4, 'seed')
ON CONFLICT (order_no, line_no) DO UPDATE
SET sku_cd = EXCLUDED.sku_cd,
    qty_ordered = EXCLUDED.qty_ordered,
    qty_confirmed = EXCLUDED.qty_confirmed,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';

-- 출고 헤더
INSERT INTO wms.twms_outbound_order (order_no, center_cd, status_cd, order_dt, created_by)
VALUES
    ('OB-20260514-0001', 'CTR01', '00', '2026-05-14 10:00:00', 'seed'),
    ('OB-DONE', 'CTR01', '90', '2026-05-12 09:00:00', 'seed'),
    ('OB-CTR02-010', 'CTR02', '10', '2026-05-14 08:00:00', 'seed'),
    ('OB-CTR01-020', 'CTR01', '20', '2026-05-13 14:00:00', 'seed'),
    ('OB-CTR02-000', 'CTR02', '00', '2026-05-14 11:00:00', 'seed')
ON CONFLICT (order_no) DO UPDATE
SET status_cd = EXCLUDED.status_cd,
    center_cd = EXCLUDED.center_cd,
    order_dt = EXCLUDED.order_dt,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';

-- 출고 라인
INSERT INTO wms.twms_outbound_order_line (order_no, line_no, sku_cd, qty_ordered, qty_picked, created_by)
VALUES
    ('OB-20260514-0001', 1, 'SKU-BBB', 5, 0, 'seed'),
    ('OB-DONE', 1, 'SKU-AAA', 2, 2, 'seed'),
    ('OB-CTR02-010', 1, 'SKU-CCC', 6, 1, 'seed'),
    ('OB-CTR01-020', 1, 'SKU-BBB', 10, 8, 'seed'),
    ('OB-CTR02-000', 1, 'SKU-AAA', 4, 0, 'seed')
ON CONFLICT (order_no, line_no) DO UPDATE
SET sku_cd = EXCLUDED.sku_cd,
    qty_ordered = EXCLUDED.qty_ordered,
    qty_picked = EXCLUDED.qty_picked,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';

-- 이력 (대시보드 최근/추적용)
INSERT INTO wms.twms_order_status_hist
    (order_kind, order_no, from_status_cd, to_status_cd, changed_by, change_reason, changed_at, created_by)
VALUES
    ('INBOUND', 'IB-CTR01-020', '00', '10', 'demo-user', '검수시작', '2026-05-13 10:05:00', 'seed'),
    ('INBOUND', 'IB-CTR01-020', '10', '20', 'demo-user', '검수완료', '2026-05-13 10:30:00', 'seed'),
    ('INBOUND', 'IB-INVALID-TRANS', '00', '10', 'demo-user', '검수시작', '2026-05-13 08:10:00', 'seed'),
    ('INBOUND', 'IB-INVALID-TRANS', '10', '20', 'demo-user', '검수완료', '2026-05-13 08:20:00', 'seed'),
    ('INBOUND', 'IB-INVALID-TRANS', '20', '90', 'demo-user', '입고확정', '2026-05-13 08:40:00', 'seed'),
    ('OUTBOUND', 'OB-DONE', '00', '10', 'demo-user', '피킹시작', '2026-05-12 09:10:00', 'seed'),
    ('OUTBOUND', 'OB-DONE', '10', '20', 'demo-user', '피킹완료', '2026-05-12 09:30:00', 'seed'),
    ('OUTBOUND', 'OB-DONE', '20', '90', 'demo-user', '출고확정', '2026-05-12 10:00:00', 'seed'),
    ('INBOUND', 'IB-CTR02-010', '00', '10', 'demo-user', '검수시작', '2026-05-14 07:15:00', 'seed'),
    ('OUTBOUND', 'OB-CTR02-010', '00', '10', 'demo-user', '피킹시작', '2026-05-14 08:05:00', 'seed'),
    ('OUTBOUND', 'OB-CTR01-020', '10', '20', 'demo-user', '피킹완료', '2026-05-13 14:45:00', 'seed'),
    ('OUTBOUND', 'OB-CTR01-020', '00', '10', 'demo-user', '피킹시작', '2026-05-13 14:05:00', 'seed');
