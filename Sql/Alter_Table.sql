ALTER TABLE [dbo].[USER]
ADD [Permission] NVARCHAR(5) NOT NULL DEFAULT 'ΦΥ'
    CHECK ([Permission] IN (N'ΦΥ', N'ΑΑ',N'ΛΤ', N'ΑΧ'));

ALTER TABLE [dbo].[DOCUMENTS]
ADD [File] VARBINARY(MAX) NULL;

ALTER TABLE [dbo].[APPLICATION]
ADD CONSTRAINT DF_Application_Date DEFAULT ('2025-01-01') FOR [DATE];

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