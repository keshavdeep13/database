-- STEP 1: Create the Database
-- You must run this first!
CREATE DATABASE multimedia_project2;

-- STEP 2: Select the Database
-- This tells MySQL to execute all subsequent commands within this database
USE multimedia_project2;

-- -----------------------------------------------------
-- Table 1: User (For Login and Identity)
-- -----------------------------------------------------
CREATE TABLE User (
    User_ID INT NOT NULL AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL, -- Stored securely (hashed)
    Email VARCHAR(100) UNIQUE,
    Join_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (User_ID)
);

-- -----------------------------------------------------
-- Table 2: Tag (Master list of unique tag names)
-- -----------------------------------------------------
CREATE TABLE Tag (
    Tag_ID INT NOT NULL AUTO_INCREMENT,
    Tag_Name VARCHAR(100) NOT NULL UNIQUE,
    Creation_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Tag_ID)
);

-- -----------------------------------------------------
-- Table 3: Image (Metadata for Image files)
-- -----------------------------------------------------
CREATE TABLE Image (
    Image_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL, -- Relative path to the file
    Resolution VARCHAR(20),          -- e.g., '1920x1080'
    Description TEXT,
    PRIMARY KEY (Image_ID)
);

-- -----------------------------------------------------
-- Table 4: Audio (Metadata for Audio files)
-- -----------------------------------------------------
CREATE TABLE Audio (
    Audio_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL,
    Duration TIME,                   -- e.g., '00:03:45'
    Artist VARCHAR(100),
    Genre VARCHAR(50),
    PRIMARY KEY (Audio_ID)
);

-- -----------------------------------------------------
-- Table 5: Video (Metadata for Video files)
-- -----------------------------------------------------
CREATE TABLE Video (
    Video_ID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    File_Path VARCHAR(512) NOT NULL,
    Duration TIME,
    Codec VARCHAR(50),               -- e.g., 'H.264'
    Director VARCHAR(100),
    PRIMARY KEY (Video_ID)
);

-- -----------------------------------------------------
-- Table 6: Media_Tag (M:N Junction Table)
-- -----------------------------------------------------
CREATE TABLE Media_Tag (
    Tag_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL, -- Differentiates which media table is referenced
    
    PRIMARY KEY (Media_ID, Media_Type, Tag_ID),
    
    -- Foreign Key to Tag table
    FOREIGN KEY (Tag_ID) REFERENCES Tag (Tag_ID)
    -- Note: No direct FK to Image/Audio/Video due to polymorphic association.
);

-- -----------------------------------------------------
-- Table 7: View_History (User Consumption Tracking)
-- -----------------------------------------------------
CREATE TABLE View_History (
    History_ID INT NOT NULL AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL,
    View_Time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (History_ID),
    
    -- Foreign Key to User table
    FOREIGN KEY (User_ID) REFERENCES User (User_ID)
);

-- -----------------------------------------------------
-- Table 8: Media_Rating (User Ratings)
-- -----------------------------------------------------
CREATE TABLE Media_Rating (
    Rating_ID INT NOT NULL AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Media_ID INT NOT NULL,
    Media_Type ENUM('Image', 'Audio', 'Video') NOT NULL,
    Rating_Value TINYINT NOT NULL CHECK (Rating_Value BETWEEN 1 AND 5), -- Rating from 1 to 5
    Rated_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (Rating_ID),
    -- Ensures a user can only rate a specific item once
    UNIQUE KEY (User_ID, Media_ID, Media_Type),
    
    -- Foreign Key to User table
    FOREIGN KEY (User_ID) REFERENCES User (User_ID)
);

-- Start a transaction for safety
START TRANSACTION;

-- Ensure the 'flower' tag is in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('flower');

-- Retrieve the Tag_ID for 'flower' for use in linking
SET @FlowerTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'flower');

-- Commit setup changes
COMMIT;

-- Insert 20 images into the Image table
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


-- Link all 20 images just inserted to the 'flower' tag
-- This query assumes the Tag_ID variable (@FlowerTagID) was correctly set in Step 1.
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
    
-- Start a transaction
START TRANSACTION;

-- Ensure the 'bike' tag is in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('bike');
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('vehicle'); -- Adding a broad tag too

