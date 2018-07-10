USE [master]
GO
/****** Object:  Database [WishList]    Script Date: 2018-07-10 4:12:56 PM ******/
CREATE DATABASE [WishList]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WishList', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WishList.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WishList_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WishList_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [WishList] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WishList].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WishList] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WishList] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WishList] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WishList] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WishList] SET ARITHABORT OFF 
GO
ALTER DATABASE [WishList] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WishList] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WishList] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WishList] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WishList] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WishList] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WishList] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WishList] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WishList] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WishList] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WishList] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WishList] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WishList] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WishList] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WishList] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WishList] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WishList] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WishList] SET RECOVERY FULL 
GO
ALTER DATABASE [WishList] SET  MULTI_USER 
GO
ALTER DATABASE [WishList] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WishList] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WishList] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WishList] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WishList] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'WishList', N'ON'
GO
ALTER DATABASE [WishList] SET QUERY_STORE = OFF
GO
USE [WishList]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [WishList]
GO
/****** Object:  Table [dbo].[Costs]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  Table [dbo].[Items]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  View [dbo].[vItemsAndCosts]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spAddNewCost]    Script Date: 2018-07-10 4:12:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddNewCost] @Cost float, @DateTime datetime,  @item_Id int
AS
insert into [dbo].[Costs] (Cost, DateTime, Item_Id) values (@Cost, @DateTime, @item_Id) 
GO
/****** Object:  StoredProcedure [dbo].[spSelectAllItems]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spSelectAllItemsUser]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spSetNewItem]    Script Date: 2018-07-10 4:12:56 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spSetUserIfNotExist]    Script Date: 2018-07-10 4:12:56 PM ******/
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
