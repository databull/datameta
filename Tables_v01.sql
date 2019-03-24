
use WiltonSrc;
-- USE [mig-db-tenant-acelive];

SELECT
    schema_name(tab.schema_id) AS schema_name
,tab.name AS table_name
,CAST(tab.create_date AS DATE)  AS created
,CAST(tab.modify_date AS DATE)  AS last_modified
,p.rows AS num_rows
,(SELECT
        count(1)
    FROM
        sys.columns c
    WHERE c.object_id= tab.object_id) AS ColumnsCount
    ,(select min(column_id) from sys.index_columns
                         inner join sys.indexes
                             on index_columns.object_id = indexes.object_id
                            and index_columns.index_id = indexes.index_id
                   where tab.object_id = indexes.object_id and indexes.is_primary_key = 1) AS HasPrimaryKey
,ep.value AS comments
FROM
    sys.tables tab
    INNER JOIN (SELECT
        DISTINCT
        p.object_id
,sum(p.rows) rows
    FROM
        sys.tables t
        INNER JOIN sys.partitions p
        ON p.object_id = t.object_id
    GROUP BY p.object_id,
    p.index_id) p
    ON p.object_id = tab.object_id
    LEFT JOIN sys.extended_properties ep
    ON tab.object_id = ep.major_id
        AND ep.name = 'MS_Description'
        AND ep.minor_id = 0
        AND ep.class_desc = 'OBJECT_OR_COLUMN'
ORDER BY schema_name,
table_name
/*
select * from sys.columns order by 1 desc
select * from sys.tables order by 2
*/


