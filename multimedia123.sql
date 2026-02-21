

CREATE DATABASE multimedia_project123;



USE multimedia_project123;

CREATE TABLE User (
    User_ID INT NOT NULL AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL, 
    Email VARCHAR(100) UNIQUE,
    Join_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (User_ID)
);


CREATE TABLE Tag (
    Tag_ID INT NOT NULL AUTO_INCREMENT,
    Tag_Name VARCHAR(100) NOT NULL UNIQUE,
    Creation_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Tag_ID)
);


CREATE TABLE Image (
    Image_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL, 
    Resolution VARCHAR(20),          
    Description TEXT,
    PRIMARY KEY (Image_ID)
);


CREATE TABLE Audio (
    Audio_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL,
    Duration TIME,                   
    Artist VARCHAR(100),
    Genre VARCHAR(50),
    PRIMARY KEY (Audio_ID)
);

CREATE TABLE Video (
    Video_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL,
    Duration TIME,
    Codec VARCHAR(50),               
    Director VARCHAR(100),
    PRIMARY KEY (Video_ID)
);


CREATE TABLE Media_Tag (
    Tag_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL, 
    
    PRIMARY KEY (Media_ID, Media_Type, Tag_ID),
    
    -- Foreign Key to Tag table
    FOREIGN KEY (Tag_ID) REFERENCES Tag (Tag_ID)
    
);

CREATE TABLE View_History (
    History_ID INT NOT NULL AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL,
    View_Time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (History_ID),
    
    
    FOREIGN KEY (User_ID) REFERENCES User (User_ID)
);

CREATE TABLE Media_Rating (
    Rating_ID INT NOT NULL AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL,
    Rating_Value TINYINT NOT NULL CHECK (Rating_Value BETWEEN 1 AND 5), -- Rating from 1 to 5
    Rated_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (Rating_ID),
    
    UNIQUE KEY (User_ID, Media_ID, Media_Type),
    
    
    FOREIGN KEY (User_ID) REFERENCES User (User_ID)
);


START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('flower');


SET @FlowerTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'flower');


COMMIT;


INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Flower Image 01', 'images/0001.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 02', 'images/0002.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 03', 'images/0003.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 04', 'images/0004.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 05', 'images/0005.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 06', 'images/0006.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 07', 'images/0007.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 08', 'images/0008.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 09', 'images/0009.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 10', 'images/0010.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 11', 'images/0011.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 12', 'images/0012.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 13', 'images/0013.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 14', 'images/0014.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 15', 'images/0015.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 16', 'images/0016.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 17', 'images/0017.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 18', 'images/0018.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 19', 'images/0019.png', '1920x1080', 'A flower photo from Kaggle.'),
('Flower Image 20', 'images/0020.png', '1920x1080', 'A flower photo from Kaggle.');



INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @FlowerTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/0001.png', 'images/0002.png', 'images/0003.png', 'images/0004.png',
        'images/0005.png', 'images/0006.png', 'images/0007.png', 'images/0008.png',
        'images/0009.png', 'images/0010.png', 'images/0011.png', 'images/0012.png',
        'images/0013.png', 'images/0014.png', 'images/0015.png', 'images/0016.png',
        'images/0017.png', 'images/0018.png', 'images/0019.png', 'images/0020.png'
    );
    

START TRANSACTION;


INSERT IGNORE INTO Tag (Tag_Name) VALUES ('bike');
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('vehicle'); -- Adding a broad tag too


SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');


COMMIT;


INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Bike Image 01', 'images/bike_001.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 02', 'images/bike_002.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 03', 'images/bike_003.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 04', 'images/bike_004.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 05', 'images/bike_005.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 06', 'images/bike_006.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 07', 'images/bike_007.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 08', 'images/bike_008.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 09', 'images/bike_009.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 10', 'images/bike_010.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 11', 'images/bike_011.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 12', 'images/bike_012.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 13', 'images/bike_013.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 14', 'images/bike_014.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 15', 'images/bike_015.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 16', 'images/bike_016.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 17', 'images/bike_017.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 18', 'images/bike_018.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 19', 'images/bike_019.bmp', '1920x1080', 'A bike photo from Kaggle.'),
('Bike Image 20', 'images/bike_020.bmp', '1920x1080', 'A bike photo from Kaggle.');


