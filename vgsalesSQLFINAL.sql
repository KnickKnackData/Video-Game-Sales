-- Let's first take a look at all of our data
SELECT *
FROM video_game_sales;

-- One of our columns had the same name as a function we will need for later querying, therefore we need to alter our table a little bit.
-- We changed the 'Year' column to 'Release_Year', Which would make more sense anyway since we only have year and no other date.
ALTER TABLE video_game_sales ADD Release_Year float
UPDATE video_game_sales SET Release_Year = Release_Date
ALTER TABLE video_game_sales DROP COLUMN Release_Date;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Popularity of gaming platforms: By analyzing the number of sales for each platform, you can see which platforms are the most popular and in demand.
SELECT 
platform,
ROUND(SUM(Global_Sales),2) as GlobalSales
FROM video_game_sales
GROUP BY Platform
ORDER BY ROUND(SUM(Global_Sales),2) DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Sales by region (North America)
-- analyzing sales by North American region can provide valuable information for game developers, publishers, retailers, and investors to make informed decisions about future gaming trends and strategies.
SELECT
Platform,
ROUND(SUM(NA_Sales),2) as NorthAmericaSales
FROM video_game_sales
GROUP BY Platform
ORDER BY ROUND(SUM(NA_Sales),2) DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Genre Sales & their success
-- analyzing the most successful games by genre sales can provide insights into which types of games are most popular amoung consumers and can help predict future trends in the gaming industry.
SELECT 
Genre,
ROUND(SUM(Global_Sales),2) as GenreSales
FROM video_game_sales
GROUP BY Genre
ORDER BY ROUND(SUM(Global_Sales),2) DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Publisher and SUM of Sales
-- By aggregating the total sales data for each publisher, we can identify which publishers are the most successful in terms of overall revenue generated from game sales.
SELECT
Publisher,
ROUND(SUM(Global_Sales),2) as GenreSales
FROM video_game_sales
GROUP BY Publisher
ORDER BY Publisher ASC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Best Publisher in Each Genre
-- The purpose of this query is to identify the publishers that have released the most successful games within each genre and help understand the competitive landscape within each genre to make informed decisions.
SELECT
Publisher,
Genre,
ROUND(SUM(Global_Sales),2) as GenreSales
FROM video_game_sales
GROUP BY Publisher, Genre
ORDER BY Genre, ROUND(SUM(Global_Sales),2) DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- year and sum the sales for each year
-- We are going to graph this sales chart by 5YR increments to analyze the trends over time (SYSTEM LIFESPAN 4-7YRS)
-- We can identify which years had the highest sales and which years had the lowest sales. This can provide insights into the overall growth or decline of the gaming industy over time.
SELECT
Release_Year,
ROUND(SUM(Global_Sales),2) as GlobalSales
FROM video_game_sales
GROUP BY Release_Year
ORDER BY Release_Year ASC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Relationship between Video Game Expenditure and User Satisfaction
-- This query is useful for understanding trends in the gaming industry and identifying factors that contribute to consumer satisfaction and overall improve the gaming experience for consumers.
SELECT 
Release_Year, Name, Platform, Publisher, Genre,
NA_Sales + EU_Sales + JP_Sales + Other_Sales as Total_Sales,
ROUND(SUM(Global_Sales),2) as GlobalSales
FROM Video_Game_Sales
GROUP BY Release_Year, NA_Sales, EU_Sales, JP_Sales, Other_Sales, Name, Platform, Publisher, Genre
ORDER BY Release_Year ASC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Global Sales by Platform and Genre (Top 100 Games)
-- This can determine which platforms and genres to focus on for a companies next game, or a marketer may use it to target their advertising campaigns to the most popular platforms and genres.
SELECT
Platform,
Genre,
ROUND(SUM(Global_Sales),2) as GenreSales
FROM video_game_sales
GROUP BY Platform, Genre
ORDER BY ROUND(SUM(Global_Sales),2) DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 5 Games in each Genre by Global Sales
-- This query helps to identify the most popular video games within each genre and provides insight into the preferences of gamers.
--By using the ROW_NUMBER function in SQL, we can rank the games within each genre by their global sales figures, and then select the top 5 games in each genre based on their rank.
SELECT Genre, Name, Global_sales
FROM (
	SELECT Genre, Name, Global_sales,
			ROW_NUMBER() OVER (PARTITION BY Genre ORDER BY  Global_Sales DESC) as row_num
	FROM Video_Game_Sales
) as ranked_games
WHERE row_num <= 5
ORDER BY Genre, Global_Sales DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top Genre Trends by Year(RANK)(10YR Increments)
-- using the RANK & ROW_NUM functions to rank the genres by their global sales within each year, we can identify the top genre trends by year.
-- This can help companies make informed decisions about the evolving preferences of gamers over time and help businesses make data-driven decisions about which genres to focus on for future game development and publishers.
SELECT DISTINCT(Genre), Release_Year, Global_sales,
	ROW_NUMBER() OVER (PARTITION BY Release_Year ORDER BY  Global_Sales DESC) as Genre_rank
FROM (
	SELECT Release_Year, Genre, Global_sales
	FROM Video_Game_Sales
	GROUP BY Release_Year, Genre, Global_Sales
) as sales_by_year_genre
ORDER BY Release_Year, Genre_rank ASC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Top Game in Each Year
-- We used a SELF-JOIN on itself in order to find the #1 game fro each year from (1977-2020) by the highest selling game for that year.
-- This can provide valuable insights into the most successful games of the year and help businesses make data-driven decisions about game development, publishing, and marketing.
SELECT 
	top_sellers.Release_Year,
	sales.Name as Title,
	top_sellers.Global_sales as Total_Sales
FROM (
	SELECT Release_Year, MAX(Global_Sales) as Global_Sales
	FROM Video_Game_Sales
	WHERE Release_Year BETWEEN '1977' AND '2020'
	GROUP BY Release_Year
) as top_sellers
JOIN Video_Game_Sales as sales
ON top_sellers.Global_Sales = sales.Global_Sales
AND top_sellers.Release_Year = sales.Release_Year
ORDER BY Release_Year ASC;

























































































---------------------------------------------------------------------------------------------------------------------------------------------------------------------------