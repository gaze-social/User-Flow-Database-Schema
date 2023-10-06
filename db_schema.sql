-- Shopper table
CREATE TABLE Shopper (
    ShopperID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50) UNIQUE,
    Password VARCHAR(50),
    DateJoined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ProfilePic VARCHAR(256),
    Bio TEXT,
    FollowersCount INTEGER DEFAULT 0,
    FollowingCount INTEGER DEFAULT 0
);

-- Seller table
CREATE TABLE Seller (
    SellerID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Location VARCHAR(50),
    Category VARCHAR(50),
    AverageRating FLOAT
);

-- Review table 
CREATE TABLE Review (
    ReviewID SERIAL PRIMARY KEY,
    ShopperID INTEGER REFERENCES Shopper(ShopperID),
    SellerID INTEGER REFERENCES Seller(SellerID),
    Rating INTEGER,
    TextContent TEXT,
    DatePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Video table 
CREATE TABLE Video (
    VideoID SERIAL PRIMARY KEY,
    ShopperID INTEGER REFERENCES Shopper(ShopperID),
    VideoContent TEXT,
    DatePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Description TEXT,
    ViewsCount INTEGER DEFAULT 0
);

-- Comment table 
CREATE TABLE Comment (
    CommentID SERIAL PRIMARY KEY,
    Content TEXT,
    ShopperID INTEGER REFERENCES Shopper(ShopperID),
    DatePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReviewID INTEGER REFERENCES Review(ReviewID),
    VideoID INTEGER REFERENCES Video(VideoID)
);

-- Like table 
CREATE TABLE LikeTable (
    LikeID SERIAL PRIMARY KEY,
    ShopperID INTEGER REFERENCES Shopper(ShopperID),
    ReviewID INTEGER REFERENCES Review(ReviewID),
    VideoID INTEGER REFERENCES Video(VideoID)
);

-- Follow table 
CREATE TABLE Follow (
    FollowerShopperID INTEGER REFERENCES Shopper(ShopperID),
    FollowedShopperID INTEGER REFERENCES Shopper(ShopperID),
    PRIMARY KEY (FollowerShopperID, FollowedShopperID)
);

-- Create index 
CREATE INDEX idx_shopper_email ON Shopper(Email);

-- To implement the task of tracking and storing the number of times a review is shared
ALTER TABLE Review
ADD COLUMN share_count INT DEFAULT 0;

-- Create ReviewShare table
CREATE TABLE ReviewShare (
    ShareID SERIAL PRIMARY KEY,
    ReviewID INTEGER REFERENCES Review(ReviewID),
    ShopperID INTEGER REFERENCES Shopper(ShopperID), -- the person who shared the review
    SharePlatform VARCHAR(50), -- can be 'Email', 'Facebook', 'WhatsApp', etc.
    ShareTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Index
CREATE INDEX idx_share_count ON Review(share_count);
CREATE INDEX idx_review_share ON ReviewShare(ReviewID);

-- Archive Tables

-- Shopper Archive
CREATE TABLE Shopper_Archive AS TABLE Shopper WITH NO DATA;

-- Seller Archive
CREATE TABLE Seller_Archive AS TABLE Seller WITH NO DATA;

-- Review Archive
CREATE TABLE Review_Archive AS TABLE Review WITH NO DATA;

-- Video Archive
CREATE TABLE Video_Archive AS TABLE Video WITH NO DATA;

-- Comment Archive
CREATE TABLE Comment_Archive AS TABLE Comment WITH NO DATA;

-- LikeTable Archive
CREATE TABLE LikeTable_Archive AS TABLE LikeTable WITH NO DATA;

-- Follow Archive
CREATE TABLE Follow_Archive AS TABLE Follow WITH NO DATA;

-- Trigger to archive data before deleting from Shopper table
CREATE OR REPLACE FUNCTION archive_shopper()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Shopper_Archive SELECT * FROM Shopper WHERE ShopperID = OLD.ShopperID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_shopper_trigger
BEFORE DELETE ON Shopper
FOR EACH ROW EXECUTE FUNCTION archive_shopper();

-- Trigger to archive data before deleting from Seller table
CREATE OR REPLACE FUNCTION archive_seller()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Seller_Archive SELECT * FROM Seller WHERE SellerID = OLD.SellerID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_seller_trigger
BEFORE DELETE ON Seller
FOR EACH ROW EXECUTE FUNCTION archive_seller();

-- Trigger to archive data before deleting from Review table
CREATE OR REPLACE FUNCTION archive_review()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Review_Archive SELECT * FROM Review WHERE ReviewID = OLD.ReviewID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_review_trigger
BEFORE DELETE ON Review
FOR EACH ROW EXECUTE FUNCTION archive_review();

-- Trigger to archive data before deleting from Video table
CREATE OR REPLACE FUNCTION archive_video()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Video_Archive SELECT * FROM Video WHERE VideoID = OLD.VideoID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_video_trigger
BEFORE DELETE ON Video
FOR EACH ROW EXECUTE FUNCTION archive_video();

-- Trigger to archive data before deleting from Comment table
CREATE OR REPLACE FUNCTION archive_comment()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Comment_Archive SELECT * FROM Comment WHERE CommentID = OLD.CommentID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_comment_trigger
BEFORE DELETE ON Comment
FOR EACH ROW EXECUTE FUNCTION archive_comment();

-- Trigger to archive data before deleting from LikeTable
CREATE OR REPLACE FUNCTION archive_liketable()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO LikeTable_Archive SELECT * FROM LikeTable WHERE LikeID = OLD.LikeID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_liketable_trigger
BEFORE DELETE ON LikeTable
FOR EACH ROW EXECUTE FUNCTION archive_liketable();

-- Trigger to archive data before deleting from Follow table
CREATE OR REPLACE FUNCTION archive_follow()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Follow_Archive SELECT * FROM Follow WHERE FollowerShopperID = OLD.FollowerShopperID AND FollowedShopperID = OLD.FollowedShopperID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_follow_trigger
BEFORE DELETE ON Follow
FOR EACH ROW EXECUTE FUNCTION archive_follow();

-- Alter Review table to set ShopperID to NULL if a Shopper is deleted
ALTER TABLE Review DROP CONSTRAINT IF EXISTS review_shopperid_fkey;
ALTER TABLE Review ADD CONSTRAINT review_shopperid_fkey FOREIGN KEY (ShopperID) REFERENCES Shopper(ShopperID) ON DELETE SET NULL;

-- Alter Video table to set ShopperID to NULL if a Shopper is deleted
ALTER TABLE Video DROP CONSTRAINT IF EXISTS video_shopperid_fkey;
ALTER TABLE Video ADD CONSTRAINT video_shopperid_fkey FOREIGN KEY (ShopperID) REFERENCES Shopper(ShopperID) ON DELETE SET NULL;

-- Alter Comment table to set ShopperID to NULL if a Shopper is deleted
ALTER TABLE Comment DROP CONSTRAINT IF EXISTS comment_shopperid_fkey;
ALTER TABLE Comment ADD CONSTRAINT comment_shopperid_fkey FOREIGN KEY (ShopperID) REFERENCES Shopper(ShopperID) ON DELETE SET NULL;

-- Alter LikeTable to set ShopperID to NULL if a Shopper is deleted
ALTER TABLE LikeTable DROP CONSTRAINT IF EXISTS liketable_shopperid_fkey;
ALTER TABLE LikeTable ADD CONSTRAINT liketable_shopperid_fkey FOREIGN KEY (ShopperID) REFERENCES Shopper(ShopperID) ON DELETE SET NULL;

-- Alter Follow table to delete the row if a Shopper is deleted
ALTER TABLE Follow DROP CONSTRAINT IF EXISTS follow_followerid_fkey;
ALTER TABLE Follow DROP CONSTRAINT IF EXISTS follow_followedid_fkey;
ALTER TABLE Follow ADD CONSTRAINT follow_followerid_fkey FOREIGN KEY (FollowerShopperID) REFERENCES Shopper(ShopperID) ON DELETE CASCADE;
ALTER TABLE Follow ADD CONSTRAINT follow_followedid_fkey FOREIGN KEY (FollowedShopperID) REFERENCES Shopper(ShopperID) ON DELETE CASCADE;


-- Disable triggers for the Shopper table
ALTER TABLE Shopper DISABLE TRIGGER ALL;

-- Manually delete rows from other tables that reference ShopperID = 1
DELETE FROM Follow WHERE FollowerShopperID = 1 OR FollowedShopperID = 1;
DELETE FROM LikeTable WHERE ShopperID = 1;
DELETE FROM Comment WHERE ShopperID = 1;
DELETE FROM Video WHERE ShopperID = 1;
DELETE FROM Review WHERE ShopperID = 1;
-- Now, you should be able to delete from Shopper without constraint issues
DELETE FROM Shopper WHERE ShopperID = 1;

-- Re-enable triggers for the Shopper table
ALTER TABLE Shopper ENABLE TRIGGER ALL;

-- Implement Logging Mechanisms to Track User Registration Metrics
CREATE TABLE User_Registration_Log (
    LogID SERIAL PRIMARY KEY,
    ShopperID INTEGER REFERENCES Shopper(ShopperID),
    SignUpMethod VARCHAR(50),  -- Can be 'Email', 'Facebook', 'Google', etc.
    SignUpTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Index for efficient querying
CREATE INDEX idx_user_registration_log ON User_Registration_Log(ShopperID);

-- Trigger to populate User_Registration_Log after a new user is inserted into Shopper table
CREATE OR REPLACE FUNCTION log_user_registration()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO User_Registration_Log (ShopperID, SignUpMethod) VALUES (NEW.ShopperID, 'Email');  -- Assuming Email as default method
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_user_registration_trigger
AFTER INSERT ON Shopper
FOR EACH ROW EXECUTE FUNCTION log_user_registration();

-- Adjust the SignUpMethod in the log_user_registration function based on your actual sign-up methods. 
-- The current setup assumes everyone is signing up through email. 

--Implement mechanisms to ensure photos are stored efficiently, considering factors like resolution and file size.
-- Add new columns to Shopper table to store image metadata
ALTER TABLE Shopper ADD COLUMN ProfilePicResolution VARCHAR(20);
ALTER TABLE Shopper ADD COLUMN ProfilePicFileSize INT;  -- In KB
ALTER TABLE Shopper ADD COLUMN ProfilePicFormat VARCHAR(10);  -- E.g., 'JPEG', 'PNG'


