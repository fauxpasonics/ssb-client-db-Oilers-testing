CREATE SCHEMA [Prodcopy]
AUTHORIZATION [SSBCLOUD\dhorstman]
GO
GRANT SELECT ON SCHEMA:: [Prodcopy] TO [CI_ClientAccess]
GO
GRANT EXECUTE ON SCHEMA:: [Prodcopy] TO [db_segmentation]
GO
GRANT SELECT ON SCHEMA:: [Prodcopy] TO [db_segmentation]
GO