-- Retrieve the Tag_ID for 'bike' for use in linking
SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

-- Commit setup changes
COMMIT;

-- Insert 20 bike images into the Image table
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

-- List of File_Paths for the 20 bike images
-- REMOVED: The invalid SET @BikePaths = (...) command.

-- NOTE: Ensure @BikeTagID and @VehicleTagID are set previously, like this:
-- SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
-- SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

-- Define the list of file paths once for clarity
SET @BikePathsList = 
    "'images/bike_001.bmp', 'images/bike_002.bmp', 'images/bike_003.bmp', 'images/bike_004.bmp', 
     'images/bike_005.bmp', 'images/bike_006.bmp', 'images/bike_007.bmp', 'images/bike_008.bmp', 
     'images/bike_009.bmp', 'images/bike_010.bmp', 'images/bike_011.bmp', 'images/bike_012.bmp', 
     'images/bike_013.bmp', 'images/bike_014.bmp', 'images/bike_015.bmp', 'images/bike_016.bmp', 
     'images/bike_017.bmp', 'images/bike_018.bmp', 'images/bike_019.bmp', 'images/bike_020.bmp'";
-- NOTE: I wrapped the entire list in a single variable for easier management, but you must use the literal string list in the IN clause below.

-- --------------------------------------------------------------------------------------

-- Link images to the 'bike' tag
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

-- Link images to the 'vehicle' tag
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
    
    
    
    -- Start a transaction
START TRANSACTION;

-- Ensure 'car' and 'vehicle' tags are in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle');

-- Retrieve the Tag_IDs for use in linking
SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

-- Commit setup changes
COMMIT;

-- Insert 20 car images into the Image table
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


-- List of File_Paths for the 20 car images
-- *** REMOVE THIS ENTIRE FIRST LINE, AS IT CAUSES THE ERROR ***
-- SET @CarPathsList = ( 'images/carsgraz_001.bmp', ... );

-- Link images to the 'car' tag
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

-- Link images to the 'vehicle' tag
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

-- Define User IDs for later use in history/ratings
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');


-- Assume Image_ID 1 is a flower, and 21 is a car (based on previous blocks)
SET @ImageID_Flower = 1;
SET @ImageID_Car = 21; 

-- BLOCK 3: Insert View History and Media Ratings

-- 1. Redefine User IDs (Safety Check)
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

-- 2. Retrieve Media IDs using File_Path (Guaranteed to work)
-- Assuming you chose File_Paths like these for demonstration:
SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');
SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');
SET @VideoID_SQL = (SELECT Video_ID FROM Video WHERE Title = 'Beginner SQL Tutorial');


-- BLOCK TO ENSURE ALL NECESSARY IMAGE and USER IDs ARE DEFINED

-- 1. Retrieve User IDs
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

-- 2. Retrieve Media IDs using File_Path (Guaranteed to work if you inserted these files)
-- Using the paths from your earlier insertions:
SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');
SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');
-- Note: If the file paths above do not exist in your Image table, adjust them accordingly!


-- 3. INSERT INTO View_History (Only using existing Image IDs)
INSERT INTO View_History (User_ID, Media_ID, Media_Type) VALUES 
(@AliceID, @ImageID_Flower, 'Image'),         -- Alice viewed a Flower image
(@BobID, @ImageID_Car, 'Image'),              -- Bob viewed a Car image
(@AliceID, @ImageID_Car, 'Image');            -- Alice viewed the Car image for testing history

-- 4. INSERT INTO Media_Rating (Only using existing Image IDs)
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),      -- Alice rates the Flower image as 5
(@BobID, @ImageID_Car, 'Image', 3),           -- Bob rates the Car image as 3
(@BobID, @ImageID_Flower, 'Image', 4);        -- Bob rates the Flower image as 4



-- Start a transaction
START TRANSACTION;

-- Ensure 'cat' and 'animal' tags are in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal');

-- Retrieve the Tag_IDs for use in linking
SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

-- Commit setup changes
COMMIT;

-- Insert 20 cat images into the Image table
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



-- *** DELETE THE INVALID SET @CatPathsList = (...) LINE ***

