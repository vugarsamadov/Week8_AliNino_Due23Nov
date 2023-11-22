CREATE DATABASE AliNINOVugar;

USE AliNINOVugar;


-- SoftDelete Triggers Start

CREATE TRIGGER SoftDeleteBooks
    ON Books
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Books
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeletePublishingHouses
    ON PublishingHouses
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE PublishingHouses
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteBindings
    ON Bindings
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Bindings
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteCategories
    ON Categories
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Categories
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteAuthors
    ON Authors
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Authors
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteGenres
    ON Genres
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Genres
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteLanguages
    ON Languages
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Languages
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

CREATE TRIGGER SoftDeleteComments
    ON Comments
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Comments
        SET IsDeleted = 1
        WHERE Id IN (Select Id from deleted)
    END;

-- SoftDelete Triggers END

-- Create Tables Start

create table PublishingHouses
(
	Id int identity primary key,
	Title nvarchar(25),
	IsDeleted bit DEFAULT 'false'
);

create table Bindings
(
	Id int identity primary key,
	Title nvarchar(10),
	IsDeleted bit DEFAULT 'false'
);

create table Categories
(
	Id int identity primary key,
	Title nvarchar(25),
	ParentCategory int references Categories(Id),
	IsDeleted bit DEFAULT 'false'
);

create table Books
(
	Id int identity primary key,
	Title nvarchar(80) NOT NULL,
	Description nvarchar(250)  DEFAULT 'No description given.',
	ActualPrice money  NOT NULL,
	DiscountPrice money NOT NULL,
	PublisherHouseId int REFERENCES PublishingHouses(Id),
	StockCount int,
	ArticleCode char(10),
	BindingId int REFERENCES Bindings(Id),
	PageCount int NOT NULL,
	CategoryId int REFERENCES Categories(Id),
	IsDeleted bit DEFAULT 'false'
);

create table Authors
(
	Id int identity primary key,
	Name nvarchar(25) NOT NULL,
	Surname nvarchar(25),
	IsDeleted bit DEFAULT 'false'
);

create table BookAuthors
(
	Id int identity primary key,
	BookId int references Books(Id),
	AuthorId int references Authors(Id)
);

create table Genres
(
	Id int identity primary key,
	Title nvarchar(25),
	IsDeleted bit DEFAULT 'false'
);

create table Languages
(
	Id int identity primary key,
	Title nvarchar(25),
	IsDeleted bit DEFAULT 'false'
);

create table BooksLanguages
(
	Id int identity primary key,
	BookId int references Books(Id),
	LanguageId int references Languages(Id)
);

create table Comments
(
	Id int identity primary key,
	Description nvarchar(250),
	BookId int references Books(Id),
	Rating tinyint CHECK(Rating BETWEEN 0 AND 5),
	Name nvarchar(25) NOT NULL,
	Email nvarchar(25) NOT NULL,
	ImageUrl nvarchar(max),
	IsDeleted bit DEFAULT 'false'
);

-- Create Tables End

-- UPDATE PROCEDURES START

CREATE PROCEDURE UpdateGenre
@Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Genres
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateLanguage
@Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Languages
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdatePublishingHouses
@Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE PublishingHouses
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateBinding
@Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Bindings
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateAuthor
@Id int, @Name nvarchar(25),@Surname nvarchar(25)
AS
BEGIN
	UPDATE Authors
	SET Name = @Name, Surname = @Surname
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateCategory
@Id int, @Title nvarchar(25), @ParentCategory int
AS
BEGIN
    IF NOT(@Id = @ParentCategory)
        BEGIN
	        UPDATE Categories
	        SET Title = @Title, ParentCategory = @ParentCategory
	        WHERE Id = @Id
        END
END;

-- UPDATE PROCEDURES END



-- INSERT ALL DATA PROC START

ALTER procedure InsertInitialData
AS
BEGIN

    INSERT INTO PublishingHouses (Title) VALUES
('Hedef nesriyyat'),
('Klan'),
('WestEast'),
('Booker'),
('Block');

    INSERT INTO Bindings (Title) VALUES
('Hardcover'),
('Paperback'),
('E-book'),
('Audiobook'),
('Spiraly');

    INSERT INTO Categories (Title, ParentCategory) VALUES
('Fiction', NULL),
('Non-fiction', NULL),
('Science Fiction', 1),
('Fantasy', 1),
('History', 2),
('Biography', 2),
('Thriller', 1),
('Romance', 1),
('Historical Fiction', 1),
('Memoir', 2);

    INSERT INTO Books (Title, Description, ActualPrice, DiscountPrice, PublisherHouseId, StockCount, ArticleCode, BindingId, PageCount, CategoryId) VALUES
('The Lord of the Rings', 'An epic fantasy novel by Tolkien', 29.99, 19.99, 1, 100, 'XX7789jH', 1, 1178, 4),
('1984', 'Adystopian novel by George Orwell', 14.99, 9.99, 2, 50, '878JJ75F', 2, 328, 3),
('Becoming', 'A memoir by Micelle Obama', 24.99, 14.99, 3, 75, 'BEC567', 3, 426, 10),
('The Da Vinci Code', 'A thriller novel by Saddam Brown', 19.99, 12.99, 4, 80, 'DVC789', 2, 454, 7),
('The Hunger Games', 'A dystopian novel by someone', 34.99, 11.99, 5, 60, 'HG456', 2, 374, 3);

    INSERT INTO Authors (Name, Surname) VALUES
('J.R.R.', 'Tolkien'),
('George', 'Orwell'),
('Michelle', 'Obama'),
('Dan', 'Brown'),
('Suzanne', 'Collins');

    INSERT INTO BookAuthors (BookId, AuthorId) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

    INSERT INTO Genres (Title) VALUES
('Adventure'),
('Mystery'),
('Drama'),
('Horror'),
('Comedy');

    INSERT INTO Languages (Title) VALUES
('English'),
('French'),
('Spanish'),
('German'),
('Chinese');

    INSERT INTO BooksLanguages (BookId, LanguageId) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 1),
(3, 5),
(4, 1),
(4, 2),
(5, 1);
    
    INSERT INTO Comments (Description, BookId, Rating, Name, Email, ImageUrl) 
    VALUES ('Good book', 1, 5, 'Vugar', 'vugar@gmail.com', 'https://imgur.com/abc123.jpg'),
           ('Nope', 4, 1, 'Bob', 'bob@hotmail.com', 'https://imgur.com/abc123.jpg'),
           ('Meh', 3, 3, 'Saddam', 'saddam@yahoo.com', 'https://imgur.com/abc123.jpg'),
           ('Great book', 2, 5, 'Hamid', 'hamid@outlook.com', 'https://imgur.com/abc123.jpg'),
           ('The worse book ever', 5, 1, 'Elon', 'elon@gmail.com', 'https://imgur.com/abc123.jpg');

END