SET @BikePathsList = 
    "'images/bike_001.bmp', 'images/bike_002.bmp', 'images/bike_003.bmp', 'images/bike_004.bmp', 
     'images/bike_005.bmp', 'images/bike_006.bmp', 'images/bike_007.bmp', 'images/bike_008.bmp', 
     'images/bike_009.bmp', 'images/bike_010.bmp', 'images/bike_011.bmp', 'images/bike_012.bmp', 
     'images/bike_013.bmp', 'images/bike_014.bmp', 'images/bike_015.bmp', 'images/bike_016.bmp', 
     'images/bike_017.bmp', 'images/bike_018.bmp', 'images/bike_019.bmp', 'images/bike_020.bmp'";

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @BikeTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/bike_001.bmp', 'images/bike_002.bmp', 'images/bike_003.bmp', 'images/bike_004.bmp',
        'images/bike_005.bmp', 'images/bike_006.bmp', 'images/bike_007.bmp', 'images/bike_008.bmp',
        'images/bike_009.bmp', 'images/bike_010.bmp', 'images/bike_011.bmp', 'images/bike_012.bmp',
        'images/bike_013.bmp', 'images/bike_014.bmp', 'images/bike_015.bmp', 'images/bike_016.bmp',
        'images/bike_017.bmp', 'images/bike_018.bmp', 'images/bike_019.bmp', 'images/bike_020.bmp'
    );

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @VehicleTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/bike_001.bmp', 'images/bike_002.bmp', 'images/bike_003.bmp', 'images/bike_004.bmp',
        'images/bike_005.bmp', 'images/bike_006.bmp', 'images/bike_007.bmp', 'images/bike_008.bmp',
        'images/bike_009.bmp', 'images/bike_010.bmp', 'images/bike_011.bmp', 'images/bike_012.bmp',
        'images/bike_013.bmp', 'images/bike_014.bmp', 'images/bike_015.bmp', 'images/bike_016.bmp',
        'images/bike_017.bmp', 'images/bike_018.bmp', 'images/bike_019.bmp', 'images/bike_020.bmp'
    );
    
    
    

START TRANSACTION;


INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle');


SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');


COMMIT;


INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Car Image 01', 'images/carsgraz_001.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 02', 'images/carsgraz_002.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 03', 'images/carsgraz_003.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 04', 'images/carsgraz_004.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 05', 'images/carsgraz_005.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 06', 'images/carsgraz_006.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 07', 'images/carsgraz_007.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 08', 'images/carsgraz_008.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 09', 'images/carsgraz_009.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 10', 'images/carsgraz_010.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 11', 'images/carsgraz_011.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 12', 'images/carsgraz_012.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 13', 'images/carsgraz_013.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 14', 'images/carsgraz_014.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 15', 'images/carsgraz_015.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 16', 'images/carsgraz_016.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 17', 'images/carsgraz_017.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 18', 'images/carsgraz_018.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 19', 'images/carsgraz_019.bmp', '1920x1080', 'A car photo from Kaggle.'),
('Car Image 20', 'images/carsgraz_020.bmp', '1920x1080', 'A car photo from Kaggle.');


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @CarTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/carsgraz_001.bmp', 'images/carsgraz_002.bmp', 'images/carsgraz_003.bmp', 'images/carsgraz_004.bmp',
        'images/carsgraz_005.bmp', 'images/carsgraz_006.bmp', 'images/carsgraz_007.bmp', 'images/carsgraz_008.bmp',
        'images/carsgraz_009.bmp', 'images/carsgraz_010.bmp', 'images/carsgraz_011.bmp', 'images/carsgraz_012.bmp',
        'images/carsgraz_013.bmp', 'images/carsgraz_014.bmp', 'images/carsgraz_015.bmp', 'images/carsgraz_016.bmp',
        'images/carsgraz_017.bmp', 'images/carsgraz_018.bmp', 'images/carsgraz_019.bmp', 'images/carsgraz_020.bmp'
    );


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @VehicleTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/carsgraz_001.bmp', 'images/carsgraz_002.bmp', 'images/carsgraz_003.bmp', 'images/carsgraz_004.bmp',
        'images/carsgraz_005.bmp', 'images/carsgraz_006.bmp', 'images/carsgraz_007.bmp', 'images/carsgraz_008.bmp',
        'images/carsgraz_009.bmp', 'images/carsgraz_010.bmp', 'images/carsgraz_011.bmp', 'images/carsgraz_012.bmp',
        'images/carsgraz_013.bmp', 'images/carsgraz_014.bmp', 'images/carsgraz_015.bmp', 'images/carsgraz_016.bmp',
        'images/carsgraz_017.bmp', 'images/carsgraz_018.bmp', 'images/carsgraz_019.bmp', 'images/carsgraz_020.bmp'
    );
    
    
    
    
    INSERT INTO User (Username, Password_Hash, Email) VALUES
