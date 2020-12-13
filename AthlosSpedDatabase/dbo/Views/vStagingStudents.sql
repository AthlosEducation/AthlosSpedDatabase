CREATE  
VIEW vStagingStudents
AS
SELECT
	sourceId
	,dateLastModified
	,metadata
	,[status]
	,username
	,userIdstype
	,userIdsidentifier
	,enabledUser
	,givenName
	,familyName
	,middleName
	,[role]
	,identifier
	,email
	,sms
	,phone
	,agentshref
	,agentssourceId
	,agentstype
	,orgshref
	,orgssourceId
	,orgstype
	,grades
	,[password]
	,[StagDBStudentSelectorID]= givenName + familyName + identifier
FROM Students;

GO

