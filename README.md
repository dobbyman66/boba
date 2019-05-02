Proposal - Boba Tea Shop Reviews

Team Members

I-Ting (Tina) Wang, Kai-Ling (Cathy) Hung, Pei-Yu (Penny) Tsai,
April Ying-Chieh Chiu, Liang-Yun (Jack) Lin, Ssu-Ying (Rachel) Wang

Topic

After getting our degrees at the Marshall Business school, our team want to start our own business to put our knowledge in real practice. We want to open a new boba tea shop near USC (as boba tea shops around school are all so bad.. we see this as an opportunity!) What are the important features we should focus on? What are other tea shops’ pitfalls we can learn through their Yelp reviews?
Born in Taiwan and being passionate about boba tea, our team members treat this project as a good opportunity to understand North American customers’ tastes and preference.
However, we are flexible to change the story to be a data analyst/consultant to help the management team make data-drive decisions.


Dataset

Source: https://www.yelp.com/dataset/download
The dataset is from Yelp’s 2019 Data Challenge. We will focuses on two files and filter only the rows (boba tea shops’ reviews) that are of our interest
Before cleaning, 
The files are business.json (138MB) and review.json (5.35GB)
Business.json contains stores’ basic information (name, locations, etc)
Review.json contains all reviews of different stores.   
After initial cleaning,
The dataframe tea_review.csv contains variables like reviews (text), stars, tea shop name, stores (business_id), locations, and more.
40,277 observations/reviews, 486 tea shops; 368 brands(tea shop names)
About 30,000 good reviews (4,5 stars), 5000 bad reviews (1,2 stars)

Methodologies

Individual reviews: what attributes are important/most related to a positive or negative review.
Build a Logit regression, which predicts if a review is positive(4,5 stars) or negative (1,2).
By checking the most important highly-weighted features, we can find out the important attributes for customers to like/dislike a boba tea shop.
These attributes can be further categorized into product, operations, marketing perspectives for us to form recommendations.

Comments:

Prof Chen: Contrast boba tea shops with froyo shops (to compare baseline preferences / behaviors for dessert / snack restaurants).

Prof Chen: you might want to filter or pivot by user profiles and backgrounds as well - you can join to the users table to do so

Prof Chen: You can also include the features of the restaurants (like if they accept credit cards, do take out, etc. as other features in your model). 

What features are important or say related to the success of a tea shop? 

Success definition: restaurant_review_count, is_open, or restaurant_rating

Features include business_parking, ambience, attributes

May need variable business_id back to the dataset to get unique stores

sentimental categories: useful(17,275 reviews), cool(11,934 reviews), funny(8,641 reviews)

Risks

Our post-cleaning dataset may contain some reviews/documents that are not reviewing a boba tea shop
Reason is that we used a condition -- variable Categories contains ‘Bubble Tea’ -- to filter businesses/stores. A restaurant that sells bubble tea may be labeled with ‘Bubble Tea’, while is not perfect to be included in building our model.
Fortunately, we briefly check the dataset and found the cases are minimal, so for now we will ignore this risk.
The Yelp dataset contains businesses in North America but not those in California. This may reduce our model’s strength of predicting a boba tea shop’s success in California.
We understood this risk but we think utilizing the information we have will still help us form better decisions than make random decisions.
Applying the approach we created with local review data will be our future step!



