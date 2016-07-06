library(XML)
library(RCurl)
library(RJSONIO)
library(data.table)
library(plyr)

url= "http://www.rent.com/california/san-francisco/apartments_condos_houses_townhouses"
urlapt <- NULL
aptd <-data.frame(matrix(ncol = 8, nrow = 0))
setnames(aptd, old=c("X1","X2","X3","X4","X5","X6","X7","X8"), new=c("ID","x","Price","Bed/Bath","Area","Availability","telephone","y"))

amenities <- NULL

i=1

for (i in 1:2)
{

  {
  if (i == 1) url1 <- url
  
  else
  
    url1 <-paste(url,"?page=",i,sep="")

  }


  html <- getURL(url1)
  doc = htmlParse(html, asText=TRUE)
  links <- xpathSApply(doc, "//a/@href")
  free(doc)
  links <- as.vector(links)
  x <- "http://www.rent.com"
  
  
  for (j in 1:length(links))
  {
    if (startsWith(links[j],"/california/san-francisco-apartments/")) 
      
      {
      urlapt <- paste(x,links[j], sep="")
      
      print(urlapt)
     # [1] "http://www.rent.com/california/san-francisco-apartments/bayside-village-4-100014295"
     # [1] "http://www.rent.com/california/san-francisco-apartments/carmel-rincon-4-467368"
  
    htmlapt <- getURL(urlapt)
    
    docapt = htmlParse(htmlapt, asText=TRUE)
    
    #type
    
    apt<- readHTMLTable(urlapt, header = T, stringsAsFactors = FALSE)
    na.omit(apt)
   # apt[!apt$col %in% " ", ]
    as.data.frame(apt)
    aptd <- rbind.fill(aptd,apt)
    aptd

#output for dataframe aptd 
#1           1D   $3158 - $3978 /mo 1 bed / 1 bath 625 sqft  1 Unit Available   
#2           1U   $3166 - $3790 /mo 1 bed / 1 bath 790 sqft  1 Unit Available
#3   Sacremento   $3182 - $4071 /mo 1 bed / 1 bath 739 sqft 3 Units Available
#4           1S   $3311 - $4111 /mo 1 bed / 1 bath 658 sqft 3 Units Available
#5          1BA   $3459 - $4166 /mo 1 bed / 1 bath 709 sqft  1 Unit Available
#6       Powell Contact for Pricing 1 bed / 1 bath 658 sqft       UNAVAILABLE
#7           1W Contact for Pricing 1 bed / 1 bath 652 sqft       UNAVAILABLE
#8           1E Contact for Pricing 1 bed / 1 bath 679 sqft       UNAVAILABLE
#9       Sutter Contact for Pricing 1 bed / 1 bath 719 sqft       UNAVAILABLE
#10          1Z Contact for Pricing 1 bed / 1 bath 728 sqft       UNAVAILABLE


 
    
  #amenities
    amenitiespath <- xpathSApply(docapt, "/html/body/div[2]/div/div[3]/div[3]/section[2]/div[2]/div/div", xmlValue)
    amen <- paste(amenitiespath, collapse = "\n")
    amenities<- append(amenities,amen)
    amenities
   # "DishwasherGarbage DisposalMicrowaveRefrigerator\nLaundry Facility\nCovered Parking\nPets OK\nBalcony, Patio, DeckCable ReadyFireplaceHigh Speed Internet AccessOversized ClosetsView\nElevator, Extra Storage, Fitness Center, Gated Access, On Site Maintenance, On Site Management, On Site Patrol\nEasy freeway access, Fully Equipped Fitness Center, Handicap Accessible, Professional Friendly Management, Public Transportation, Short Term Available, Starbucks and Post Office on Site"
    }
  }
}  

