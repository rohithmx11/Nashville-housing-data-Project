--Cleaning data in SQL Queries


Select * from PortfolioProject.dbo.NashvilleHousing



--Standardize sale date


Select SaleDate ,CONVERT(DATE,SaleDate) ,SALEDATECONVERTED
from PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing 
set 
SaleDate = CONVERT(DATE,SaleDate)


ALTER TABLE NashvilleHousing 
ADD SALEDATECONVERTED DATE;



update NashvilleHousing 
set 
SALEDATECONVERTED = CONVERT(DATE,SaleDate)



--Populate Proplerty Address Data 



Select * 
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress , b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a  
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a  
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address,City,State)


Select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select SUBSTRING (PropertyAddress ,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
       SUBSTRING (PropertyAddress , CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress)) as Address
	   
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);



UPDATE NashvilleHousing 
SET
PropertySplitAddress = SUBSTRING (PropertyAddress ,1,CHARINDEX(',',PropertyAddress)-1) 




ALTER TABLE NashvilleHousing 
ADD PropertySplitCity Nvarchar(255);



UPDATE NashvilleHousing 
SET
PropertySplitCity =  SUBSTRING (PropertyAddress , CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress))



SELECT * FROM PortfolioProject.dbo.NashvilleHousing




SELECT OwnerAddress FROM PortfolioProject.dbo.NashvilleHousing
where OwnerAddress is not null


SELECT 
  PARSENAME(REPLACE(OwnerAddress,',','.'),3),
  PARSENAME(REPLACE(OwnerAddress,',','.'),2),
  PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing
where OwnerAddress is not null



ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255);



UPDATE NashvilleHousing 
SET
OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',','.'),3)




ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255);



UPDATE NashvilleHousing 
SET
OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)



ALTER TABLE NashvilleHousing 
ADD OwnerSplitState Nvarchar(255);



UPDATE NashvilleHousing 
SET
OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)



SELECT * FROM PortfolioProject.dbo.NashvilleHousing



--Change Y and N to Yes and No In "Sold as Vacant" field


select DISTINCT soldasvacant, count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2




select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end 
FROM PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
                        when SoldAsVacant = 'N' then 'No'
	                    else SoldAsVacant
						END



--Remove Duplicates

with row_numCTE AS (


select *,
     ROW_NUMBER()OVER (PARTITION BY ParcelId,
	                                PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
									ORDER BY UniqueID
									) row_num 
									          

FROM PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
SELECT *  FROM row_numCTE
WHERE row_num >1
--ORDER BY PropertyAddress



--Delete Unused Columns

select * from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict , PropertyAddress


ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN saledate