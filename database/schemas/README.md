# WMS 교육 DB 스크립트

## 실행 순서 (PostgreSQL)

1. 역할·DB 준비(환경별, 예제는 생략 가능)
2. `01_ddl.sql` — 스키마 **wms** 및 테이블·인덱스 생성  
3. `02_init_code.sql` — 상태 공통 코드  
4. `03_init_master.sql` — 센터·SKU  
5. `04_init_transition.sql` — 전이 규칙(F4)  
6. `05_init_sample.sql` — 샘플 주문·라인·이력(F1/F2/F3 검증용)

예:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=on -f database/schemas/01_ddl.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=on -f database/schemas/02_init_code.sql
# ...
```

재시드만 갱신할 때는 마스터·코드 유지 상태에서 `05_init_sample.sql`만 재실행해도 됩니다(스크립트 상단 DELETE 처리).

전체 초기화: `truncate_all_tables.sql` 실행 후 위 `02_init_code.sql` ~ `05_init_sample.sql` 순서로 재삽입합니다( DDL `01_ddl.sql` 유지 가능).

검증: `verify_all_scripts.sql`

네이밍·경로: `docs/99.references/document-standards.md` §2.5  
컬럼·PK/FK: `docs/99.references/coding-standards.md` §6