-- Link images to the 'cat' tag
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

-- Link images to the 'animal' tag
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
    
    
-- Start a transaction
START TRANSACTION;

-- Ensure 'dog' and 'animal' tags are in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal');

-- Retrieve the Tag_IDs for use in linking
SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

-- Commit setup changes
COMMIT;

-- Insert 20 dog images into the Image table
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


-- Link images to the 'dog' tag
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

-- Link images to the 'animal' tag
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
    
    
-- Start a transaction
START TRANSACTION;

-- Ensure 'horse' and 'animal' tags are in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal');

-- Retrieve the Tag_IDs for use in linking
SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

-- Commit setup changes
COMMIT;

-- Insert 20 horse images into the Image table
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


-- Link images to the 'horse' tag
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

-- Link images to the 'animal' tag
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

-- Start a transaction
START TRANSACTION;

-- Ensure 'rider' and 'human' tags are in the master list
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('rider'), ('human');

-- Retrieve the Tag_IDs for use in linking
SET @RiderTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'rider');
SET @HumanTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'human');

-- Commit setup changes
COMMIT;

-- Insert 20 rider images into the Image table
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


-- Link images to the 'rider' tag
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

-- Link images to the 'human' tag
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
    
-- Start transaction for safety
START TRANSACTION;

-- Ensure 'stunt', 'bike', and 'vehicle' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('stunt'), ('bike'), ('vehicle');

-- Retrieve the Tag_IDs
SET @StuntTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'stunt');
SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

COMMIT;

-- Insert the Bike Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Bike Stunt Ride', 'vedios/bike.mp4', '00:01:45', 'H.264', 'Action Enthusiast');

-- Get the ID of the inserted video
SET @VideoID_Bike = LAST_INSERT_ID();

-- Link the Bike Video to 'stunt', 'bike', and 'vehicle' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'stunt'
(@VideoID_Bike, 'Video', @StuntTagID), 
-- Link to 'bike'
(@VideoID_Bike, 'Video', @BikeTagID), 
-- Link to 'vehicle'
(@VideoID_Bike, 'Video', @VehicleTagID);

-- Start transaction for safety
START TRANSACTION;

-- Ensure 'car' and 'vehicle' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle');

-- Retrieve the Tag_IDs
SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');

COMMIT;

-- Insert the Car Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('City Drive POV', 'vedios/car.mp4', '00:03:10', 'H.264', 'Driver Perspective');

-- Get the ID of the inserted video
SET @VideoID_Car = LAST_INSERT_ID();

-- Link the Car Video to 'car' and 'vehicle' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'car'
(@VideoID_Car, 'Video', @CarTagID), 
-- Link to 'vehicle'
(@VideoID_Car, 'Video', @VehicleTagID);



-- Start transaction for safety
START TRANSACTION;

-- Ensure 'cat' and 'animal' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal');

-- Retrieve the Tag_IDs
SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

-- Insert the Cat Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Kitten Playing', 'vedios/cat.mp4', '00:00:55', 'H.264', 'Pet Lover');

-- Get the ID of the inserted video
SET @VideoID_Cat = LAST_INSERT_ID();

-- Link the Cat Video to 'cat' and 'animal' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'cat'
(@VideoID_Cat, 'Video', @CatTagID), 
-- Link to 'animal'
(@VideoID_Cat, 'Video', @AnimalTagID);
    
    

-- Start transaction for safety
START TRANSACTION;

-- Ensure 'dog' and 'animal' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal');

-- Retrieve the Tag_IDs
SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

-- Insert the Dog Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Funny Dog Tricks', 'vedios/dog.mp4', '00:01:15', 'H.264', 'Trainer Videos');

-- Get the ID of the inserted video
SET @VideoID_Dog = LAST_INSERT_ID();

-- Link the Dog Video to 'dog' and 'animal' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'dog'
(@VideoID_Dog, 'Video', @DogTagID), 
-- Link to 'animal'
(@VideoID_Dog, 'Video', @AnimalTagID);



-- Start transaction for safety
START TRANSACTION;

-- Ensure 'flower' and 'nature' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('flower'), ('nature');

-- Retrieve the Tag_IDs
SET @FlowerTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'flower');
SET @NatureTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'nature');

