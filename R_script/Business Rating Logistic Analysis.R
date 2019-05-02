
library(dplyr)
library(stringr)
library(ISLR)
library(boot)
library(ggplot2)

data=read.csv("yelp_bubble_tea_reviews_encoded")




## group by business ID ##
data_1=data%>%
  filter(!str_detect(categories,"Vietnamese"))

data_2=data%>%
  group_by(business_id)%>%
  slice(which.min(restaurant_rating))

data_rating=data_1%>%
  group_by(review_rating)%>%
  summarise(number=n())

ggplot(data_rating, aes(x=review_rating, y=number))+
  geom_col()+
  theme_classic()+
  xlab("review ratings")+
  ylab("counts")

rest_rating=data_2%>%
  group_by(restaurant_rating)%>%
  summarise(number=n())
  
ggplot(rest_rating, aes(x=restaurant_rating, y=number))+
  geom_col()+
  theme_classic()+
  xlab("restaurant ratings")+
  ylab("counts")


## get rid of the unwanted columns ##
data_3=data_2%>%
  select(business_id,
         restaurant_rating,
         restaurant_review_count,
         lot,
         valet,
         garage,
         street,
         validated,
         CreditCards,
         BikeParking,
         PriceRange_1,
         Caters,
         OutdoorSeating,
         DogsAllowed,
         WiFi)

## get rid off na ##

data_4=data_3[complete.cases(data_3),]

data_parking=data_4%>%
  filter(street==1 & lot==1)

data_cater=data_4%>%
  filter(Caters==1)


## rate>=4.5=good, 4=neutral, <=3.5bad ##
data_4$rating_good=ifelse(data_4$restaurant_rating>=4.5, "1",
              ifelse(data_4$restaurant_rating==4, "neutral", "0"))

data_5=data_4%>%
  filter(rating_good!="neutral")
data_5$rating_good=as.numeric(data_5$rating_good)

data_parking=data_5%>%
  filter(street==1 & lot==1)


data_5_plot=data_5%>%
  group_by(rating_good)%>%
  count(rating_good)

ggplot(data_5_plot, aes(x=rating_good, y=n))+
  geom_bar(stat = "identity")+
  ggtitle("count for each categories: good rating>=4.5, bad rating<=3.5")+
  xlab("ratings")+
  ylab("counts")


##Logistic regression- see which predictor are significant:
glm.fits=glm(rating_good~restaurant_review_count+
               lot+
               valet+
               garage+
               street+
               validated+
               CreditCards+
               BikeParking+
               PriceRange_1+
               Caters+
               OutdoorSeating+
               DogsAllowed+
               WiFi, data=data_5)

summary(glm.fits)


## use cv to estimate test error
set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit=glm(rating_good~restaurant_review_count+
                lot+
                valet+
                garage+
                street+
                validated+
                CreditCards+
                BikeParking+
                PriceRange_1+
                Caters+
                OutdoorSeating+
                DogsAllowed+
                WiFi, data=data_5)
  cv.error.10[i]=cv.glm(data_5, glm.fit, K=10)$delta[1]
  
}
cv.error.10



## take out caters since it's not relevant
glm.fits_caters=glm(rating_good~restaurant_review_count+
                      lot+
                      valet+
                      garage+
                      street+
                      validated+
                      CreditCards+
                      BikeParking+
                      PriceRange_1+
                      OutdoorSeating+
                      DogsAllowed+
                      WiFi, data=data_5)

summary(glm.fits_caters)


set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit_caters=glm(rating_good~restaurant_review_count+
                lot+
                valet+
                garage+
                street+
                validated+
                CreditCards+
                BikeParking+
                PriceRange_1+
                OutdoorSeating+
                DogsAllowed+
                WiFi, data=data_5)
  cv.error.10[i]=cv.glm(data_5, glm.fit_caters, K=10)$delta[1]
  
}
cv.error.10



  
### trial & error ###

## scenario 1 ==> bad rating:1,2,3 (0) ; good rating: 5(1)
## out of 374 restaurant, 123 has a rating of 4, that's 32.89%, kind of too high to throw out##

  ##Logistic regression- see which predictor are significant:
