-- 적용 후: psql ... -v ON_ERROR_STOP=on -f database/schemas/verify_all_scripts.sql
SELECT 'schema wms 존재' AS check_name, COUNT(*)::text FROM information_schema.schemata WHERE schema_name = 'wms';

SELECT 'twms 테이블 수(9종)' AS check_name, COUNT(*)::text
FROM information_schema.tables
WHERE table_schema = 'wms'
  AND table_name IN (
      'twms_com_cd','twms_center','twms_item',
      'twms_inbound_order','twms_inbound_order_line',
      'twms_outbound_order','twms_outbound_order_line',
      'twms_status_transition_rule','twms_order_status_hist'
  );

SELECT '코드 행(INB/OUT 상태)' AS check_name, COUNT(*)::text
FROM wms.twms_com_cd WHERE code_grp IN ('INB_STATUS','OUT_STATUS');

SELECT '전이 규칙 건수' AS check_name, COUNT(*)::text FROM wms.twms_status_transition_rule;

SELECT '입고 상태별 요약(샘플)' AS q, status_cd AS k, COUNT(*)::text AS v
FROM wms.twms_inbound_order GROUP BY status_cd ORDER BY status_cd;

SELECT '출고 상태별 요약(샘플)' AS q, status_cd AS k, COUNT(*)::text AS v
FROM wms.twms_outbound_order GROUP BY status_cd ORDER BY status_cd;

SELECT '주문 상태 이력 건수' AS check_name, COUNT(*)::text FROM wms.twms_order_status_hist;