COMMIT;

-- Insert the Flower Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Timelapse of Blooming', 'vedios/flower.mp4', '00:00:40', 'H.264', 'Botanist Films');

-- Get the ID of the inserted video
SET @VideoID_Flower = LAST_INSERT_ID();

-- Link the Flower Video to 'flower' and 'nature' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'flower'
(@VideoID_Flower, 'Video', @FlowerTagID), 
-- Link to 'nature'
(@VideoID_Flower, 'Video', @NatureTagID);




-- Start transaction for safety
START TRANSACTION;

-- Ensure 'horse' and 'animal' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal');

-- Retrieve the Tag_IDs
SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');

COMMIT;

-- Insert the Horse Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('Horse Galloping Slow-Mo', 'vedios/horse.mp4', '00:00:50', 'H.264', 'Nature Filmmaker');

-- Get the ID of the inserted video
SET @VideoID_Horse = LAST_INSERT_ID();

-- Link the Horse Video to 'horse' and 'animal' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'horse'
(@VideoID_Horse, 'Video', @HorseTagID), 
-- Link to 'animal'
(@VideoID_Horse, 'Video', @AnimalTagID);


-- Start transaction for safety
START TRANSACTION;

-- Ensure 'rider' and 'human' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('rider'), ('human');

-- Retrieve the Tag_IDs
SET @RiderTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'rider');
SET @HumanTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'human');

COMMIT;

-- Insert the Rider Video record
INSERT INTO Video (Title, File_Path, Duration, Codec, Director) VALUES
('POV Action Rider', 'vedios/rider.mp4', '00:01:30', 'H.264', 'Extreme Sports Channel');

-- Get the ID of the inserted video
SET @VideoID_Rider = LAST_INSERT_ID();

-- Link the Rider Video to 'rider' and 'human' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'rider'
(@VideoID_Rider, 'Video', @RiderTagID), 
-- Link to 'human'
(@VideoID_Rider, 'Video', @HumanTagID);


-- Start transaction for safety
START TRANSACTION;

-- Ensure 'bike', 'vehicle', and 'sound effect' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('bike'), ('vehicle'), ('sound effect');

-- Retrieve the Tag_IDs
SET @BikeTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'bike');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

-- Insert the Bike Audio record
INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Motorcycle Engine Rev', 'audio/bike.wav', '00:00:30', 'SoundFX Library', 'Sound Effect');

-- Get the ID of the inserted audio
SET @AudioID_Bike = LAST_INSERT_ID();

-- Link the Bike Audio to 'bike', 'vehicle', and 'sound effect' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'bike'
(@AudioID_Bike, 'Audio', @BikeTagID), 
-- Link to 'vehicle'
(@AudioID_Bike, 'Audio', @VehicleTagID),
-- Link to 'sound effect'
(@AudioID_Bike, 'Audio', @SoundFXTagID);


-- Start transaction for safety
START TRANSACTION;

-- Ensure 'car', 'vehicle', and 'sound effect' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('car'), ('vehicle'), ('sound effect');

-- Retrieve the Tag_IDs
SET @CarTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'car');
SET @VehicleTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'vehicle');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

-- Insert the Car Audio record
INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Car Horn Sound', 'audio/car.wav', '00:00:05', 'SoundFX Library', 'Sound Effect');

-- Get the ID of the inserted audio
SET @AudioID_Car = LAST_INSERT_ID();

-- Link the Car Audio to 'car', 'vehicle', and 'sound effect' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'car'
(@AudioID_Car, 'Audio', @CarTagID), 
-- Link to 'vehicle'
(@AudioID_Car, 'Audio', @VehicleTagID),
-- Link to 'sound effect'
(@AudioID_Car, 'Audio', @SoundFXTagID);




-- Start transaction for safety
START TRANSACTION;

-- Ensure 'cat', 'animal', and 'sound effect' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('cat'), ('animal'), ('sound effect');

-- Retrieve the Tag_IDs
SET @CatTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'cat');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

-- Insert the Cat Audio record
INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Cat Meow Sound', 'audio/cat.wav', '00:00:02', 'SoundFX Library', 'Sound Effect');

