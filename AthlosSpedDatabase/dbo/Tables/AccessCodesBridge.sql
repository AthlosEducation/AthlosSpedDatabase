CREATE TABLE [dbo].[AccessCodesBridge] (
    [AccessCodesBridgeID] INT IDENTITY (1, 1) NOT NULL,
    [AccessCodeID]        INT NOT NULL,
    [SchoolID]            INT NOT NULL,
    [DistrictID]          INT NOT NULL,
    CONSTRAINT [pkAccessCodesBridgeID] PRIMARY KEY CLUSTERED ([AccessCodesBridgeID] ASC),
    CONSTRAINT [fkAccessCodesBridgeToAccessCodes] FOREIGN KEY ([AccessCodeID]) REFERENCES [dbo].[AccessCode] ([AccessCodeID]),
    CONSTRAINT [fkAccessCodesBridgeToDistricts] FOREIGN KEY ([DistrictID]) REFERENCES [dbo].[District] ([DistrictID]),
    CONSTRAINT [fkAccessCodesBridgeToSchools] FOREIGN KEY ([SchoolID]) REFERENCES [dbo].[School] ([SchoolID])
);


GO