('alice_tester', '$2b$12$D25z7Q2Hl8K/T5J/P4sXo.4q7y8v/2f/B6F7G8H9I0', 'alice@example.com'),
('bob_searcher', '$2b$12$E36a8R3I9L9U6K/Q5t.Yp.5r8w/3g/C7G8H9I0J1', 'bob@example.com');


SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');



SET @ImageID_Flower = 1;
SET @ImageID_Car = 21; 




SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');


SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');
SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');
SET @VideoID_SQL = (SELECT Video_ID FROM Video WHERE Title = 'Beginner SQL Tutorial');





SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');
SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');

INSERT INTO View_History (User_ID, Media_ID, Media_Type) VALUES 
(@AliceID, @ImageID_Flower, 'Image'),         
(@BobID, @ImageID_Car, 'Image'),              
(@AliceID, @ImageID_Car, 'Image');            


INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),      
(@BobID, @ImageID_Car, 'Image', 3),           
(@BobID, @ImageID_Flower, 'Image', 4);        



START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal');

SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Cat Image 01', 'images/cat.1.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 02', 'images/cat.2.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 03', 'images/cat.3.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 04', 'images/cat.4.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 05', 'images/cat.5.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 06', 'images/cat.6.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 07', 'images/cat.7.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 08', 'images/cat.8.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 09', 'images/cat.9.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 10', 'images/cat.10.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 11', 'images/cat.11.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 12', 'images/cat.12.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 13', 'images/cat.13.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 14', 'images/cat.14.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 15', 'images/cat.15.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 16', 'images/cat.16.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 17', 'images/cat.17.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 18', 'images/cat.18.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 19', 'images/cat.19.jpg', '1920x1080', 'A cat photo from Kaggle.'),
('Cat Image 20', 'images/cat.20.jpg', '1920x1080', 'A cat photo from Kaggle.');






INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @CatTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/cat.1.jpg', 'images/cat.2.jpg', 'images/cat.3.jpg', 'images/cat.4.jpg',
        'images/cat.5.jpg', 'images/cat.6.jpg', 'images/cat.7.jpg', 'images/cat.8.jpg',
        'images/cat.9.jpg', 'images/cat.10.jpg', 'images/cat.11.jpg', 'images/cat.12.jpg',
        'images/cat.13.jpg', 'images/cat.14.jpg', 'images/cat.15.jpg', 'images/cat.16.jpg',
        'images/cat.17.jpg', 'images/cat.18.jpg', 'images/cat.19.jpg', 'images/cat.20.jpg'
    );


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @AnimalTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/cat.1.jpg', 'images/cat.2.jpg', 'images/cat.3.jpg', 'images/cat.4.jpg',
        'images/cat.5.jpg', 'images/cat.6.jpg', 'images/cat.7.jpg', 'images/cat.8.jpg',
        'images/cat.9.jpg', 'images/cat.10.jpg', 'images/cat.11.jpg', 'images/cat.12.jpg',
        'images/cat.13.jpg', 'images/cat.14.jpg', 'images/cat.15.jpg', 'images/cat.16.jpg',
        'images/cat.17.jpg', 'images/cat.18.jpg', 'images/cat.19.jpg', 'images/cat.20.jpg'
    );
    
    

START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal');

SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

-- Commit setup changes
COMMIT;


INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Dog Image 01', 'images/dog.1.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 02', 'images/dog.2.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 03', 'images/dog.3.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 04', 'images/dog.4.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 05', 'images/dog.5.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 06', 'images/dog.6.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 07', 'images/dog.7.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 08', 'images/dog.8.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 09', 'images/dog.9.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 10', 'images/dog.10.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 11', 'images/dog.11.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 12', 'images/dog.12.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 13', 'images/dog.13.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 14', 'images/dog.14.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 15', 'images/dog.15.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 16', 'images/dog.16.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 17', 'images/dog.17.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 18', 'images/dog.18.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 19', 'images/dog.19.jpg', '1920x1080', 'A dog photo from Kaggle.'),
('Dog Image 20', 'images/dog.20.jpg', '1920x1080', 'A dog photo from Kaggle.');


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @DogTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/dog.1.jpg', 'images/dog.2.jpg', 'images/dog.3.jpg', 'images/dog.4.jpg',
        'images/dog.5.jpg', 'images/dog.6.jpg', 'images/dog.7.jpg', 'images/dog.8.jpg',
        'images/dog.9.jpg', 'images/dog.10.jpg', 'images/dog.11.jpg', 'images/dog.12.jpg',
        'images/dog.13.jpg', 'images/dog.14.jpg', 'images/dog.15.jpg', 'images/dog.16.jpg',
        'images/dog.17.jpg', 'images/dog.18.jpg', 'images/dog.19.jpg', 'images/dog.20.jpg'
    );

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @AnimalTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/dog.1.jpg', 'images/dog.2.jpg', 'images/dog.3.jpg', 'images/dog.4.jpg',
        'images/dog.5.jpg', 'images/dog.6.jpg', 'images/dog.7.jpg', 'images/dog.8.jpg',
        'images/dog.9.jpg', 'images/dog.10.jpg', 'images/dog.11.jpg', 'images/dog.12.jpg',
        'images/dog.13.jpg', 'images/dog.14.jpg', 'images/dog.15.jpg', 'images/dog.16.jpg',
        'images/dog.17.jpg', 'images/dog.18.jpg', 'images/dog.19.jpg', 'images/dog.20.jpg'
    );
    
    
START TRANSACTION;


INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal');

SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');


COMMIT;

INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Horse Image 01', 'images/horse-1.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 02', 'images/horse-2.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 03', 'images/horse-3.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 04', 'images/horse-4.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 05', 'images/horse-5.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 06', 'images/horse-6.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 07', 'images/horse-7.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 08', 'images/horse-8.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 09', 'images/horse-9.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 10', 'images/horse-10.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 11', 'images/horse-11.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 12', 'images/horse-12.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 13', 'images/horse-13.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 14', 'images/horse-14.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 15', 'images/horse-15.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 16', 'images/horse-16.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 17', 'images/horse-17.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 18', 'images/horse-18.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 19', 'images/horse-19.jpg', '1920x1080', 'A horse photo from Kaggle.'),
('Horse Image 20', 'images/horse-20.jpg', '1920x1080', 'A horse photo from Kaggle.');


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @HorseTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/horse-1.jpg', 'images/horse-2.jpg', 'images/horse-3.jpg', 'images/horse-4.jpg',
        'images/horse-5.jpg', 'images/horse-6.jpg', 'images/horse-7.jpg', 'images/horse-8.jpg',
        'images/horse-9.jpg', 'images/horse-10.jpg', 'images/horse-11.jpg', 'images/horse-12.jpg',
        'images/horse-13.jpg', 'images/horse-14.jpg', 'images/horse-15.jpg', 'images/horse-16.jpg',
        'images/horse-17.jpg', 'images/horse-18.jpg', 'images/horse-19.jpg', 'images/horse-20.jpg'
    );

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @AnimalTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/horse-1.jpg', 'images/horse-2.jpg', 'images/horse-3.jpg', 'images/horse-4.jpg',
        'images/horse-5.jpg', 'images/horse-6.jpg', 'images/horse-7.jpg', 'images/horse-8.jpg',
        'images/horse-9.jpg', 'images/horse-10.jpg', 'images/horse-11.jpg', 'images/horse-12.jpg',
        'images/horse-13.jpg', 'images/horse-14.jpg', 'images/horse-15.jpg', 'images/horse-16.jpg',
        'images/horse-17.jpg', 'images/horse-18.jpg', 'images/horse-19.jpg', 'images/horse-20.jpg'
    );

START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('rider'), ('human');

