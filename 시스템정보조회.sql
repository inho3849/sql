select * from v$version;             : 버전정보조회

select status from v$instance       : 인스턴스 상태

select * from v$database;            : 데이터베이스 조히

SELECT * FROM DBA_DATA_FILES : 테이블 스페이스 조회

 

시스템 정보 조회 테이블

SQL>select * from all_objects where object_name like '오브젝트명';    :오브젝트 조회

SQL>select * from all_synonyms where synonym_name='시노님명';    :시노팀 조회

SQL>select * from all_ind_columns where table_name='테이블명';      :테이블 인덱스 정보 조회  

SQL>select * from all_tab_columns where table_name='테이블명';      :테이블별 컬럼정보 조회  

SQL>select * from all_col_comments where table_name='테이블명';   :테이블 컬럼 comment 조회  

 

모든 정보 조회 테이블

1. ALL_CATALOG : 모든 테이블, 뷰정보 조회

2. ALL_OBJECT_TABLES : 모든 오브젝트 테이블 정보

3. ALL_TAB_COMMENTS : 모든 테이블 주석 정보

4. ALL_TYPES : 모든 오브젝트 타입에 대한 정보

5. ALL_USERS : 모든 사용자 정보

 

 

 

사용자 정보 조회 테이블

1. USER_TABLES : 테이블정보

2. USER_TAB_COLUMNS : 컬럼정보

3. USER_OBJECTS : 모든 오브젝트의 정보를 알려줌

4. USER_VIEWS : 뷰에 대한 정보

5. USER_SYNONYMS : 동의의 정보

6. USER_SEQUENCES : 시퀀스 정보

7. USER_CONSTRAINTS : 제약조건에 대한 정보

8. USER_CONS_COLUMNS : 제약조건에 대한 컬럼정보

9. USER_TAB_COMMENTS : 테이블/뷰에 대한 주석

10. USER_COL_COMMENTS : 컬럼에 대한 주석

11. USER_INDEXES : 인덱스에 대한 정보

12. USER_IND_COLUMNS : 인덱스 컬럼에 대한 정보

13. USER_CLUSTERS : 클러스터에 대한 정보

14. USER_DB_LINKS : 데이터베이스 링크 정보

15. USER_TRIGGERS : 트리거 정보

16. USER_SOURCE : 프로시저, 함수, 패키지 정보

17. USER_ERRORS : 코드 에러에 대한 정보

18. USER_TABLESPACES : 테이블 스페이스 정보

19. USER_USERS : 사용자에 대한 정보

20. USER_TAB_PRIVS : 테이블 권한에 대한 정보

21. USER_COL_PRIVS : 테이블열 권한에 대한 정보

22. USER_SYS_PRIVS : 시스템 권한에 대한 정보



출처: https://androphil.tistory.com/457?category=458502 [소림사의 홍반장!]

 

테이블 정보조회 SQL

--▶ 테이블정보조회
;
SELECT '' as NO
  ,aa.TABLESPACE_NAME 스키마
  ,aa.TABLE_NAME    테이블영문명 
  ,bb.comments  테이블한글명
  ,TABLE_TYPE  테이블타입
  ,''  테이블구조  
  ,aa.NUM_ROWS        레코드건수
FROM all_tables aa
    ,ALL_TAB_COMMENTS bb
WHERE aa.TABLESPACE_NAME like UPPER('${schema}%')
  and aa.TABLE_NAME like upper('${var}')
  and bb.OWNER = AA.OWNER
  and bb.TABLE_NAME = AA.TABLE_NAME
;

--▶ 컬럼정보조회 : 테이블 매핑관련 스키마 정보 추가
SELECT 
      C.TABLESPACE_NAME 스키마명
     ,A.TABLE_NAME       테이블명
      ,nvl((select 'Y'
    FROM ALL_CONSTRAINTS  c1
       , ALL_CONS_COLUMNS c2
   WHERE c1.TABLE_NAME      = A.TABLE_NAME
     AND c1.CONSTRAINT_TYPE = 'P' 
     AND c1.OWNER           = c2.OWNER
     AND c1.CONSTRAINT_NAME = c2.CONSTRAINT_NAME
     and c2.COLUMN_NAME      = a.COLUMN_NAME
       ),' ')  PK
      ,A.COLUMN_NAME 영문명
      , B.COMMENTS   한글명
      , A.NULLABLE AS NULLYN
      , A.DATA_TYPE 데이터타입
  FROM ALL_TAB_COLUMNS  A
      ,all_all_tables  C
      ,ALL_COL_COMMENTS B
WHERE A.TABLE_NAME      = UPPER('${var}') 
  AND A.OWNER      = B.OWNER
  AND A.TABLE_NAME = B.TABLE_NAME
  AND A.TABLE_NAME = C.TABLE_NAME
  AND A.TABLE_NAME = B.TABLE_NAME(+)
  AND A.COLUMN_NAME = B.COLUMN_NAME(+)
  ORDER BY A.COLUMN_ID

--▶ 테이블 컬럼정보조회 : 컬럼상세까지 조회
SELECT A.COLUMN_ID AS NO
      ,nvl((select 'Y'
    FROM ALL_CONSTRAINTS  c1
       , ALL_CONS_COLUMNS c2
   WHERE c1.TABLE_NAME      = A.TABLE_NAME
     AND c1.CONSTRAINT_TYPE = 'P' 
     AND c1.OWNER           = c2.OWNER
     AND c1.CONSTRAINT_NAME = c2.CONSTRAINT_NAME
     and c2.COLUMN_NAME      = a.COLUMN_NAME
       ),' ')  PK
      ,A.COLUMN_NAME 영문명
      , B.COMMENTS   한글명
      , A.NULLABLE AS NULLYN
      , A.DATA_TYPE 데이터타입
      , A.DATA_LENGTH 자릿수
      , A.DATA_SCALE 소수점
      , ' ' 데이터

  FROM ALL_TAB_COLUMNS  A
      ,ALL_COL_COMMENTS B
      
WHERE A.TABLE_NAME      = UPPER('${var}') 
  AND A.OWNER = B.OWNER
  AND A.TABLE_NAME = B.TABLE_NAME(+)
  AND A.COLUMN_NAME = B.COLUMN_NAME(+)
  ORDER BY A.COLUMN_ID
  ;