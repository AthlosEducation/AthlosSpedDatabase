CREATE FUNCTION fn_RowLevelSecurity (@FilterName sysname)
RETURNS TABLE
WITH SCHEMABINDING
as
RETURN SELECT 1 as fn_SecureUserData
where @FilterName = user_name();

GO

