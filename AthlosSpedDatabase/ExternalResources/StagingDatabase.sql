CREATE EXTERNAL DATA SOURCE [StagingDatabase]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'athlossped.database.windows.net',
    DATABASE_NAME = N'AthlosSPED_STAGING',
    CREDENTIAL = [athlosadmin]
    );


GO

