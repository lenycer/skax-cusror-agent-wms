-- 센터·상품 마스터 (PRD: 상품·센터 단위 운영)

INSERT INTO wms.twms_center (center_cd, center_nm, created_by)
VALUES
    ('CTR01', '서울 물류센터', 'seed'),
    ('CTR02', '경기 물류센터', 'seed')
ON CONFLICT (center_cd) DO UPDATE
SET center_nm = EXCLUDED.center_nm,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';

INSERT INTO wms.twms_item (sku_cd, item_nm, created_by)
VALUES
    ('SKU-AAA', '샘플상품A', 'seed'),
    ('SKU-BBB', '샘플상품B', 'seed'),
    ('SKU-CCC', '샘플상품C', 'seed')
ON CONFLICT (sku_cd) DO UPDATE
SET item_nm = EXCLUDED.item_nm,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';
