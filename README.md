# PortfolioProject

Car Data in SQL
Analyze new car data from the following location: https://www.kaggle.com/datasets/anoopjohny/2023-cars-dataset/data

Review and clean table imported from downloaded csv file to summarize fuel, make/model, price, and ratings data.

Find duplicate records and write data without duplicates into a new table.  Using ROW_NUMBER() OVER/PARTITION BY, increment
number of records with same attributes.  Then delete all records with row number > 1.

Remove all records with invalid sales figures.

Convert varchar data for accelration and ratings to numeric for ranking these attributes.

After cleaning table, make a few queries - min/max price by car type, show top selling cars in descinding order, 
summarize cars by fuel type and ratings.
