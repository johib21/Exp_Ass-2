library(dplyr)
if(!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")){
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        z<-unzip(temp,files = "summarySCC_PM25.rds")
        y<-unzip(temp,files = "Source_Classification_Code.rds")
        NEI <- readRDS(z)
        SCC <- readRDS(y)
}else{NEI <- readRDS("summarySCC_PM25.rds");SCC <- readRDS("Source_Classification_Code.rds")}

NEI$year<-as.factor(NEI$year)
NEI<-group_by(NEI,year)
NEI<-summarise(NEI,sum=sum(Emissions))
barplot(NEI$sum,names.arg = c("1999","2002","2005","2008"),col = c("red","blue","green","gray"),xlab = "Years",
        ylab = expression(Sum*PM["2.5"]),main = "Total Emissions In USA")

dev.copy(png, file="plot1.png", width=480, height=480) 
dev.off()
