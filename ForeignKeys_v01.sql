SELECT
    schema_name(tab.schema_id) AS table_schema_name
    ,tab.name AS table_name
    ,col.name AS column_name
    ,fk.name AS constraint_name
    ,schema_name(tab_prim.schema_id) AS primary_table_schema_name
    ,tab_prim.name AS primary_table_name
    ,col_prim.name AS primary_table_column
    ,schema_name(tab.schema_id) + '.' + tab.name + '.' +
            col.name + ' = ' + schema_name(tab_prim.schema_id) + '.' +
            tab_prim.name + '.' + col_prim.name AS join_condition
    ,CASE
            WHEN count(*) OVER (partition BY fk.name) > 1 THEN 'Y'
            ELSE 'N'
       END AS complex_fk
    ,fkc.constraint_column_id AS fk_part
FROM
    sys.tables AS tab
    INNER JOIN sys.foreign_keys AS fk
    ON tab.object_id = fk.parent_object_id
    INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
    INNER JOIN sys.columns AS col
    ON fkc.parent_object_id = col.object_id
        AND fkc.parent_column_id = col.column_id
    INNER JOIN sys.columns AS col_prim
    ON fkc.referenced_object_id = col_prim.object_id
        AND fkc.referenced_column_id = col_prim.column_id
    INNER JOIN sys.tables AS tab_prim
    ON fk.referenced_object_id = tab_prim.object_id
ORDER BY table_schema_name,
       table_name,
       primary_table_name,
       fk_part;