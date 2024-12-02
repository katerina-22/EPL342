-- Documents table
CREATE TABLE [dbo].[DOCUMENTS] (
    [DOCUMENT#] INT NOT NULL PRIMARY KEY,
    [TYPE] NVARCHAR(50) NOT NULL
);
-- User table creation with constraints
CREATE TABLE [dbo].[USER] (
    [ID] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    [Birthdate] SMALLDATETIME NOT NULL,
    [Address] NVARCHAR(255) NOT NULL,
    [Phone_Number] NVARCHAR(15) NOT NULL,
    [Role_Type] NVARCHAR(50) NOT NULL CHECK ([Role_Type] IN ('Physical', 'Company')), -- User role constraint
    [Username] NVARCHAR(50) NOT NULL UNIQUE,
    [Password] NVARCHAR(50) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [DOCUMENT#] INT NULL FOREIGN KEY REFERENCES [DOCUMENTS]([DOCUMENT#]) ON UPDATE CASCADE -- On cascade update of documents
);

-- Subsity Categories table with allowed categories
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


-- Application table with enhancements
CREATE TABLE [dbo].[APPLICATION] (
    [APPLICATION#] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [DATE] SMALLDATETIME NOT NULL,
    [ID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[USER]([ID]) ON DELETE CASCADE, -- On delete of user, delete all their applications
    [CATEGORY_NUMBER] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [dbo].[SUBSITY_CATEGORIES]([CATEGORY_NUMBER]),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending Review', -- Default status is 'Pending Review'
    CHECK ([CATEGORY_NUMBER] IN ('Γ1', 'Γ2', 'Γ3', 'Γ4', 'Γ5', 'Γ6', 'Γ7', 'Γ8', 'Γ10', 'Γ11', 'Γ12', 'Γ13', 'Γ14'))
);


-- Vehicle Order table
CREATE TABLE [dbo].[VEHICLE_ORDER] (
    [ORDER#] INT NOT NULL PRIMARY KEY,
    [ORDER_DATE] SMALLDATETIME NOT NULL,
    [APPLICATION#] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[APPLICATION]([APPLICATION#])
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

-- Change table
CREATE TABLE [dbo].[CHANGE] (
    [CHANGE#] INT NOT NULL PRIMARY KEY,
    [HISTORY] NVARCHAR(255) NOT NULL,
    [DATE] SMALLDATETIME NOT NULL,
    [REASON] NVARCHAR(255) NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [APPLICATION#] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[APPLICATION]([APPLICATION#])
);


ALTER TABLE [dbo].[USER]
ADD [Permission] NVARCHAR(5) NOT NULL DEFAULT 'ΦΥ'
    CHECK ([Permission] IN (N'ΦΥ', N'ΑΑ',N'ΛΤ', N'ΑΧ'));

ALTER TABLE [dbo].[DOCUMENTS]
ADD [File] VARBINARY(MAX) NULL;

ALTER TABLE [dbo].[APPLICATION]
ADD CONSTRAINT DF_Application_Date DEFAULT ('2025-01-01') FOR [DATE];


-- done


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


-- Create an index on the USER table to improve query performance
CREATE INDEX IDX_User_Role_Type ON [dbo].[USER] ([Role_Type]);

INSERT INTO [dbo].[USER] (
    [ID],
    [Name],
    [Birthdate],
    [Address],
    [Phone_Number],
    [Role_Type],
    [Username],
    [Password],
    [Email],
    [Permission]
)
VALUES (
    1063940,
    N'Κληρίδης Χριστόδουλος - Γλαύκος',
    '2002-10-11', -- Use ISO format YYYY-MM-DD
    N'Αργυρωκάστρου 5, Στρόβολος, Λευκωσία, 2064',
    N'+35799643634',
    N'Physical',
    N'ccleri02',
    N'Xgk!cs2002',
    N'christodoulosclerides@gmail.com',
    N'ΦΥ'
);

-- Application 1 (Category Γ1 - Allowed for physical users, tests single application constraint)
INSERT INTO [dbo].[APPLICATION] ([DATE], [ID], [CATEGORY_NUMBER], [Status]) 
VALUES ('2025-01-01', 1063940, N'Γ1', N'Pending for Review');

-- Application 2 (Category Γ2 - Allowed for physical users, tests category limit)
INSERT INTO [dbo].[APPLICATION] ([DATE], [ID], [CATEGORY_NUMBER], [Status]) 
VALUES ('2025-01-02', 1063940, N'Γ2', N'Pending for Review');

-- Application 3 (Category Γ14 - Allowed for physical users, tests special case category limit)
INSERT INTO [dbo].[APPLICATION] ([DATE], [ID], [CATEGORY_NUMBER], [Status]) 
VALUES ('2025-01-03', 1063940, N'Γ14', N'Pending for Review');

-- Application 4 (Category Γ5 - Not allowed for physical users, should fail)
INSERT INTO [dbo].[APPLICATION] ([DATE], [ID], [CATEGORY_NUMBER], [Status]) 
VALUES ('2025-01-04', 1063940, N'Γ5', N'Pending for Review');

-- Application 5 (Category Γ1 - Duplicate test for the same category, should fail)
INSERT INTO [dbo].[APPLICATION] ([DATE], [ID], [CATEGORY_NUMBER], [Status]) 
VALUES ('2025-01-05', 1063940, N'Γ1', N'Pending for Review');

-- Insert subsidy categories with descriptions into SUBSITY_CATEGORIES
INSERT INTO [dbo].[SUBSITY_CATEGORIES] ([CATEGORY_NUMBER], [DESCRIPTION], [AMOUNT], [AVAILABLE_SUBSITY_NUMBER])
VALUES
(N'Γ1', N'Απόσυρση και αντικατάσταση με καινούργιο όχημα ιδιωτικής χρήσης χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 7500.00, 1228),
(N'Γ2', N'Απόσυρση και αντικατάσταση με καινούργιο όχημα ταξί χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 12000.00, 30),
(N'Γ3', N'Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) για δικαιούχο αναπηρικού οχήματος', 15000.00, 30),
(N'Γ4', N'Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) πολύτεκνης οικογένειας', 15000.00, 30),
(N'Γ5', N'Χορηγία για αγορά καινούργιου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2', 9000.00, 1827),
(N'Γ6', N'Χορηγία για αγορά καινούργιου οχήματος ταξί μηδενικών εκπομπών CO2', 20000.00, 60),
(N'Γ7', N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 για δικαιούχο αναπηρικού οχήματος', 20000.00, 60),
(N'Γ8', N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 πολύτεκνης οικογένειας', 20000.00, 60),
(N'Γ9', N'Χορηγία για αγορά μεταχειρισμένου οχήματος μηδενικών εκπομπών CO2', 9000.00, 104),
(N'Γ10', N'Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος της κατηγορίας Ν1 (οχήματα μικτού βάρους μέχρι 3.500 κιλά)', 15000.00, 185),
(N'Γ11', N'Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος της κατηγορίας Ν2 (οχήματα μικτού βάρους που δεν υπερβαίνει τα 3.500 κιλά αλλά δεν υπερβαίνει τα 12.000 κιλά)', 25000.00, 4),
(N'Γ12', N'Χορηγία για αγορά καινούργιου οχήματος κατηγορίας M2 μηδενικών εκπομπών CO2 (μικρό λεωφορείο το οποίο περιλαμβάνει περισσότερες από οκτώ θέσεις καθημένων πέραν του καθίσματος του οδηγού και έχει μέγιστη μάζα το πολύ 5 τόνους)', 40000.00, 2),
(N'Γ13', N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L6e (υποκατηγορία «Β») και L7e (υποκατηγορία «C»)', 4000.00, 65),
(N'Γ14', N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L (εξαιρουμένων των οχημάτων κατηγορίας L6e (υποκατηγορία «Β») και L7e (υποκατηγορία «Β και C»))', 1500.00, 893);