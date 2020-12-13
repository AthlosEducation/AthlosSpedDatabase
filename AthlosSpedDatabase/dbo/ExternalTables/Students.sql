CREATE EXTERNAL TABLE [dbo].[Students] (
    [sourceId] NVARCHAR (200) NULL,
    [dateLastModified] DATETIME NULL,
    [metadata] NVARCHAR (200) NULL,
    [status] NVARCHAR (200) NULL,
    [username] NVARCHAR (200) NULL,
    [userIdstype] NVARCHAR (200) NULL,
    [userIdsidentifier] NVARCHAR (200) NULL,
    [enabledUser] NVARCHAR (200) NULL,
    [givenName] NVARCHAR (200) NULL,
    [familyName] NVARCHAR (200) NULL,
    [middleName] NVARCHAR (200) NULL,
    [role] NVARCHAR (200) NULL,
    [identifier] NVARCHAR (200) NULL,
    [email] NVARCHAR (200) NULL,
    [sms] NVARCHAR (200) NULL,
    [phone] NVARCHAR (200) NULL,
    [agentshref] NVARCHAR (200) NULL,
    [agentssourceId] NVARCHAR (200) NULL,
    [agentstype] NVARCHAR (200) NULL,
    [orgshref] NVARCHAR (200) NULL,
    [orgssourceId] NVARCHAR (200) NULL,
    [orgstype] NVARCHAR (200) NULL,
    [grades] NVARCHAR (200) NULL,
    [password] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [StagingDatabase]
    );


GO

