-- Find all reviews posted by a specific shopper
SELECT * FROM Review WHERE ShopperID = 1;

-- Find all sellers that have an average rating above 4
SELECT * FROM Seller WHERE AverageRating > 4;

-- Find all shoppers that a specific shopper is following
SELECT FollowedShopperID FROM Follow WHERE FollowerShopperID = 1;

-- Find all comments for a specific review
SELECT * FROM Comment WHERE ReviewID = 1;