-- Get the ID of the inserted audio
SET @AudioID_Cat = LAST_INSERT_ID();

-- Link the Cat Audio to 'cat', 'animal', and 'sound effect' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'cat'
(@AudioID_Cat, 'Audio', @CatTagID), 
-- Link to 'animal'
(@AudioID_Cat, 'Audio', @AnimalTagID),
-- Link to 'sound effect'
(@AudioID_Cat, 'Audio', @SoundFXTagID);



-- Start transaction for safety
START TRANSACTION;

-- Ensure 'dog', 'animal', and 'sound effect' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('dog'), ('animal'), ('sound effect');

-- Retrieve the Tag_IDs
SET @DogTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'dog');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

-- Insert the Dog Audio record
INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Dog Barking Sound', 'audio/dog.wav', '00:00:08', 'SoundFX Library', 'Sound Effect');

-- Get the ID of the inserted audio
SET @AudioID_Dog = LAST_INSERT_ID();


-- Link the Dog Audio to 'dog', 'animal', and 'sound effect' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'dog'
(@AudioID_Dog, 'Audio', @DogTagID), 
-- Link to 'animal'
(@AudioID_Dog, 'Audio', @AnimalTagID),
-- Link to 'sound effect'
(@AudioID_Dog, 'Audio', @SoundFXTagID);



-- Start transaction for safety
START TRANSACTION;

-- Ensure 'horse', 'animal', and 'sound effect' tags exist
INSERT IGNORE INTO Tag (Tag_Name) VALUES ('horse'), ('animal'), ('sound effect');

-- Retrieve the Tag_IDs
SET @HorseTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'horse');
SET @AnimalTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'animal');
SET @SoundFXTagID = (SELECT Tag_ID FROM Tag WHERE Tag_Name = 'sound effect');

COMMIT;

-- Insert the Horse Audio record
INSERT INTO Audio (Title, File_Path, Duration, Artist, Genre) VALUES
('Horse Gallop Sound', 'audio/horse.wav', '00:00:15', 'SoundFX Library', 'Sound Effect');

-- Get the ID of the inserted audio
SET @AudioID_Horse = LAST_INSERT_ID();

-- Link the Horse Audio to 'horse', 'animal', and 'sound effect' tags
INSERT INTO Media_Tag (Media_ID, Media_Type, Tag_ID) VALUES
-- Link to 'horse'
(@AudioID_Horse, 'Audio', @HorseTagID), 
-- Link to 'animal'
(@AudioID_Horse, 'Audio', @AnimalTagID),
-- Link to 'sound effect'
(@AudioID_Horse, 'Audio', @SoundFXTagID);


-- Start a transaction to ensure all ratings are inserted together
START TRANSACTION;

-- 1. DEFINE USER IDs (Retrieves IDs from the User table)
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');


-- 2. DEFINE MEDIA IDs (Retrieves IDs based on known File_Paths/Titles)
-- Image (Flower) - for testing averages
SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');

-- Video (Bike) - for testing Video type
SET @VideoID_Bike = (SELECT Video_ID FROM Video WHERE File_Path = 'vedios/bike.mp4');

-- Audio (Cat) - for testing Audio type
SET @AudioID_Cat = (SELECT Audio_ID FROM Audio WHERE File_Path = 'audio/cat.wav');


-- BLOCK TO INSERT ALL RATINGS (SEPARATED BY USER)

-- NOTE: Ensure all SET @variable commands for IDs (@AliceID, @BobID, etc.) 
-- have been successfully run in the same session before running this block.

START TRANSACTION;

-- 1. INSERT ALL OF ALICE'S RATINGS
-- Includes: Flower Image (5) and Bike Video (4)
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),      -- RATING A: Flower Image
(@AliceID, @VideoID_Bike, 'Video', 4);        -- RATING C: Bike Video


-- 2. INSERT ALL OF BOB'S RATINGS
-- Includes: Flower Image (3) and Cat Audio (5)
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@BobID, @ImageID_Flower, 'Image', 3),        -- RATING B: Flower Image (Allows average calculation)
(@BobID, @AudioID_Cat, 'Audio', 5);           -- RATING D: Cat Audio


COMMIT;