SET @RiderTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'rider');
SET @HumanTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'human');

COMMIT;

INSERT INTO Image (Title, File_Path, Resolution, Description) VALUES
('Rider Image 01', 'images/rider-1.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 02', 'images/rider-2.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 03', 'images/rider-3.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 04', 'images/rider-4.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 05', 'images/rider-5.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 06', 'images/rider-6.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 07', 'images/rider-7.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 08', 'images/rider-8.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 09', 'images/rider-9.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 10', 'images/rider-10.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 11', 'images/rider-11.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 12', 'images/rider-12.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 13', 'images/rider-13.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 14', 'images/rider-14.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 15', 'images/rider-15.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 16', 'images/rider-16.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 17', 'images/rider-17.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 18', 'images/rider-18.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 19', 'images/rider-19.jpg', '1920x1080', 'A rider on a vehicle or animal.'),
('Rider Image 20', 'images/rider-20.jpg', '1920x1080', 'A rider on a vehicle or animal.');


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @RiderTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/rider-1.jpg', 'images/rider-2.jpg', 'images/rider-3.jpg', 'images/rider-4.jpg',
        'images/rider-5.jpg', 'images/rider-6.jpg', 'images/rider-7.jpg', 'images/rider-8.jpg',
        'images/rider-9.jpg', 'images/rider-10.jpg', 'images/rider-11.jpg', 'images/rider-12.jpg',
        'images/rider-13.jpg', 'images/rider-14.jpg', 'images/rider-15.jpg', 'images/rider-16.jpg',
        'images/rider-17.jpg', 'images/rider-18.jpg', 'images/rider-19.jpg', 'images/rider-20.jpg'
    );

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID)
SELECT
    I.Image_ID AS Media_ID,
    'Image' AS Media_Type,
    @HumanTagID AS Tag_ID
FROM
    Image I
WHERE
    I.File_Path IN (
        'images/rider-1.jpg', 'images/rider-2.jpg', 'images/rider-3.jpg', 'images/rider-4.jpg',
        'images/rider-5.jpg', 'images/rider-6.jpg', 'images/rider-7.jpg', 'images/rider-8.jpg',
        'images/rider-9.jpg', 'images/rider-10.jpg', 'images/rider-11.jpg', 'images/rider-12.jpg',
        'images/rider-13.jpg', 'images/rider-14.jpg', 'images/rider-15.jpg', 'images/rider-16.jpg',
        'images/rider-17.jpg', 'images/rider-18.jpg', 'images/rider-19.jpg', 'images/rider-20.jpg'
    );
    
START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('stunt'), ('bike'), ('vehicle');

SET @StuntTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'stunt');
SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Bike Stunt Ride', 'vedios/bike.mp4', '00:01:45', 'H.264', 'Action Enthusiast');

SET @VideoID_Bike = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@VideoID_Bike, 'Video', @StuntTagID), 
(@VideoID_Bike, 'Video', @BikeTagID), 
(@VideoID_Bike, 'Video', @VehicleTagID);

START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle');

SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('City Drive POV', 'vedios/car.mp4', '00:03:10', 'H.264', 'Driver Perspective');

SET @VideoID_Car = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@VideoID_Car, 'Video', @CarTagID), 
(@VideoID_Car, 'Video', @VehicleTagID);



START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal');

SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Kitten Playing', 'vedios/cat.mp4', '00:00:55', 'H.264', 'Pet Lover');

SET @VideoID_Cat = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'cat'
(@VideoID_Cat, 'Video', @CatTagID), 
-- Link to 'animal'
(@VideoID_Cat, 'Video', @AnimalTagID);
    
    

START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal');

SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Funny Dog Tricks', 'vedios/dog.mp4', '00:01:15', 'H.264', 'Trainer Videos');

SET @VideoID_Dog = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@VideoID_Dog, 'Video', @DogTagID), 
(@VideoID_Dog, 'Video', @AnimalTagID);



START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('flower'), ('nature');

SET @FlowerTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'flower');
SET @NatureTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'nature');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Timelapse of Blooming', 'vedios/flower.mp4', '00:00:40', 'H.264', 'Botanist Films');

SET @VideoID_Flower = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@VideoID_Flower, 'Video', @FlowerTagID), 
(@VideoID_Flower, 'Video', @NatureTagID);




