CREATE ROLE [db_segmentation]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'db_segmentation', N'svcSegmentation'
GO
GRANT CREATE TABLE TO [db_segmentation]