-- Retrieve User IDs (Safety check, assuming you ran this block successfully)
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

-- Delete all rating entries made by Alice and Bob
DELETE FROM Media_Rating
WHERE User_ID IN (@AliceID, @BobID);

COMMIT; -- Commit the deletion

-- 1. INSERT ALL OF ALICE'S RATINGS
-- Includes: Flower Image (5) and Bike Video (4)
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@AliceID, @ImageID_Flower, 'Image', 5),      -- RATING A: Flower Image
(@AliceID, @VideoID_Bike, 'Video', 4);        -- RATING C: Bike Video


-- 2. INSERT ALL OF BOB'S RATINGS
-- Includes: Flower Image (3) and Cat Audio (5)
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value) VALUES
(@BobID, @ImageID_Flower, 'Image', 3),        -- RATING B: Flower Image (Allows average calculation)
(@BobID, @AudioID_Cat, 'Audio', 5);           -- RATING D: Cat Audio


COMMIT;


-- BLOCK TO INSERT A DEFAULT RATING (4) BY ALICE FOR ALL UNRATED MEDIA

-- Ensure User and Tag IDs are correctly set in the current session
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @DefaultRating = 4;
SET @DefaultUser = @AliceID;

START TRANSACTION;

-- INSERT into Media_Rating from all three media tables where NO rating currently exists.
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)
-- -------------------------------------------------------------
-- 1. UNRATED IMAGES (SELECT all Images that are NOT in Media_Rating)
-- -------------------------------------------------------------
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

-- -------------------------------------------------------------
-- 2. UNRATED VIDEOS (SELECT all Videos that are NOT in Media_Rating)
-- -------------------------------------------------------------
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

-- -------------------------------------------------------------
-- 3. UNRATED AUDIOS (SELECT all Audios that are NOT in Media_Rating)
-- -------------------------------------------------------------
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



-- BLOCK TO INSERT A DEFAULT RATING (3) BY BOB FOR ALL UNRATED MEDIA

-- Ensure Bob's ID is set
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');
SET @DefaultBobRating = 3; 

START TRANSACTION;

-- INSERT into Media_Rating by Bob, selecting all media that BOB HAS NOT YET RATED.
INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)
-- -------------------------------------------------------------
-- 1. UNRATED IMAGES by Bob
-- -------------------------------------------------------------
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

-- -------------------------------------------------------------
-- 2. UNRATED VIDEOS by Bob
-- -------------------------------------------------------------
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

-- -------------------------------------------------------------
-- 3. UNRATED AUDIOS by Bob
-- -------------------------------------------------------------
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

-- Start transaction for safety
START TRANSACTION;

-- Define User IDs
SET @AliceID = (SELECT User_ID FROM User WHERE Username = 'alice_tester');
SET @BobID = (SELECT User_ID FROM User WHERE Username = 'bob_searcher');

-- Define Media IDs (Retrieves IDs based on known File_Paths)
SET @ImageID_Car = (SELECT Image_ID FROM Image WHERE File_Path = 'images/carsgraz_001.bmp');
SET @VideoID_Rider = (SELECT Video_ID FROM Video WHERE File_Path = 'vedios/rider.mp4');
SET @ImageID_Flower = (SELECT Image_ID FROM Image WHERE File_Path = 'images/0001.png');

-- You can commit this first part if you ran it successfully in previous steps, 
-- but running it again ensures the IDs are fresh.
COMMIT;

START TRANSACTION;

INSERT INTO View_History (User_ID, Media_ID, Media_Type) VALUES
-- ALICE'S HISTORY
(@AliceID, @ImageID_Flower, 'Image'),     -- Alice viewed a flower image
(@AliceID, @VideoID_Rider, 'Video'),      -- Alice viewed the rider video
(@AliceID, @AudioID_Horse, 'Audio'),      -- Alice viewed the horse audio

-- BOB'S HISTORY
(@BobID, @ImageID_Car, 'Image'),          -- Bob viewed a car image
(@BobID, @VideoID_Rider, 'Video'),        -- Bob viewed the same rider video (allowed)
(@BobID, @ImageID_Flower, 'Image');       -- Bob viewed the flower image

COMMIT;


