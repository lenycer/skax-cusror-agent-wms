-- 전체 업무 테이블 데이터 비우기(시퀀스 리셋)

TRUNCATE TABLE
    wms.twms_order_status_hist,
    wms.twms_inbound_order_line,
    wms.twms_outbound_order_line,
    wms.twms_inbound_order,
    wms.twms_outbound_order,
    wms.twms_status_transition_rule,
    wms.twms_item,
    wms.twms_center,
    wms.twms_com_cd
RESTART IDENTITY CASCADE;
