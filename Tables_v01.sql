SELECT
    TableName = tbl.table_schema + '.' + tbl.table_name
-- ,ColumnName = col.column_name
-- ,ColumnDataType = col.data_type
FROM
    INFORMATION_SCHEMA.TABLES tbl
    JOIN INFORMATION_SCHEMA.COLUMNS col
    ON col.table_name = tbl.table_name
        AND col.table_schema = tbl.table_schema
        AND tbl.TABLE_TYPE = 'base table'
    LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    ON tc.TABLE_NAME = tbl.TABLE_NAME
        AND tc.table_schema = tbl.table_schema
