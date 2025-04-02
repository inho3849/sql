
SELECT /*+ gather_plan_statistics INHO_TEST */
       max(a.cnt)
       , max(a.child_date)
  FROM CHILD_T a
  WHERE CNT = 11
;

SELECT *
  FROM table(dbms_xplan.display_cursor(
    (
    SELECT SQL_ID 
	 FROM (
		SELECT SQL_ID, SQL_TEXT
		  FROM V$SQL
		 WHERE SQL_TEXT NOT LIKE '%v$sql%'
		--   AND SQL_TEXT LIKE '~~~'
		   AND SQL_TEXT LIKE '%INHO_TEST%'
		  ORDER BY LAST_ACTIVE_TIME DESC
		 )
      WHERE rownum = 1
    )
  , NULL, 'advanced allstats last'))
;