START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal');

SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Horse Galloping Slow-Mo', 'vedios/horse.mp4', '00:00:50', 'H.264', 'Nature Filmmaker');

SET @VideoID_Horse = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@VideoID_Horse, 'Video', @HorseTagID), 
(@VideoID_Horse, 'Video', @AnimalTagID);


START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('rider'), ('human');

SET @RiderTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'rider');
SET @HumanTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'human');

COMMIT;

INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('POV Action Rider', 'vedios/rider.mp4', '00:01:30', 'H.264', 'Extreme Sports Channel');

SET @VideoID_Rider = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES

(@VideoID_Rider, 'Video', @RiderTagID), 

(@VideoID_Rider, 'Video', @HumanTagID);


START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('bike'), ('vehicle'), ('sound effect');

SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Motorcycle Engine Rev', 'audio/bike.wav', '00:00:30', 'SoundFX Library', 'Sound Effect');

SET @AudioID_Bike = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@AudioID_Bike, 'Audio', @BikeTagID), 
(@AudioID_Bike, 'Audio', @VehicleTagID),
(@AudioID_Bike, 'Audio', @SoundFXTagID);


START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle'), ('sound effect');

SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Car Horn Sound', 'audio/car.wav', '00:00:05', 'SoundFX Library', 'Sound Effect');

SET @AudioID_Car = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@AudioID_Car, 'Audio', @CarTagID), 
(@AudioID_Car, 'Audio', @VehicleTagID),
(@AudioID_Car, 'Audio', @SoundFXTagID);




START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal'), ('sound effect');

SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Cat Meow Sound', 'audio/cat.wav', '00:00:02', 'SoundFX Library', 'Sound Effect');

SET @AudioID_Cat = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@AudioID_Cat, 'Audio', @CatTagID), 
(@AudioID_Cat, 'Audio', @AnimalTagID),
(@AudioID_Cat, 'Audio', @SoundFXTagID);



START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal'), ('sound effect');

SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Dog Barking Sound', 'audio/dog.wav', '00:00:08', 'SoundFX Library', 'Sound Effect');

SET @AudioID_Dog = LAST_INSERT_ID();


INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@AudioID_Dog, 'Audio', @DogTagID), 
(@AudioID_Dog, 'Audio', @AnimalTagID),
(@AudioID_Dog, 'Audio', @SoundFXTagID);



START TRANSACTION;

INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal'), ('sound effect');

SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Horse Gallop Sound', 'audio/horse.wav', '00:00:15', 'SoundFX Library', 'Sound Effect');

SET @AudioID_Horse = LAST_INSERT_ID();

INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
(@AudioID_Horse, 'Audio', @HorseTagID), 
(@AudioID_Horse, 'Audio', @AnimalTagID),
(@AudioID_Horse, 'Audio', @SoundFXTagID);


START TRANSACTION;

SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');



SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');

SET @VideoID_Bike = (SELECT Video_ID FROM Video WHERE File_Path = 'vedios/bike.mp4');

SET @AudioID_Cat = (SELECT Audio_ID FROM Audio WHERE File_Path = 'audio/cat.wav');





START TRANSACTION;

-- Alice's Ratings: If the user/media combination already exists, update the Rating_Value.
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),
(@AliceID, @VideoID_Bike, 'Video', 4)
ON DUPLICATE KEY UPDATE
    Rating_Value = VALUES(Rating_Value);


-- Bob's Ratings: If the user/media combination already exists, update the Rating_Value.
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@BobID, @ImageID_Flower, 'Image', 3),
(@BobID, @AudioID_Cat, 'Audio', 5)
ON DUPLICATE KEY UPDATE
    Rating_Value = VALUES(Rating_Value);


COMMIT;

SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

DELETE FROM Media_Rating
WHERE User_ID IN (@AliceID, @BobID);

COMMIT;


INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),      
(@AliceID, @VideoID_Bike, 'Video', 4);        



INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@BobID, @ImageID_Flower, 'Image', 3),        
(@BobID, @AudioID_Cat, 'Audio', 5);           


COMMIT;



SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @DefaultRating = 4;
SET @DefaultUser = @AliceID;

START TRANSACTION;

INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)

