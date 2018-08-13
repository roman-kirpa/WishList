USE [master]
GO

CREATE DATABASE [WishList]
 COLLATE Cyrillic_General_CI_AS 
 go
USE [WishList]
GO
/****** Object:  Table [dbo].[Costs]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Costs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cost] [float] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Item_Id] [int] NOT NULL,
 CONSTRAINT [PK_Costs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Items]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Items](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nchar](250) NOT NULL,
	[Url] [nchar](250) NOT NULL,
	[user_id] [int] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Url] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogExceptions]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogExceptions](
	[Message] [nchar](100) NOT NULL,
	[StackTrace] [nchar](500) NOT NULL,
	[DateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](25) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vItemsAndCosts]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vItemsAndCosts] as
select i.Title, i.Url, i.Id as Item_Id, u.Name, c.Datetime, c.Cost
from Items as i
join Users as u on i.user_id = u.Id
join Costs as c on c.Item_Id = i.Id

GO
ALTER TABLE [dbo].[Costs]  WITH CHECK ADD FOREIGN KEY([Item_Id])
REFERENCES [dbo].[Items] ([Id])
GO
ALTER TABLE [dbo].[Items]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[spAddNewCost]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddNewCost] @Cost float, @DateTime datetime,  @item_Id int
AS
insert into [dbo].[Costs] (Cost, DateTime, Item_Id) values (@Cost, @DateTime, @item_Id) 
GO
/****** Object:  StoredProcedure [dbo].[spLogExceptions]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spLogExceptions] @Message varchar(100), @StackTrace varchar(500), @DateTime DateTime
AS

BEGIN TRANSACTION
   INSERT INTO [dbo].[LogExceptions] (Message, StackTrace, DateTime) VALUES (@Message, @StackTrace, @DateTime);
COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spSelectAllItems]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spSelectAllItems]
AS
 select i.Title, i.Url, i.Id as ItemId, u.Name,u.Id as UserID, c.Datetime, c.Cost
from Items as i
join Users as u on i.user_id = u.Id
join Costs as c on c.Item_Id = i.Id

GO
/****** Object:  StoredProcedure [dbo].[spSelectAllItemsUser]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSelectAllItemsUser] @Name varchar(25)
AS
 select i.Title, i.Url, i.Id as ItemId, u.Name,u.Id as UserID, c.Datetime, c.Cost
from Items as i
join Users as u on i.user_id = u.Id
join Costs as c on c.Item_Id = i.Id
where u.Name = @Name

GO
/****** Object:  StoredProcedure [dbo].[spSetNewItem]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSetNewItem] @NameUser varchar(25), @Title varchar(250), @Url varchar(250), @DateTime DateTime, @Cost float
AS
declare @UserId int;
set @UserId = (select Id from [dbo].[Users] where Name = @NameUser);

BEGIN TRANSACTION
   DECLARE @ItemID int;
   INSERT INTO [dbo].[Items] (Title, Url, user_id) VALUES (@Title, @Url, @UserId);
   SELECT @ItemID = scope_identity();
   INSERT INTO [dbo].[Costs] (Cost, DateTime, Item_Id) VALUES (@Cost, @DateTime, @ItemID);
COMMIT

GO
/****** Object:  StoredProcedure [dbo].[spSetUserIfNotExist]    Script Date: 8/13/2018 7:21:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSetUserIfNotExist] @Name varchar(25)
AS
if (select count(*) from [dbo].[Users] where Name = @Name) = 0
 INSERT INTO [dbo].[Users] ([Name])
     VALUES (@Name) 

GO
USE [master]
GO
ALTER DATABASE [WishList] SET  READ_WRITE 
GO
