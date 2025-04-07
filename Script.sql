SELECT *
  FROM emp a
     , dept b
--     , (SELECT * 
--          FROM contacts t1 )
 WHERE a.job = 'A' 
   AND b.DEPTNO = 10

;


SELECT * FROM emp;