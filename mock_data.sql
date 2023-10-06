INSERT INTO Shopper (Name, Email, Password, Bio) VALUES 
('John Doe', 'john@example.com', 'password123', 'Just another tech enthusiast'),
('Jane Doe', 'jane@example.com', 'password456', 'Food blogger');

INSERT INTO Seller (Name, Location, Category, AverageRating) VALUES 
('Tech Store', 'New York', 'Electronics', 4.5),
('Food Place', 'San Francisco', 'Restaurant', 3.8);

INSERT INTO Review (ShopperID, SellerID, Rating, TextContent) VALUES 
(1, 1, 5, 'Great service'),
(2, 2, 3, 'Average experience');

INSERT INTO Video (ShopperID, VideoContent, Description, ViewsCount) VALUES 
(1, 'video_content_here', 'My tech review', 100),
(2, 'another_video_content_here', 'My restaurant review', 200);

INSERT INTO Comment (Content, ShopperID, ReviewID) VALUES 
('Great review!', 2, 1),
('Thanks for sharing', 1, 2);

INSERT INTO LikeTable (ShopperID, ReviewID) VALUES 
(1, 1),
(2, 1);

INSERT INTO Follow (FollowerShopperID, FollowedShopperID) VALUES 
(1, 2),
(2, 1);