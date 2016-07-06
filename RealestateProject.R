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
    
  
    htmlapt <- getURL(urlapt)
    
    docapt = htmlParse(htmlapt, asText=TRUE)
    
    #type
    
    apt<- readHTMLTable(urlapt, header = T, stringsAsFactors = FALSE)
    na.omit(apt)
   # apt[!apt$col %in% " ", ]
    as.data.frame(apt)
    aptd <- rbind.fill(aptd,apt)
 
    
  #amenities
    amenitiespath <- xpathSApply(docapt, "/html/body/div[2]/div/div[3]/div[3]/section[2]/div[2]/div/div", xmlValue)
    amen <- paste(amenitiespath, collapse = "\n")
    amenities<- append(amenities,amen)
    }
  }
}  

