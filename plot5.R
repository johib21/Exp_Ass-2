library(dplyr)
if(!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")){
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        z<-unzip(temp,files = "summarySCC_PM25.rds")
        y<-unzip(temp,files = "Source_Classification_Code.rds")
        NEI <- readRDS(z)
        SCC <- readRDS(y)
}else{NEI <- readRDS("summarySCC_PM25.rds");SCC <- readRDS("Source_Classification_Code.rds")}

NEI<-NEI[(NEI$fips=="24510")&(NEI$type=="ON-ROAD"),]
NEI<-group_by(NEI,year)
NEI<-summarise(NEI,sum=sum(Emissions))

ggplot(data=NEI, aes(x=year, y=NEI$sum)) + 
        geom_line(aes(group=1, col=NEI$sum)) + geom_point(aes(size=2, col=NEI$sum)) + 
        ggtitle('Total Emissions of Motor Vehicle Sources in Baltimore City, Maryland') + 
        ylab(expression(paste('PM', ''[2.5]))) + 
        geom_text(aes(label=round(NEI$sum,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
        theme(legend.position='none') + scale_colour_gradient(low='black', high='red')
dev.copy(png, file="plot5.png", width=480, height=480) 
dev.off()