SELECT 
    @DefaultUser AS User_ID, 
    I.Image_ID AS Media_ID, 
    'Image' AS Media_Type, 
    @DefaultRating AS Rating_Value
FROM 
    Image I
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = I.Image_ID AND MR.Media_Type = 'Image'
)

UNION ALL


SELECT 
    @DefaultUser AS User_ID, 
    V.Video_ID AS Media_ID, 
    'Video' AS Media_Type, 
    @DefaultRating AS Rating_Value
FROM 
    Video V
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = V.Video_ID AND MR.Media_Type = 'Video'
)

UNION ALL


SELECT 
    @DefaultUser AS User_ID, 
    A.Audio_ID AS Media_ID, 
    'Audio' AS Media_Type, 
    @DefaultRating AS Rating_Value
FROM 
    Audio A
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = A.Audio_ID AND MR.Media_Type = 'Audio'
);

COMMIT;




SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');
SET @DefaultBobRating = 3; 

START TRANSACTION;

INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)

SELECT 
    @BobID AS User_ID, 
    I.Image_ID AS Media_ID, 
    'Image' AS Media_Type, 
    @DefaultBobRating AS Rating_Value
FROM 
    Image I
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = I.Image_ID AND MR.Media_Type = 'Image' AND MR.User_ID = @BobID
)

UNION ALL


SELECT 
    @BobID AS User_ID, 
    V.Video_ID AS Media_ID, 
    'Video' AS Media_Type, 
    @DefaultBobRating AS Rating_Value
FROM 
    Video V
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = V.Video_ID AND MR.Media_Type = 'Video' AND MR.User_ID = @BobID
)

UNION ALL


SELECT 
    @BobID AS User_ID, 
    A.Audio_ID AS Media_ID, 
    'Audio' AS Media_Type, 
    @DefaultBobRating AS Rating_Value
FROM 
    Audio A
WHERE NOT EXISTS (
    SELECT 1 FROM Media_Rating MR
    WHERE MR.Media_ID = A.Audio_ID AND MR.Media_Type = 'Audio' AND MR.User_ID = @BobID
);

COMMIT;


START TRANSACTION;

SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');
SET @VideoID_Rider = (SELECT Video_ID FROM Video WHERE File_Path = 'vedios/rider.mp4');
SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');


COMMIT;

START TRANSACTION;

INSERT INTO View_History (User_ID, Media_ID, Media_Type) VALUES

(@AliceID, @ImageID_Flower, 'Image'),     
(@AliceID, @VideoID_Rider, 'Video'),      
(@AliceID, @AudioID_Horse, 'Audio'),      

(@BobID, @ImageID_Car, 'Image'),          
(@BobID, @VideoID_Rider, 'Video'),        
(@BobID, @ImageID_Flower, 'Image');       

COMMIT;




DELIMITER //

-- 1. TRIGGER: Enforcing Rating Bounds (BEFORE INSERT/UPDATE on Media_Rating)
-- Stops the operation if the Rating_Value is not between 1 and 5.
CREATE TRIGGER TR_BEFORE_RATING_INSERT_UPDATE
BEFORE INSERT ON Media_Rating
FOR EACH ROW
BEGIN
    IF NEW.Rating_Value < 1 OR NEW.Rating_Value > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Rating value must be between 1 and 5.';
    END IF;
END //

-- 2. TRIGGER: Automated Orphan Tag Cleanup (AFTER DELETE on Media_Tag)
-- Deletes a tag from the master Tag table if it is no longer linked to any media item.
CREATE TRIGGER TR_DELETE_ORPHAN_TAGS
AFTER DELETE ON Media_Tag
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Media_Tag
        WHERE Tag_ID = OLD.Tag_ID
    ) THEN
        DELETE FROM Tag WHERE Tag_ID = OLD.Tag_ID;
    END IF;
END //

-- 3. TRIGGER: Auditing - Preventing History Tampering (BEFORE UPDATE on View_History)
-- Ensures that existing view records cannot be modified once logged (maintains audit trail integrity).
CREATE TRIGGER TR_PREVENT_HISTORY_UPDATE
BEFORE UPDATE ON View_History
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: History records cannot be modified (UPDATE not allowed).';
END //

-- Reset the delimiter back to semicolon
DELIMITER ;