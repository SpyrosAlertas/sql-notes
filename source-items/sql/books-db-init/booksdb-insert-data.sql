
USE BOOKSDB;

--
-- Dumping data for table `author`
--
INSERT INTO `author`
	(FIRST_NAME, LAST_NAME, BIRTHDAY, DEATHDAY)
VALUES
	('Stephen', 'King', '1947-09-21', null), ('Joanne', 'Rowling', '1965-07-31', null), ('George', 'Orwell', '1903-06-25', '1950-01-25'), ('Agatha', 'Christie', '1890-09-15', '1976-01-12'), ('Charles', 'Dickens', '1812-02-7', '1870-06-09'),
    ('Jane', 'Austen', '1775-12-16', '1817-06-18'), ('Sebastian', 'Fitzek', '1971-10-13', null), ('Sarah', 'Pinborough', '1972-03-28', null), ('Dan', 'Brown', '1964-06-22', null), ('Virginia', 'Woolf', '1882-01-25', '1941-03-28'),
    ('Edgar Allan', 'Poe', '1809-01-19', '1849-10-7'), ('Emily', 'Bronte', '1818-06-30', '1848-12-19'), ('Napoleon', 'Hill', '1883-10-26', '1970-11-8'), ('Harper', 'Lee', '1926-04-28', '2016-02-19'), ('Howard Phillips', 'Lovecraft', '1890-08-20', '1937-03-15'),
    ('Charlotte', 'Bronte', '1816-04-21', '1855-03-31'), ('Milan', 'Kundera', '1929-04-01', '2023-06-11'), ('Margaret', 'Atwood', '1939-11-18', null),
    ('J.R.R.', 'Tolkien', '1892-01-03', '1973-09-02'), ('Niccolo', 'Machiavelli', '1469-05-03', '1527-06-21'), ('Dante', 'Alighieri', '1265-05-22', '1321-09-14')
;

--
-- Dumping data for table `book`
--
INSERT INTO `book`
	(title, release_year, book_language, author_id)
VALUES
	('IT', '1986', 'English', 1), ('Behind Her Eyes', '2016', 'English', 8), ('The Unbearable Lightness of Being', '1984', 'French', 17), ('1408', '1999', 'English', 1), ('Outwitting The Devil', '2011', 'English', 13),
    ('Therapy', '2006', 'German', 7), ('The Da Vinci Code', '2003', 'English', 9), ('Think and Grow Rich', '1937', 'English', 13), ('A Christmas Carol', '1843', 'English', 5), ('The Package', '2016', 'German', 7),
    ('The Handmaid\'s Tail', '1985', 'English', 18), ('Animal Farm', '1945', 'English', 3), ('Wuthering Heights', '1847', 'English', 12), ('The Call of Cthulhu', '1928', 'English', 15), ('The Outsider', '1926', 'English', 15),
    ('Oliver Twist', '1838', 'English', 5), ('The Green Mile', '1996', 'English', 1), ('The Nightwalker', '2013', 'German', 7), ('Dagon', '1919', 'English', 15), ('Jane Eyre', '1847', 'English', 16),
    ('Villette', '1853', 'English', 16), ('The Lost Symbol', '2009', 'English', 9), ('The Whisperer In Darkness', '1931', 'English', 15), ('Great Expectations', '1861', 'English', 5), ('Azaloth', '1938', 'English', 15),
    ('The Dunwich Horror', '1929', 'English', 15), ('Paradiso', '1321', 'Italian', 21), ('The Shadow Over Innsmouth', '1936', 'English', 15), ('The Professor', '1857', 'English', 16), ('Misery', '1987', 'English', 1),
    ('The Nameless City', '1921', 'English', 15), ('Nineteen Eighty-Four', '1949', 'English', 3), ('The Mist', '1980', 'English', 1), ('Inferno', '1314', 'Italian', 21), ('Purgatorio', '1318', 'Italian', 21),
    ('Pride and Prejudice', '1813', 'English', '6'), ('The Terrible Old Man', '1921', 'English', 15), ('Berenice', '1835', 'English', 11), ('Angels and Demons', '2000', 'English', 9), ('The Raven', '1845', 'English', '11'),
    ('The Cats of Ulthar', '1920', 'English', 15), ('Harry Potter and the Philosopher\'s Stone', '1997', 'English', 2), ('Murder on the Orient Express', '1934', 'English', 4), ('The Murders in the Rue Morgue', '1841', 'English', '11'), ('The Lord of the Rings: The Fellowship of the Ring', '1954', 'English', '19'),
    ('Harry Potter and the Prisoner of Azkaban', '1999', 'English', 2), ('Harry Potter and the Half-Blood Prince', '2005', 'English', '2'), ('The Fall of the House of Usher', '1839', 'English', '11'), ('Death on the Nile', '1937', 'English', 4), ('The Lord of the Rings: The Two Rings', '1954', 'English', '19'), 
    ('Necronomicon: The Best Weird Tales of H.P. Lovecraft', '2008', 'English', '15'), ('Eldritch Tales: A Miscellany of the Macabre', '2011', 'English', '15'), ('Morella', '1835', 'English', '11'), ('Nemesis', '1971', 'English', 4), ('Harry Potter and the Order of the Phoenix', '2003', 'English', '2'),
    ('The Lord of the Rings: The Return of the King', '1955', 'English', '19'), ('Harry Potter and the Chamber of Secrets', '1998', 'English', 2), ('The Hobbit', '1937', 'English', '19'), ('Ordeal By Innocence', '1958', 'English', 4), ('Harry Potter and the Deathly Hallows', '2007', 'English', '2'),
    ('To Kill a Mockingbird', '1960', 'English', '14'), ('Harry Potter and the Goblet of Fire', '2000', 'English', 2), ('The Black Cat', '1843', 'English', 11), ('Tales of the Macabre', '2012', 'English', 11), ('The Art of War', '1521', 'English', 20),
    ('At the Mountains of Madness', '1931', 'English', '15'), ('The Shadow Out of Time', '1935', 'English', '15'), ('The SQL Cook Book', 2020, 'English', null), ('Novel Nook Murders', '2017', 'English', null)
;

COMMIT;





