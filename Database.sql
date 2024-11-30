--TABLE CREATION:

-- User table creation with constraint to indicate type
CREATE TABLE [dbo].[USER] (
    [ID] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    [Birthdate] SMALLDATETIME NOT NULL,
    [Address] NVARCHAR(255) NOT NULL,
    [Phone_Number] NVARCHAR(15) NOT NULL,
    [Role_Type] NVARCHAR(50) NOT NULL CHECK ([Role_Type] IN ('Physical', 'Company')), -- User role constraint
    [Username] NVARCHAR(50) NOT NULL UNIQUE,
    [Password] NVARCHAR(50) NOT NULL
);

-- Documents table
CREATE TABLE [dbo].[DOCUMENTS] (
    [DOCUMENT#] INT NOT NULL PRIMARY KEY,
    [TYPE] NVARCHAR(50) NOT NULL
);

-- Subsity Categories table with allowed categories only
CREATE TABLE [dbo].[SUBSITY_CATEGORIES] (
    [CATEGORY_NUMBER] NVARCHAR(10) NOT NULL PRIMARY KEY CHECK ([CATEGORY_NUMBER] IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8', 'Γ10', 'Γ11', 'Γ12', 'Γ13', 'Γ14')),
    [AMOUNT] DECIMAL(10, 2) NOT NULL,
    [AVAILABLE_SUBSITY_NUMBER] INT NOT NULL
);

-- Criteria for Validation table
CREATE TABLE [dbo].[CRITERIA_FOR_VALIDATION] (
    [CRITERIA#] INT NOT NULL PRIMARY KEY,
    [DESCRIPTION] NVARCHAR(255) NOT NULL,
    [CATEGORY_NUMBER] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [dbo].[SUBSITY_CATEGORIES]([CATEGORY_NUMBER])
);

-- Terms & Conditions table
CREATE TABLE [dbo].[TERMS_AND_CONDITIONS] (
    [TERM_ID] INT NOT NULL PRIMARY KEY,
    [DESCRIPTION] NVARCHAR(255) NOT NULL
);

-- Application table with constraints for physical and company users
CREATE TABLE [dbo].[APPLICATION] (
    [APPLICATION#] INT NOT NULL PRIMARY KEY,
    [DATE] SMALLDATETIME NOT NULL,
    [ID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[USER]([ID]),
    [CATEGORY_NUMBER] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [dbo].[SUBSITY_CATEGORIES]([CATEGORY_NUMBER]),
    CHECK ([CATEGORY_NUMBER] IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8', 'Γ10', 'Γ11', 'Γ12', 'Γ13', 'Γ14'))
);

-- Vehicles table
CREATE TABLE [dbo].[VEHICLES] (
    [REGISTRATION#] NVARCHAR(15) NOT NULL PRIMARY KEY,
    [TYPE] NVARCHAR(50) NOT NULL,
    [CONDITION] NVARCHAR(50) NOT NULL,
    [MANUFACTURE_DATE] SMALLDATETIME NOT NULL,
    [CATEGORY] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [dbo].[SUBSITY_CATEGORIES]([CATEGORY_NUMBER]),
    [ORDER#] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[VEHICLE_ORDER]([ORDER#])
);

-- Vehicle Order table
CREATE TABLE [dbo].[VEHICLE_ORDER] (
    [ORDER#] INT NOT NULL PRIMARY KEY,
    [ORDER_DATE] SMALLDATETIME NOT NULL,
    [APPLICATION#] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[APPLICATION]([APPLICATION#])
);

-- Change table
CREATE TABLE [dbo].[CHANGE] (
    [CHANGE#] INT NOT NULL PRIMARY KEY,
    [HISTORY] NVARCHAR(255) NOT NULL,
    [DATE] SMALLDATETIME NOT NULL,
    [REASON] NVARCHAR(255) NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [APPLICATION#] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[APPLICATION]([APPLICATION#])
);

-- Constraints for application limits per user type
ALTER TABLE [dbo].[APPLICATION]
ADD CONSTRAINT FK_User_Type_Application_Limit CHECK (
    (
        (SELECT COUNT(*) FROM [dbo].[APPLICATION] WHERE [ID] = [APPLICATION].[ID] AND [CATEGORY_NUMBER] IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8')) <= 1 AND
        (SELECT COUNT(*) FROM [dbo].[APPLICATION] WHERE [ID] = [APPLICATION].[ID] AND [CATEGORY_NUMBER] = 'Γ14') <= 1
    ) 
    OR 
    (
        (SELECT COUNT(*) FROM [dbo].[APPLICATION] WHERE [ID] = [APPLICATION].[ID]) <= 20
    )
);




-- TRIGGERS:
-- 1. -- Trigger to enforce a maximum of 20 applications per company user
-- CREATE TRIGGER trg_CompanyUserApplicationLimit
-- ON [dbo].[APPLICATION]
-- AFTER INSERT
-- AS
-- BEGIN
--     DECLARE @userID INT;

--     SELECT @userID = [ID]
--     FROM inserted;

--     -- Check if the user is a company user
--     IF EXISTS (SELECT 1 FROM [dbo].[USER] WHERE [ID] = @userID AND [Role_Type] = 'Company')
--     BEGIN
--         -- Enforce a maximum of 20 applications for company users
--         IF (SELECT COUNT(*) FROM [dbo].[APPLICATION] WHERE [ID] = @userID) > 20
--         BEGIN
--             RAISERROR ('Company users can submit a maximum of 20 applications.', 16, 1);
--             ROLLBACK TRANSACTION;
--         END
--     END
-- END;

-- -- Trigger to enforce application limits for Physical users
-- CREATE TRIGGER trg_PhysicalUserApplicationLimit
-- ON [dbo].[APPLICATION]
-- AFTER INSERT
-- AS
-- BEGIN
--     DECLARE @userID INT;
--     DECLARE @category NVARCHAR(10);

--     SELECT @userID = [ID], @category = [CATEGORY_NUMBER]
--     FROM inserted;

--     -- Check if the user is a physical user
--     IF EXISTS (SELECT 1 FROM [dbo].[USER] WHERE [ID] = @userID AND [Role_Type] = 'Physical')
--     BEGIN
--         -- Enforce limit of 1 application per category for categories Γ1 - Γ8, Γ10 - Γ13
--         IF @category IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8', 'Γ10', 'Γ11', 'Γ12', 'Γ13')
--         BEGIN
--             IF EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @userID AND [CATEGORY_NUMBER] = @category)
--             BEGIN
--                 RAISERROR ('Physical users can only submit one application per category for Γ1 - Γ8, Γ10 - Γ13.', 16, 1);
--                 ROLLBACK TRANSACTION;
--             END
--         END
        
--         -- Enforce a single application for category Γ14
--         IF @category = 'Γ14'
--         BEGIN
--             IF EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @userID AND [CATEGORY_NUMBER] = 'Γ14')
--             BEGIN
--                 RAISERROR ('Physical users can only submit one application for category Γ14.', 16, 1);
--                 ROLLBACK TRANSACTION;
--             END
--         END

--         -- Enforce a single application for category Γ15
--         IF @category = 'Γ15'
--         BEGIN
--             IF EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @userID AND [CATEGORY_NUMBER] = 'Γ15')
--             BEGIN
--                 RAISERROR ('Physical users can only submit one application for category Γ15.', 16, 1);
--                 ROLLBACK TRANSACTION;
--             END
--         END
--     END
-- END;





-- ENTRY GENERATING SCRIPT:

-- -- Step 1: Generate 10,000 Users (70% physical, 30% company)
-- DECLARE @TotalUsers INT = 10000;
-- DECLARE @CompanyRatio FLOAT = 0.3; -- 30% companies
-- DECLARE @PhysicalRatio FLOAT = 1 - @CompanyRatio;
-- DECLARE @CompanyUsers INT = FLOOR(@TotalUsers * @CompanyRatio);
-- DECLARE @PhysicalUsers INT = @TotalUsers - @CompanyUsers;
-- DECLARE @UserId INT = 1;

-- -- Insert Physical Users
-- WHILE @UserId <= @PhysicalUsers
-- BEGIN
--     INSERT INTO [dbo].[USER] ([ID], [Name], [Birthdate], [Address], [Phone_Number], [Role_Type], [Username], [Password])
--     VALUES (@UserId, CONCAT('PhysicalUser', @UserId), DATEADD(YEAR, -20 - (ABS(CHECKSUM(NEWID())) % 30), GETDATE()),
--             CONCAT('Address ', @UserId), CONCAT('Phone', RIGHT(CONVERT(VARCHAR, ABS(CHECKSUM(NEWID()))), 8)), 'Physical',
--             CONCAT('physuser', @UserId), CONCAT('pass', @UserId));
--     SET @UserId = @UserId + 1;
-- END

-- -- Insert Company Users
-- WHILE @UserId <= @TotalUsers
-- BEGIN
--     INSERT INTO [dbo].[USER] ([ID], [Name], [Birthdate], [Address], [Phone_Number], [Role_Type], [Username], [Password])
--     VALUES (@UserId, CONCAT('CompanyUser', @UserId), DATEADD(YEAR, -50 - (ABS(CHECKSUM(NEWID())) % 30), GETDATE()),
--             CONCAT('CompanyAddress ', @UserId), CONCAT('Phone', RIGHT(CONVERT(VARCHAR, ABS(CHECKSUM(NEWID()))), 8)), 'Company',
--             CONCAT('compuser', @UserId), CONCAT('compass', @UserId));
--     SET @UserId = @UserId + 1;
-- END;

-- PRINT 'Users generated successfully.';

-- -- Step 2: Generate Applications
-- -- Define categories as per requirements
-- DECLARE @Categories TABLE (Category NVARCHAR(10));
-- INSERT INTO @Categories (Category) VALUES 
-- ('Γ1'), ('Γ2'), ('Γ3'), ('Γ4'), ('Γ5'), ('Γ6'), ('Γ7'), ('Γ8'), 
-- ('Γ10'), ('Γ11'), ('Γ12'), ('Γ13'), ('Γ14'), ('Γ15');

-- DECLARE @ApplicationID INT = 1;

-- -- Insert applications for Company Users
-- DECLARE @CurrentCompanyUserID INT = @PhysicalUsers + 1;
-- WHILE @CurrentCompanyUserID <= @TotalUsers
-- BEGIN
--     DECLARE @ApplicationsCount INT = 0;

--     -- Company can have up to 20 applications in random categories
--     WHILE @ApplicationsCount < 20
--     BEGIN
--         DECLARE @Category NVARCHAR(10) = (SELECT TOP 1 Category FROM @Categories ORDER BY NEWID());
        
--         IF NOT EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @CurrentCompanyUserID AND [CATEGORY_NUMBER] = @Category)
--         BEGIN
--             INSERT INTO [dbo].[APPLICATION] ([APPLICATION_ID], [ID], [CATEGORY_NUMBER])
--             VALUES (@ApplicationID, @CurrentCompanyUserID, @Category);
            
--             SET @ApplicationID = @ApplicationID + 1;
--             SET @ApplicationsCount = @ApplicationsCount + 1;
--         END
--     END

--     SET @CurrentCompanyUserID = @CurrentCompanyUserID + 1;
-- END;

-- PRINT 'Company applications generated successfully.';

-- -- Insert applications for Physical Users
-- DECLARE @CurrentPhysicalUserID INT = 1;

-- WHILE @CurrentPhysicalUserID <= @PhysicalUsers
-- BEGIN
--     -- Physical users: Add one application for each category in Γ1-Γ8, Γ10-Γ13
--     DECLARE @MainCategory NVARCHAR(10) = (SELECT TOP 1 Category FROM @Categories WHERE Category IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8', 'Γ10', 'Γ11', 'Γ12', 'Γ13') ORDER BY NEWID());

--     IF NOT EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @CurrentPhysicalUserID AND [CATEGORY_NUMBER] = @MainCategory)
--     BEGIN
--         INSERT INTO [dbo].[APPLICATION] ([APPLICATION_ID], [ID], [CATEGORY_NUMBER])
--         VALUES (@ApplicationID, @CurrentPhysicalUserID, @MainCategory);

--         SET @ApplicationID = @ApplicationID + 1;
--     END

--     -- Add one application for category Γ14
--     IF NOT EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @CurrentPhysicalUserID AND [CATEGORY_NUMBER] = 'Γ14')
--     BEGIN
--         INSERT INTO [dbo].[APPLICATION] ([APPLICATION_ID], [ID], [CATEGORY_NUMBER])
--         VALUES (@ApplicationID, @CurrentPhysicalUserID, 'Γ14');

--         SET @ApplicationID = @ApplicationID + 1;
--     END

--     -- Add one application for category Γ15
--     IF NOT EXISTS (SELECT 1 FROM [dbo].[APPLICATION] WHERE [ID] = @CurrentPhysicalUserID AND [CATEGORY_NUMBER] = 'Γ15')
--     BEGIN
--         INSERT INTO [dbo].[APPLICATION] ([APPLICATION_ID], [ID], [CATEGORY_NUMBER])
--         VALUES (@ApplicationID, @CurrentPhysicalUserID, 'Γ15');

--         SET @ApplicationID = @ApplicationID + 1;
--     END

--     SET @CurrentPhysicalUserID = @CurrentPhysicalUserID + 1;
-- END;

-- PRINT 'Physical user applications generated successfully.';
