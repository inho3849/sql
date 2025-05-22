SELECT /*+ NO_MERGE(v) */
       s.HASH_VALUE
     , buffer_gets   
     , MODULE
     , 
     ( SELECT username 
         FROM DBA_USERS 
        WHERE user_id =s.parsing_user_id
      ) username
      , executions
      , ROUND(elapsed_time/(DECODE(executions,0,1,NULL,1,executions)*1000000),1) elapsed_t
      , ROUND(s.buffer_gets/DECODE(executions,0,1,NULL,1,executions),1) buffer_gets_per_exec
      , rows_processed
      , sql_text
  FROM
     ( SELECT /*+ NO_MERGE(V1) */
              MAX(HASH_VALUE) HASH_VALUE
         FROM
            (
              SELECT HASH_VALUE, SQL_TEXT
                FROM V$SQL S
               WHERE 1=1
                 AND ( ROUND(buffer_gets/DECODE(executions,0,1,NULL,1,executions),1) > 10000
                       OR elapsed_time/(DECODE(executions,0,1,NULL,1,executions)*1000000) >1 )
                 AND (module IS NULL
                      OR (module NOT LIKE 'TOAD%'
                     AND module NOT LIKE 'Orange%'
                     AND module NOT LIKE 'Golden32.exe%'
                     AND module NOT LIKE 'PL/SQL Developer%'
                     AND module NOT LIKE 'T.O.A.D%'
                     AND UPPER(module) NOT LIKE 'SQL*PLUS%')
                     )
                 AND PARSING_USER_ID IN
                ( SELECT user_id
                    FROM DBA_USERS
                   WHERE username NOT IN ('SYS','SYSTEM')
                )
             ) V1
        GROUP BY SUBSTR(SQL_TEXT,1,150)
     ) v,
       V$SQLAREA s
 WHERE v.hash_value = s.hash_value
  AND parsing_user_id IN
    ( SELECT user_id
        FROM DBA_USERS
       WHERE username NOT IN ('SYS','SYSTEM')
    )
  AND module NOT LIKE 'SmartSQL%'
ORDER BY buffer_gets desc
;


SELECT * FROM V$SQLAREA