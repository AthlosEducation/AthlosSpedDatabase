CREATE FUNCTION rls.fn_securitypredicate(@name AS sysname)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result
    WHERE @name = USER_NAME() OR USER_NAME() = 'hparkinson';

GO

