CREATE TABLE [dbo].[Onboarding] (
    [OnboardingID]           INT            IDENTITY (1, 1) NOT NULL,
    [PrimaryDeviceType]      NVARCHAR (20)  NULL,
    [ManageIEPGoals]         NVARCHAR (200) NULL,
    [ManageStudentCaseloads] NVARCHAR (200) NULL,
    [ManageStudentLists]     NVARCHAR (200) NULL,
    [CustomerName]           NVARCHAR (200) NULL
);


GO

