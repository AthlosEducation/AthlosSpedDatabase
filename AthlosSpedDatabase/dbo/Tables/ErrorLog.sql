CREATE TABLE [dbo].[ErrorLog] (
    [ErrorLogID]       INT            IDENTITY (1, 1) NOT NULL,
    [ErrorDate]        DATE           NOT NULL,
    [ErrorDescription] NVARCHAR (MAX) NOT NULL,
    [ErroredTask]      NVARCHAR (100) NOT NULL,
    [DistrictID]       INT            NULL,
    [UserID]           INT            NULL
);


GO

