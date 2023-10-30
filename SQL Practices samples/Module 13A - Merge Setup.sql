USE [AdventureWorks2016];
GO

If OBJECT_ID('dbo.Customers') is not null
DROP TABLE dbo.Customers
go

If OBJECT_ID('dbo.Customers_Stage') is not null
DROP TABLE dbo.Customers_Stage
go


/****** Object:  Table [dbo].[Customers]    Script Date: 5/10/2016 5:31:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers_Stage]    Script Date: 5/10/2016 5:31:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers_Stage](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

GO
INSERT [dbo].[Customers] ([CustomerKey], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11000, N'Jon', N'Yang', N'M', N'jon24@adventure-works.com', N'3761 N. 14th St', NULL, N'1 (11) 500 555-0162')
GO
INSERT [dbo].[Customers] ([CustomerKey], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11001, N'Eugene', N'Huang', N'M', N'eugene10@adventure-works.com', N'2243 W St.', NULL, N'1 (11) 500 555-0110')
GO
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
SET IDENTITY_INSERT [dbo].[Customers_Stage] ON 

GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11000, NULL, N'Jon', N'Yang', N'M', N'jon24@adventure-works.com', N'3761 N. 14th St', NULL, N'1 (11) 500 555-0162')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11001, NULL, N'Eugene', N'Huang', N'M', N'eugene10@adventure-works.com', N'2243 W St.', NULL, N'1 (11) 500 555-0110')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11002, NULL, N'Ruben', N'Torres', N'M', N'ruben35@adventure-works.com', N'5844 Linden Land', NULL, N'1 (11) 500 555-0184')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11003, NULL, N'Christy', N'Zhu', N'F', N'christy12@adventure-works.com', N'1825 Village Pl.', NULL, N'1 (11) 500 555-0162')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11004, NULL, N'Elizabeth', N'Johnson', N'F', N'elizabeth5@adventure-works.com', N'7553 Harness Circle', NULL, N'1 (11) 500 555-0131')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11005, NULL, N'Julio', N'Ruiz', N'M', N'julio1@adventure-works.com', N'7305 Humphrey Drive', NULL, N'1 (11) 500 555-0151')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11006, NULL, N'Janet', N'Alvarez', N'F', N'janet9@adventure-works.com', N'2612 Berry Dr', NULL, N'1 (11) 500 555-0184')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11007, NULL, N'Marco', N'Mehta', N'M', N'marco14@adventure-works.com', N'942 Brook Street', NULL, N'1 (11) 500 555-0126')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11008, NULL, N'Rob', N'Verhoff', N'F', N'rob4@adventure-works.com', N'624 Peabody Road', NULL, N'1 (11) 500 555-0164')
GO
INSERT [dbo].[Customers_Stage] ([CustomerKey], [Title], [FirstName], [LastName], [Gender], [EmailAddress], [AddressLine1], [AddressLine2], [Phone]) VALUES (11009, NULL, N'Shannon', N'Carlson', N'M', N'shannon38@adventure-works.com', N'3839 Northgate Road', NULL, N'1 (11) 500 555-0110')
GO
SET IDENTITY_INSERT [dbo].[Customers_Stage] OFF
GO

UPDATE Customers SET EmailAddress = NULL

SELECT * FROM Customers
SELECT * FROM Customers_Stage