glm.fits=glm(rating_good~restaurant_review_count+
               lot+
               valet+
               garage+
               street+
               validated+
               CreditCards+
               BikeParking+
               PriceRange_1+
               Caters+
               OutdoorSeating+
               DogsAllowed+
               WiFi, data=data_5)

summary(glm.fits)
## none of the variables are significant

   ## use cv to estimate test error
set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit=glm(rating_good~restaurant_review_count+
                lot+
                valet+
                garage+
                street+
                validated+
                CreditCards+
                BikeParking+
                PriceRange_1+
                Caters+
                OutdoorSeating+
                DogsAllowed+
                WiFi, data=data_5)
  cv.error.10[i]=cv.glm(data_5, glm.fit, K=10)$delta[1]
  
}
cv.error.10
#[1] 0.07906769 0.07688117 0.07979780 0.08146607 0.08004256 0.07735161 0.07960323 0.07823678
#[9] 0.07879464 0.07762878 ==> looks not bad



## take out caters since it's not relevant
glm.fits_caters=glm(rating_good~restaurant_review_count+
               lot+
               valet+
               garage+
               street+
               validated+
               CreditCards+
               BikeParking+
               PriceRange_1+
               OutdoorSeating+
               DogsAllowed+
               WiFi, data=data_5)

summary(glm.fits_caters)
## none of the variables are significant

## use cv to estimate test error
set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit_caters=glm(rating_good~restaurant_review_count+
                lot+
                valet+
                garage+
                street+
                validated+
                CreditCards+
                BikeParking+
                PriceRange_1+
                OutdoorSeating+
                DogsAllowed+
                WiFi, data=data_5)
  cv.error.10[i]=cv.glm(data_5, glm.fit_caters, K=10)$delta[1]
  
}
cv.error.10




## scenario 2 ==> bad rating:1,2,3 (0) ; good rating: 4,5(1)
### since only 20 restaurant with rateing=5, make rateing=4 good rating as well

data_3$rating_good_1=ifelse(data_3$restaurant_rating>=4, 1, 0)

data_3_plot=data_3%>%
  group_by(rating_good_1)%>%
  count(rating_good_1)

ggplot(data_3_plot, aes(x=rating_good_1, y=n))+
  geom_bar(stat = "identity")+
  ggtitle("count for each categories: good rating-4,5, bad rating-1,2,3")+
  xlab("ratings")+
  ylab("counts")

230/(144+230) #[1] 0.6149733==>61% are good rating

##Logistic regression- see which predictor are significant:
glm.fits_1=glm(rating_good_1~restaurant_review_count+
               lot+
               valet+
               garage+
               street+
               validated+
               CreditCards+
               BikeParking+
               PriceRange_1+
               Caters+
               OutdoorSeating+
               DogsAllowed+
               WiFi, data=data_3)

summary(glm.fits_1)
## only 3 are significnat: creditcards, caters, garage(maybe...)

## use cv to estimate test error
set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit_1=glm(rating_good_1~restaurant_review_count+
                lot+
                valet+
                garage+
                street+
                validated+
                CreditCards+
                BikeParking+
                PriceRange_1+
                Caters+
                OutdoorSeating+
                DogsAllowed+
                WiFi, data=data_3)
  cv.error.10[i]=cv.glm(data_3, glm.fit_1, K=10)$delta[1]
  
}
cv.error.10
#[1] 0.2099683 0.2116918 0.2122565 0.2135115 0.2112843 0.2096412 0.2119607 0.2116948
#[9] 0.2085924 0.2123591 ==> much bigger

## try taking the unsignificant predictors away

set.seed(1)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit_2=glm(rating_good_1~CreditCards+Caters, data=data_3)
  cv.error.10[i]=cv.glm(data_3, glm.fit_2, K=10)$delta[1]
  
}
cv.error.10
#[1] 0.2024602 0.2019398 0.2017361 0.2023322 0.2013537 0.2015160 0.2026697 0.2026526
#[9] 0.2024927 0.2026338 ==> improve by a little; around 80% test error rate, which is 
# good consider that only 61% are good ratings 


# conclusion - under scenario 2, only credit card and catering matters!!



  

