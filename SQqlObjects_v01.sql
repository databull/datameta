SELECT
object_id,
SchemaName = schema_name(schema_id),
name,
type_desc,
CreateDate = CAST(create_date AS DATE),
ModifyDate = CAST(modify_date AS DATE),
ParentObjectName = object_name(parent_object_id)
 FROM sys.objects where is_ms_shipped = 0