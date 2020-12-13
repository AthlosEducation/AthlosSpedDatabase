CREATE TABLE [dbo].[AccessCode] (
    [AccessCodeID] INT           IDENTITY (1, 1) NOT NULL,
    [Code]         NVARCHAR (8)  NOT NULL,
    [Role]         NVARCHAR (50) NOT NULL,
    [DistrictID]   INT           NOT NULL,
    [SchoolID]     INT           NOT NULL,
    [Used]         BIT           NOT NULL,
    [UserID]       INT           NULL,
    CONSTRAINT [pkAccessCodeID] PRIMARY KEY CLUSTERED ([AccessCodeID] ASC),
    CONSTRAINT [ukAccessCode] UNIQUE NONCLUSTERED ([Code] ASC)
);


GO

