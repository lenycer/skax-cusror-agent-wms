-- 상태 전이 규칙 (REQ-F4, project-standards.md §3.3)

INSERT INTO wms.twms_status_transition_rule (order_kind, from_status_cd, to_status_cd, created_by)
VALUES
    ('INBOUND', '00', '10', 'seed'),
    ('INBOUND', '10', '20', 'seed'),
    ('INBOUND', '20', '90', 'seed'),
    ('OUTBOUND', '00', '10', 'seed'),
    ('OUTBOUND', '10', '20', 'seed'),
    ('OUTBOUND', '20', '90', 'seed')
ON CONFLICT (order_kind, from_status_cd, to_status_cd) DO NOTHING;
