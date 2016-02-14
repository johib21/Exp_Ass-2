library(dplyr)
if(!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")){
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        z<-unzip(temp,files = "summarySCC_PM25.rds")
        y<-unzip(temp,files = "Source_Classification_Code.rds")
        NEI <- readRDS(z)
        SCC <- readRDS(y)
}else{NEI <- readRDS("summarySCC_PM25.rds");SCC <- readRDS("Source_Classification_Code.rds")}

SCC<-SCC[grepl("coal",SCC$Short.Name),]
NEI<-merge(NEI,SCC,by = "SCC")
NEI$year<-as.factor(NEI$year)
NEI<-group_by(NEI,year)
NEI<-summarise(NEI,sum=sum(Emissions))

ggplot(data=NEI, aes(x=year, y=NEI$sum/1000)) + 
geom_line(aes(group=1, col=NEI$sum)) + geom_point(aes(size=2, col=NEI$sum)) + 
ggtitle(expression('Total Emissions of PM'[2.5])) + 
ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) + 
geom_text(aes(label=round(NEI$sum/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
theme(legend.position='none') + scale_colour_gradient(low='black', high='red')
dev.copy(png, file="plot4.png", width=480, height=480) 
dev.off()