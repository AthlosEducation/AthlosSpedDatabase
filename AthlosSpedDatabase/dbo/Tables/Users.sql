CREATE TABLE [dbo].[Users] (
    [UserID]                INT            IDENTITY (1, 1) NOT NULL,
    [UserName]              NVARCHAR (50)  NOT NULL,
    [UserEmail]             NVARCHAR (50)  NOT NULL,
    [UserFirstName]         NVARCHAR (25)  NOT NULL,
    [UserLastName]          NVARCHAR (25)  NOT NULL,
    [UserRole]              NVARCHAR (25)  NOT NULL,
    [UserIsCurrent]         BIT            CONSTRAINT [dfUserIsCurrent] DEFAULT ((1)) NOT NULL,
    [SchoolID]              INT            NOT NULL,
    [DistrictID]            INT            NOT NULL,
    [AspNetUserID]          NVARCHAR (450) NULL,
    [CleverID]              NVARCHAR (200) NULL,
    [AddIEPAllowed]         BIT            NOT NULL,
    [EditIEPAllowed]        BIT            NOT NULL,
    [AddStudentsAllowed]    BIT            NOT NULL,
    [ManageCaseloadAllowed] BIT            NOT NULL,
    [CaseloadSnapshotID]    INT            DEFAULT ((1)) NOT NULL,
    [GroupSnapshotID]       INT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [pkUserID] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO

