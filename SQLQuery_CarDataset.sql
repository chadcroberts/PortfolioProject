/* Dataset from following location: https://www.kaggle.com/datasets/anoopjohny/2023-cars-dataset/data */



----------------------------------------------------------------------------------------------------------------------
-- (1)
/* View first 25 rows of table and then check a few simple queries */

Select Top 25 *
From PortfolioProject.dbo.CarDatasetv1


/* Check table column names and data types */

Select COLUMN_NAME, DATA_TYPE
From PortfolioProject.Information_Schema.Columns
Where TABLE_NAME = 'CarDatasetv1'


/* Summarize number of gasoline, electric, and hybrid car options */

/* Gas = 149, Electric = 9, Hybrid = 6 */

Select FuelType, Count(FuelType) as Qty
From PortfolioProject.dbo.CarDatasetv1
Group By FuelType
Order By Qty DESC


/* Find max and min price */

/* Notice that there are duplicate values showing up for min case */

Select CarMake, CarModel, [Price($)]
From PortfolioProject.dbo.CarDatasetv1
Where [Price($)] = (Select max([Price($)]) From PortfolioProject.dbo.CarDataset) or [Price($)] = (Select min([Price($)]) From PortfolioProject.dbo.CarDataset)



----------------------------------------------------------------------------------------------------------------------
-- (2)
/* Find duplicates, remove from table, and write resulting data into New table */

/* Write all data without duplicates into new table */

Select *,						-- Find all rows in which values in PARTITION BY are the same, increment row_num as new column
	ROW_NUMBER() OVER (
	PARTITION BY CarModel, 
				 [EngineSize(L)],
				 [Torque(Nm)],
				 [Acceleration(0-60mph)],
				 EntertainmentFeatures,
				 InteriorFeatures,
				 [Price($)],
				 CustomerRatings
				 ORDER BY
					ID
					) row_num
Into CarDatasetv1_clean				
From PortfolioProject.dbo.CarDatasetv1 

/* Check contents of new table */
/* 164 rows */

Select *
From PortfolioProject.dbo.CarDatasetv1_clean

/* Delete rows with row_num > 1 from new table to eliminate duplicates */

Delete 
From PortfolioProject.dbo.CarDatasetv1_clean
Where row_num > 1

/* Check contents of new table */
/* 104 rows */

Select *
From PortfolioProject.dbo.CarDatasetv1_clean

/* Delete rows with invalid sales figures */

Delete
From PortfolioProject.dbo.CarDatasetv1_clean
Where [SalesFigures(UnitsSold)] is null

/* Check contents of new table */
/* 102 rows */

Select *
From PortfolioProject.dbo.CarDatasetv1_clean



----------------------------------------------------------------------------------------------------------------------
-- (3)
/* Convert varchar columns with numeric data including units to float for plotting */

/* Remove the text 'seconds' from Acceleration data */

Select [Acceleration(0-60mph)], Substring([Acceleration(0-60mph)], 1, charindex('seconds',[Acceleration(0-60mph)])-1) as [Acceleration(sec)]
From PortfolioProject.dbo.CarDatasetv1_clean

Alter Table PortfolioProject.dbo.CarDatasetv1_clean
Add [Acceleration(sec)] float;

Update PortfolioProject.dbo.CarDatasetv1_clean
Set [Acceleration(sec)] = Substring([Acceleration(0-60mph)], 1, charindex('seconds',[Acceleration(0-60mph)])-1)

/* Confirm new column added with only numeric values for Acceleration(sec) */

Select *
From PortfolioProject.dbo.CarDatasetv1_clean

/* Convert customer ratings to single value out of 5 */

Select Substring(CustomerRatings, 1, 3) as RatingsOutOf5
From PortfolioProject.dbo.CarDatasetv1_clean

Alter Table PortfolioProject.dbo.CarDatasetv1_clean
Add RatingsOutOf5 float;

Update PortfolioProject.dbo.CarDatasetv1_clean
Set RatingsOutOf5 = Substring(CustomerRatings, 1, 3)



----------------------------------------------------------------------------------------------------------------------
-- (4)
/* Check min/max price, types of cars, and most popular SUV with new table to confirm data cleaning */

/* Confirm new column added with only numeric value for Customer Rating */

Select *
From PortfolioProject.dbo.CarDatasetv1_clean

/* Find max and min price after removing duplicates */
/* Min car price is too low ($900) check Price($) column - OK after removing rows due to invalid sales figures */
/* Find max and min price per car type - SUV, coupe, minivan, etc. */

Select BodyType, min([Price($)]) as MinPrice, max([Price($)]) as MaxPrice
From PortfolioProject.dbo.CarDatasetv1_clean
Group By BodyType


/* List Cars that have largest sales figures */

Select CarMake, CarModel, BodyType, [SalesFigures(UnitsSold)], [Price($)]
From PortfolioProject.dbo.CarDatasetv1_clean
Order By [SalesFigures(UnitsSold)] Desc




/* Summarize number of gasoline, electric, and hybrid car options after removing duplicates and cleaning data */
/* Gas = 98, Electric = 3, Hybrid = 1 */

Select FuelType, Count(FuelType) as Qty
From PortfolioProject.dbo.CarDatasetv1_clean
Group By FuelType
Order By Qty DESC


/* Which gasoline engine SUV has highest ratings? */

Select CarMake, CarModel, Horsepower, [Mileage(MPG)], [Price($)], RatingsOutOf5
From PortfolioProject.dbo.CarDatasetv1_clean
Where BodyType = 'SUV' and FuelType = 'Gasoline'
Order By RatingsOutOf5 Desc, [Mileage(MPG)] Desc, [Price($)] Asc
/*Order By RatingsOutOf5 Desc*/
/*Order By [Mileage(MPG)] Desc, [Price($)] Asc*/
