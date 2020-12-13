CREATE TABLE [dbo].[Groups] (
    [GroupID]   INT            IDENTITY (1, 1) NOT NULL,
    [GroupName] NVARCHAR (100) NOT NULL,
    CONSTRAINT [pkGroupID] PRIMARY KEY CLUSTERED ([GroupID] ASC)
);


GO

