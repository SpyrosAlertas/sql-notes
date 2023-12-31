
DROP DATABASE IF EXISTS BOOKSDB;
CREATE DATABASE BOOKSDB;

USE BOOKSDB;

--
-- Table structure for table `author`
--
CREATE TABLE AUTHOR (
	AUTHOR_ID INT AUTO_INCREMENT,
    FIRST_NAME VARCHAR(50) NOT NULL,
    LAST_NAME VARCHAR(50),
    BIRTHDAY DATE NOT NULL,
    DEATHDAY DATE,
    PRIMARY KEY (AUTHOR_ID),
    UNIQUE (FIRST_NAME, LAST_NAME)
);

--
-- Table structure for table `book`
--
CREATE TABLE BOOK (
	BOOK_ID INT AUTO_INCREMENT,
    TITLE VARCHAR(100) NOT NULL UNIQUE,
    RELEASE_YEAR INT NOT NULL,
    BOOK_LANGUAGE VARCHAR(25) NOT NULL,
    AUTHOR_ID INT,
    PRIMARY KEY (BOOK_ID),
    FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHOR (AUTHOR_ID)
);

--
-- Table structure for table `genre`
--
CREATE TABLE GENRE (
	GENRE_ID INT AUTO_INCREMENT,
	NAME VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (GENRE_ID)
);

--
-- Table structure for table `book_genre`
--
CREATE TABLE BOOK_GENRE (
	BOOK_ID INT,
    GENRE_ID INT,
	PRIMARY KEY (BOOK_ID, GENRE_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK (BOOK_ID),
    FOREIGN KEY (GENRE_ID) REFERENCES GENRE (GENRE_ID)
);



