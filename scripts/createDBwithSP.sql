USE [master]
GO

CREATE DATABASE [WishList]
 COLLATE Cyrillic_General_CI_AS 
 go
USE [WishList]
GO
/****** Object:  StoredProcedure [dbo].[spAddNewCost]    Script Date: 8/15/2018 11:02:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddNewCost] @Cost decimal, @DateTime datetime,  @item_Id int
AS
insert into [dbo].[Costs] (Cost, DateTime, Item_Id) values (@Cost, @DateTime, @item_Id) 

GO
/****** Object:  StoredProcedure [dbo].[spLogExceptions]    Script Date: 8/15/2018 11:02:24 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spSelectAllItems]    Script Date: 8/15/2018 11:02:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spSelectAllItems]
AS
-- select i.Title, i.Url, i.Id as ItemId, u.Name,u.Id as UserID, c.Datetime, c.Cost
--from Items as i
--join Users as u on i.user_id = u.Id
--join Costs as c on c.Item_Id = i.Id
select * from Users
select * from Items
select * from Costs


GO
/****** Object:  StoredProcedure [dbo].[spSelectAllItemsUser]    Script Date: 8/15/2018 11:02:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSelectAllItemsUser] @Name varchar(25)
AS
declare @userId int
-- select i.Title, i.Url, i.Id as ItemId, u.Name,u.Id as UserID, c.Datetime, c.Cost
--from Items as i
--join Users as u on i.user_id = u.Id
--join Costs as c on c.Item_Id = i.Id
--where u.Name = @Name
select @userId = Id from Users where Name = @Name
select * from Users where Name = @Name
select * from Items where user_id = @userId
select Costs.Cost, Costs.DateTime, Costs.Item_Id from Costs Join Items on Items.Id = Costs.Item_Id

GO
/****** Object:  StoredProcedure [dbo].[spSetNewItem]    Script Date: 8/15/2018 11:02:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSetNewItem] @NameUser varchar(25), @Title varchar(250), @Url varchar(250), @DateTime DateTime, @Cost decimal
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
/****** Object:  StoredProcedure [dbo].[spSetUserIfNotExist]    Script Date: 8/15/2018 11:02:24 AM ******/
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
/****** Object:  Table [dbo].[Costs]    Script Date: 8/15/2018 11:02:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Costs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cost] [decimal] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Item_Id] [int] NOT NULL,
 CONSTRAINT [PK_Costs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Items]    Script Date: 8/15/2018 11:02:24 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LogExceptions]    Script Date: 8/15/2018 11:02:24 AM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 8/15/2018 11:02:24 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vItemsAndCosts]    Script Date: 8/15/2018 11:02:24 AM ******/
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
SET IDENTITY_INSERT [dbo].[Costs] ON 

INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (1, 6728, CAST(0x0000A93B01403D23 AS DateTime), 1)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (3, 5050, CAST(0x0000A93C00032F15 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (4, 400, CAST(0x0000A93C00109EC3 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (5, 6000, CAST(0x0000A93C0012F05B AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (6, 609, CAST(0x0000A93C00FFF858 AS DateTime), 4)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (7, 6051, CAST(0x0000A93D0018EF96 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (8, 6058, CAST(0x0000A93D001ACC60 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (9, 6057, CAST(0x0000A93D00A7BC28 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (10, 6053, CAST(0x0000A93D00A8D65D AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (11, 6055, CAST(0x0000A93D00AE39E4 AS DateTime), 3)
INSERT [dbo].[Costs] ([Id], [Cost], [DateTime], [Item_Id]) VALUES (12, 6050, CAST(0x0000A93D00AECFF7 AS DateTime), 3)
SET IDENTITY_INSERT [dbo].[Costs] OFF
SET IDENTITY_INSERT [dbo].[Items] ON 

INSERT [dbo].[Items] ([Id], [Title], [Url], [user_id]) VALUES (1, N'Матрас Sleep&Fly Organic Epsilon 160х200 см (2012051602001)                                                                                                                                                                                               ', N'https://rozetka.com.ua/sleep_n_fly_2012051602001/p7617158/                                                                                                                                                                                                ', 1)
INSERT [dbo].[Items] ([Id], [Title], [Url], [user_id]) VALUES (3, N'Ноутбук Acer Extensa EX2519-C313 (NX.EFAEU.054) Black                                                                                                                                                                                                     ', N'https://rozetka.com.ua/acer_nx_efaeu_054/p27775593/                                                                                                                                                                                                       ', 1)
INSERT [dbo].[Items] ([Id], [Title], [Url], [user_id]) VALUES (4, N'Сковорода Rondell Weller 20 см (RDA-062)                                                                                                                                                                                                                  ', N'https://rozetka.com.ua/rondell_rda_062/p7706380/                                                                                                                                                                                                          ', 1)
SET IDENTITY_INSERT [dbo].[Items] OFF
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Object reference not set to an instance of an object.                                               ', N'   at PageSupport.SiteParsers.RozetkaParser.GetTitle()
   at Wishlist.Controllers.ItemsController.<Set>d__2.MoveNext() in C:\work\homeWork\Wishlist\Controllers\ItemsController.cs:line 41                                                                                                                                                                                                                                                                                                                         ', CAST(0x0000A93B01120529 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The remote name could not be resolved: ''rozetka.com.ua''                                             ', N'   at System.Net.HttpWebRequest.GetResponse()
   at PageSupport.Services.PageService.GetPageHtml(String url)                                                                                                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93C0096029F AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The remote name could not be resolved: ''rozetka.com.ua''                                             ', N'   at System.Net.HttpWebRequest.GetResponse()
   at PageSupport.Services.PageService.GetPageHtml(String url)                                                                                                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93C0096029F AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The remote name could not be resolved: ''rozetka.com.ua''                                             ', N'   at System.Net.HttpWebRequest.GetResponse()
   at PageSupport.Services.PageService.GetPageHtml(String url)                                                                                                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93C009647C9 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The remote name could not be resolved: ''rozetka.com.ua''                                             ', N'   at System.Net.HttpWebRequest.GetResponse()
   at PageSupport.Services.PageService.GetPageHtml(String url)                                                                                                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93C009647C9 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The SMTP server requires a secure connection or the client was not authenticated. The server respons', N'   at System.Net.Mail.MailCommand.CheckResponse(SmtpStatusCode statusCode, String response)
   at System.Net.Mail.MailCommand.Send(SmtpConnection conn, Byte[] command, MailAddress from, Boolean allowUnicode)
   at System.Net.Mail.SmtpTransport.SendMail(MailAddress sender, MailAddressCollection recipients, String deliveryNotify, Boolean allowUnicode, SmtpFailedRecipientException& exception)
   at System.Net.Mail.SmtpClient.Send(MailMessage message)
   at ProductUpdaterService.Jobs.PriceCheckJ', CAST(0x0000A93D00772059 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'The SMTP server requires a secure connection or the client was not authenticated. The server respons', N'   at System.Net.Mail.MailCommand.CheckResponse(SmtpStatusCode statusCode, String response)
   at System.Net.Mail.MailCommand.Send(SmtpConnection conn, Byte[] command, MailAddress from, Boolean allowUnicode)
   at System.Net.Mail.SmtpTransport.SendMail(MailAddress sender, MailAddressCollection recipients, String deliveryNotify, Boolean allowUnicode, SmtpFailedRecipientException& exception)
   at System.Net.Mail.SmtpClient.Send(MailMessage message)
   at ProductUpdaterService.Jobs.PriceCheckJ', CAST(0x0000A93D0077F71F AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F3 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F3 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCC AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCD AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D008250F4 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCE AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCD AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCE AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCD AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCC AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCE AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE34 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE36 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCD AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE36 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE36 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C505 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCD AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00827FCE AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE36 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082AE35 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C505 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C505 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 22                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D0082C506 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EED AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EED AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EED AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EEF AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EEF AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
INSERT [dbo].[LogExceptions] ([Message], [StackTrace], [DateTime]) VALUES (N'Specified cast is not valid.                                                                        ', N'   at System.Data.SqlClient.SqlBuffer.get_Single()
   at DBSupport.entities.PriceEntity.CreateFromReader(SqlDataReader reader) in C:\work\homeWork\DBSupport\entities\PriceEntity.cs:line 24                                                                                                                                                                                                                                                                                                                       ', CAST(0x0000A93D00841EF0 AS DateTime))
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Name]) VALUES (1, N'roman.kirpa              ')
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Items__2E29F741C36B69D9]    Script Date: 8/15/2018 11:02:24 AM ******/
ALTER TABLE [dbo].[Items] ADD UNIQUE NONCLUSTERED 
(
	[Url] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Users__737584F603A4A383]    Script Date: 8/15/2018 11:02:24 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Costs]  WITH CHECK ADD FOREIGN KEY([Item_Id])
REFERENCES [dbo].[Items] ([Id])
GO
ALTER TABLE [dbo].[Items]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([Id])
GO
USE [master]
GO
ALTER DATABASE [WishList] SET  READ_WRITE 
GO
