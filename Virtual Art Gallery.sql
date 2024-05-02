CREATE DATABASE Virtual_Art_Gallery

USE Virtual_Art_Gallery

CREATE TABLE Artists( 
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100)
)

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL
)

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
)

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT
)

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
)

--INSERT VALUES INTO Artists Table

INSERT INTO Artists VALUES (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian')

 SELECT * FROM Artists

 --INSERT VALUES INTO Categories Table

INSERT INTO Categories VALUES (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography')

 SELECT * FROM Categories

  --INSERT VALUES INTO Artworks Table

INSERT INTO Artworks VALUES (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg')

 SELECT * FROM Artworks

   --INSERT VALUES INTO Exhibitions Table

 INSERT INTO Exhibitions VALUES (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.')  SELECT * FROM Exhibitions     --INSERT VALUES INTO ExhibitionArtworks Table INSERT INTO ExhibitionArtworks VALUES(1, 1),
 (1, 2),
 (1, 3),
 (2, 2)  SELECT * FROM ExhibitionArtworks  --TASKS  --1.Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks  SELECT a.Name as name , COUNT(a1.ArtworkID) as Artworks   FROM Artists a  LEFT JOIN Artworks a1 ON a.ArtistID = a1.ArtistID  GROUP BY name  ORDER BY Artworks DESC  --2.List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order  SELECT a.Title FROM Artworks a  JOIN Artists a1 ON a.ArtistID = a1.ArtistID  WHERE a1.Nationality IN ('Spanish' , 'Dutch')  ORDER BY a.Year DESC --3.Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category SELECT a.Name, COUNT(a1.ArtworkID) as Artwork FROM Artists a  JOIN Artworks a1 ON a.ArtistID = a1.ArtistID JOIN Categories c ON c.CategoryID = a1.CategoryID WHERE c.Name = 'Painting'  GROUP BY a.Name --4.List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories SELECT Artworks.Title, Artists.Name, Categories.Name FROM Artworks JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID JOIN Exhibitions ON Exhibitions.ExhibitionID = ExhibitionArtworks.ExhibitionID JOIN Categories ON Categories.CategoryID = Artworks.CategoryID JOIN Artists ON Artists.ArtistID = Artworks.ArtistID WHERE Exhibitions.Title = 'Modern Art Masterpieces' --5.Find the artists who have more than two artworks in the gallery SELECT a.Name, COUNT(a1.ArtworkID) as Arts FROM Artists a JOIN Artworks a1 ON a.ArtistID = a1.ArtistID GROUP BY a.Name HAVING COUNT(a1.ArtworkID) > 2 --6.Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions SELECT Artworks.Title 
 FROM Artworks 
 JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID 
 JOIN Exhibitions ON Exhibitions.ExhibitionID = ExhibitionArtworks.ExhibitionID 
 WHERE Exhibitions.Title = 'Modern Art Masterpieces'
 AND Artworks.ArtworkID IN (
 SELECT ArtworkID FROM ExhibitionArtworks 
 JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID 
 WHERE Exhibitions.Title = 'Renaissance Art')

 --7.Find the total number of artworks in each category
 SELECT c.Name, COUNT(a.ArtworkID) as Arts FROM Artworks a
 JOIN Categories c ON a.CategoryID = c.CategoryID
 GROUP BY c.Name

 --8.List artists who have more than 3 artworks in the gallery
 SELECT a.Name, COUNT(a1.ArtworkID) as Arts FROM Artists a
 JOIN Artworks a1 ON a.ArtistID = a1.ArtistID
 GROUP BY a.Name
 HAVING COUNT(a1.ArtworkID) > 3

 --9.Find the artworks created by artists from a specific nationality (e.g., Spanish)
 SELECT Artists.Name From Artists
 JOIN Artworks ON Artists.ArtistID = Artworks.ArtworkID
 WHERE Artists.Nationality = 'Spanish'

 --10.List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci
 SELECT Exhibitions.Title
 FROM Exhibitions
 JOIN ExhibitionArtworks ON Exhibitions.ExhibitionID = ExhibitionArtworks.ExhibitionID
 JOIN Artworks ON ExhibitionArtworks.ArtworkID = Artworks.ArtworkID
 JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
 WHERE Artists.Name = 'Vincent van Gogh'
 AND EXISTS (
 SELECT ExhibitionID
 FROM ExhibitionArtworks
 JOIN Artworks ON ExhibitionArtworks.ArtworkID = Artworks.ArtworkID
 JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
 WHERE Artists.Name = 'Leonardo da Vinci')

 --11.Find all the artworks that have not been included in any exhibition
 SELECT Artworks.Title FROM Artworks
 LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
 WHERE ExhibitionArtworks.ArtworkID IS NULL

 --12.List artists who have created artworks in all available categories
 SELECT Artists.Name FROM Artists 
 WHERE NOT EXISTS(SELECT * FROM Categories 
 WHERE NOT EXISTS(SELECT Artworks.ArtworkID FROM Artworks WHERE 
 Artworks.ArtworkID = Artists.ArtistID AND Artworks.CategoryID = Categories.CategoryID))

 --13.List the total number of artworks in each category
 SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS Arts FROM Artworks
 JOIN Categories ON Categories.CategoryID = Artworks.CategoryID
 GROUP BY Categories.Name

 --14.Find the artists who have more than 2 artworks in the gallery
 SELECT Artists.Name FROM Artists 
 JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
 GROUP BY Artists.Name
 HAVING COUNT(*) > 2

 --15.List the categories with the average year of artworks they contain, only for categories with more than 1 artwork
 SELECT Categories.Name, AVG(Artworks.Year) as [Year]
 FROM Artworks 
 JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
 GROUP BY Categories.Name
 HAVING COUNT(*) > 1

 --16.Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition
 SELECT Artworks.Title FROM Artworks
 JOIN ExhibitionArtworks ON ExhibitionArtworks.ArtworkID = Artworks.ArtworkID
 JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
 WHERE Exhibitions.Title = 'Modern Art Masterpieces'

 --17.Find the categories where the average year of artworks is greater than the average year of all artworks
 SELECT Categories.Name FROM Artworks
 JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
 GROUP BY Categories.Name 
 HAVING AVG(Year) > (SELECT AVG(Year) FROM Artworks)

 --18.List the artworks that were not exhibited in any exhibition
 SELECT Artworks.Title FROM Artworks
 JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
 WHERE ExhibitionArtworks.ArtworkID IS NULL

 --19.Show artists who have artworks in the same category as "Mona Lisa."
 SELECT Artists.Name 
 FROM Artists
 JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
 WHERE Artworks.CategoryID IN (SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa')

 --20.List the names of artists and the number of artworks they have in the gallery.
 SELECT Artists.Name, COUNT(Artworks.ArtworkID) as Tot_Arts FROM Artists
 JOIN Artworks ON Artworks.ArtistID = Artists.ArtistID
 GROUP BY Artists.Name



