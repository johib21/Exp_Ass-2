library(dplyr);library(ggplot2)
if(!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")){
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        z<-unzip(temp,files = "summarySCC_PM25.rds")
        y<-unzip(temp,files = "Source_Classification_Code.rds")
        NEI <- readRDS(z)
        SCC <- readRDS(y)
}else{NEI <- readRDS("summarySCC_PM25.rds");SCC <- readRDS("Source_Classification_Code.rds")}

NEI$year<-as.factor(NEI$year)
NEI<-NEI[(NEI$fips=="24510"),]
NEI$type<-as.factor(NEI$type)
g<-ggplot(data=NEI, aes(x=year, y=log(Emissions))) + facet_grid(. ~ type) + guides(fill=F) +
        geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') +
        ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
        ggtitle('Emissions per Type in Baltimore City, Maryland') +
        geom_jitter(alpha=0.10)
print(g)
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()

