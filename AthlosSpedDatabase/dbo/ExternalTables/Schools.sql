CREATE EXTERNAL TABLE [dbo].[Schools] (
    [sourceId] NVARCHAR (200) NULL,
    [dateLastModified] DATETIME NULL,
    [metadata] NVARCHAR (200) NULL,
    [status] NVARCHAR (200) NULL,
    [name] NVARCHAR (200) NULL,
    [type] NVARCHAR (200) NULL,
    [identifier] NVARCHAR (200) NULL,
    [parenthref] NVARCHAR (200) NULL,
    [parentsourceId] NVARCHAR (200) NULL,
    [parenttype] NVARCHAR (200) NULL,
    [childrenhref] NVARCHAR (200) NULL,
    [childrensourceId] NVARCHAR (200) NULL,
    [childrentype] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [StagingDatabase]
    );


GO

