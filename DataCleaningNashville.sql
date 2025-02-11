/*

Cleaning Data in SQL Queries

*/


--SELECT *
--FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]



-- Populate Property Address Data

/*
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)] AS a
JOIN PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)] AS b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)] AS a
JOIN PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)] AS b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

*/


-- Breaking out address into individual columns (add, city, state)


SELECT PropertyAddress
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]


SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address2
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]



ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
ADD OwnerSplitAddress NVARCHAR(255);


UPDATE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
WHERE OwnerAddress IS NOT NULL


ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
ADD OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)






SELECT OwnerSplitAddress
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]




SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
WHERE OwnerAddress IS NOT NULL


SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]






-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant, CASE WHEN SoldAsVacant = 1 THEN 'Yes' 
					WHEN SoldAsVacant = 0 THEN 'No'
					ELSE CAST(SoldAsVacant AS VARCHAR(10)) END AS SoldYN

FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]



ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
ALTER COLUMN SoldAsVacant NVARCHAR(10)

UPDATE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 1 THEN CAST('Yes' AS VARCHAR(10)) 
					WHEN SoldAsVacant = 0 THEN CAST('No' AS VARCHAR(10))
					ELSE CAST('Idk' AS VARCHAR(10)) END




-- REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num

FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1

--selected, then deleted


-- Deleting Unused Columns


SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]


ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning(Sheet1)]
DROP COLUMN SaleDate