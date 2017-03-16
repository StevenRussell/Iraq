
# Set working directory

setwd("//cdc.gov/private/L330/ykf1/New folder/Iraq") 

# Loading gplots package

library(gplots) 

#------------------------- Setting up data --------------------------------# 
 
# Importing CSV data (from SAS) 

mydata <- read.csv("//cdc.gov/private/L330/ykf1/New folder/Iraq/people per house3.csv") 

# Creating variable for proportion of HH members vaccinated 

mydata$HH.vac.prop <- mydata$hh_members_vaccinated / mydata$total_hh_members 

# Creating a variable for proportion not vaccinated 

mydata$HH.no.vac.prop <- 1 - mydata$HH.vac.prop 

# Sorting data 

mydata <- mydata[order(mydata$governorate, -mydata$HH.vac.prop),] 

#---------------------- Creating function for plots ---------------------# 

organ <- function(q, x){ 
    
    dat <- subset(mydata, mydata$camp == q ) 
     
    v <- rbind(dat$HH.vac.prop, dat$HH.no.vac.prop) 
    barplot2(v, beside=FALSE, main = q, 
             xlab= x,  
             ylab="Proportion of Household Members Vaccinated", 
             space = 0, 
             col=c("gray30", "grey"), 
             border= "black" 
             #legend= c("vaccinated", "unvaccinated") 
             ) 
   
     legend("bottomleft", fill=c("gray30", "grey"), c("vaccinated", "unvaccinated"), 
            col=c("gray30", "grey"), inset = c(0.05, 0.03), bg="white" ) 
    
} 

part1 <- replicate(27, "Households (n=") 
number.of.HHs <- as.vector(table(mydata$camp)) 
end.parenthesis = replicate(27, ")") 
n.text <- paste(part1, number.of.HHs, end.parenthesis, sep="") 

x <- as.list(table(mydata$camp)) 
camps <- names(x) 

#------------------------- Savings plots to one file --------------------------# 

pdf("OrganPlots.pdf") 
plots <- mapply(organ, camps, n.text) 
dev.off() 

# ------------------------ Function for plots by governorate ----------------------#    
    
organ2 <- function(q, x, t){ 
        dat <- subset(mydata, mydata$governorate == q ) 
    
        v <- rbind(dat$HH.vac.prop, dat$HH.no.vac.prop) 
        barplot2(v, beside=FALSE, main = t, 
                 xlab= x,  
                 ylab="Proportion of Household Members Vaccinated", 
                 space = 0, 
                 col=c("gray30", "grey"), 
                 border= "black" 
                 #legend= c("vaccinated", "unvaccinated") 
                 ) 
   
         legend("bottomleft", fill=c("gray30", "grey"), c("vaccinated", "unvaccinated"), 
                col=c("gray30", "grey"), inset = c(0.05, 0.03), bg="white" ) 
} 

part1 <- replicate(10, "Households (n=") 
number.of.HHs <- as.vector(table(mydata$governorate)) 
end.parenthesis = replicate(10, ")") 
n.text <- paste(part1, number.of.HHs, end.parenthesis, sep="") 

x <- as.list(table(mydata$governorate)) 
governorate <- names(x) 

# Adding coverage labels

cov <- c("99.3%", "55.0%", "65.7%", "98.2%", "98.6%", "65.2%", "83.6%", "96.8%", "99.0%", "97.5%") 
cov.title <- replicate(10, c(" (Coverage=")) 
t.text <- paste(governorate, cov.title, cov, end.parenthesis, sep="") 

# Saving plots to one file 

pdf("OrganPlots2.pdf") 
plots <- mapply(organ, governorate, n.text, t.text) 
dev.off() 
