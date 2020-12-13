CREATE TABLE [dbo].[UsersGroups] (
    [UsersGroupsID] INT IDENTITY (1, 1) NOT NULL,
    [GroupID]       INT NOT NULL,
    [UserID]        INT NOT NULL,
    CONSTRAINT [pkUsersGroupsID] PRIMARY KEY CLUSTERED ([UsersGroupsID] ASC)
);


GO

