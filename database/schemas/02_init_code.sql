-- 공통 코드: 입고·출고 상태 (project-standards.md §3)

INSERT INTO wms.twms_com_cd (code_grp, code_cd, code_nm, disp_ord, use_yn, created_by)
VALUES
    ('INB_STATUS', '00', '주문생성', 1, 'Y', 'seed'),
    ('INB_STATUS', '10', '검수중', 2, 'Y', 'seed'),
    ('INB_STATUS', '20', '검수완료', 3, 'Y', 'seed'),
    ('INB_STATUS', '90', '입고확정', 4, 'Y', 'seed'),
    ('OUT_STATUS', '00', '주문생성', 1, 'Y', 'seed'),
    ('OUT_STATUS', '10', '피킹중', 2, 'Y', 'seed'),
    ('OUT_STATUS', '20', '피킹완료', 3, 'Y', 'seed'),
    ('OUT_STATUS', '90', '출고확정', 4, 'Y', 'seed')
ON CONFLICT (code_grp, code_cd) DO UPDATE
SET code_nm = EXCLUDED.code_nm,
    disp_ord = EXCLUDED.disp_ord,
    use_yn = EXCLUDED.use_yn,
    updated_at = CURRENT_TIMESTAMP,
    updated_by = 'seed';
