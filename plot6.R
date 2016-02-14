library(dplyr)
if(!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")){
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        z<-unzip(temp,files = "summarySCC_PM25.rds")
        y<-unzip(temp,files = "Source_Classification_Code.rds")
        NEI <- readRDS(z)
        SCC <- readRDS(y)
}else{NEI <- readRDS("summarySCC_PM25.rds");SCC <- readRDS("Source_Classification_Code.rds")}

NEI<-NEI[((NEI$fips=="06037")|(NEI$fips=="24510"))&(NEI$type=="ON-ROAD"),]
NEI$fips<-as.factor(NEI$fips)
levels(NEI$fips)<-c("LA County, California","Baltimore City, Maryland")
NEI<-group_by(NEI,year,fips)
NEI<-summarise(NEI,sum=sum(Emissions))
names(NEI)[2]<-"Location"
ggplot(data=NEI, aes(x=year, y=sum, fill=Location)) +
        geom_bar(stat="identity", position=position_dodge(), colour="black")+
        ylab(expression(paste('PM', ''[2.5])))+
        ggtitle("Total Emissions from Motor Vehicle Sources in LA County, 
                California and Baltimore City,Maryland")

dev.copy(png, file="plot6.png", width=480, height=480) 
dev.off()