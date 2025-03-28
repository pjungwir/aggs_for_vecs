-- Test that we have the same contents after upgrading from a prior version:
SELECT  c.relname,
        CASE WHEN c.relname = 'pg_proc' THEN objid::regprocedure::text
             ELSE '???'
             END AS depobj
FROM    pg_depend d
JOIN    pg_class c ON d.classid = c.oid
WHERE   d.refclassid = 'pg_extension'::regclass
AND     d.refobjid = (SELECT oid FROM pg_extension WHERE extname = 'aggs_for_vecs')
ORDER BY c.relname, depobj
;

DROP EXTENSION aggs_for_vecs;
CREATE EXTENSION aggs_for_vecs WITH VERSION '1.2.0';
ALTER EXTENSION aggs_for_vecs UPDATE;

SELECT  c.relname,
        CASE WHEN c.relname = 'pg_proc' THEN objid::regprocedure::text
             ELSE '???'
             END AS depobj
FROM    pg_depend d
JOIN    pg_class c ON d.classid = c.oid
WHERE   d.refclassid = 'pg_extension'::regclass
AND     d.refobjid = (SELECT oid FROM pg_extension WHERE extname = 'aggs_for_vecs')
ORDER BY c.relname, depobj
;
