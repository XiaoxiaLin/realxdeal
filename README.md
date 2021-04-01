
# Task1: Database

**Load the data in csv in a database and analyze the data.**

I decided to build a custom Docker image based on MySQL to: 

- set up the database
- load the data
- query the data to answer the questions 
- save resuting output as csv files

### Requirments

    Docker >= 20.10.2
    An internet connection

### Instructions
My custom docker image is stored at the following location: 
https://hub.docker.com/r/xiaoxia908/my_image

To run the solution:

```
docker pull xiaoxia908/my_image

docker run -d --name mysqlcontainer -v /PATH/TO/DIR/CONTAINING/postings_february.csv:/var/lib/mysql-files/ -e MYSQL_ROOT_PASSWORD=password xiaoxia908/my_image
```

Once the container has run, csv result tables for each question will be generated in the same folder where the input data 'postings_february.csv' is stored. 

### Rationale

I decided to use Docker for the task becuase I wanted the solution to be portable, easy to deliver, and simple for other users to run locally on their own machines without needing to install dependencies or deploy infrastructure.


# Task2: Coding

### Expose the model

I decided to build Flask API to serve the univariate regression model, dockerize the application and deploy it onto Heroku. 
    
    https://realxdeal.herokuapp.com/

There are different endpoints for single and batch predictions.

**Single Predictions:**

- 'single_prediction': when you enter a number in the form to get prediction.
- 'predict': when you ask for a prediction directly on the url, for example 
'https://realxdeal.herokuapp.com/predict?x=2' will return the prediction in json format.

    
**Batch Predictions:** 

- 'batch_prediction': when you upload a csv file and get prediction for all the values. 

### Instructions

My custom docker image is built based on python:3.6-buster with everything needed to run the app in local. 

The image is stored at the following location: 
https://hub.docker.com/r/xiaoxia908/my_app_image

Run the following command to test the API in local:
```
docker pull xiaoxia908/my_app_image
docker run -d --name myappcontainer  -p 5000:5000 -d xiaoxia908/my_app_image
```

Now navegate to http://0.0.0.0:5000/ to get your predictions!

If you are interested to check the underlying code and folder structures, run the following command:

```
docker exec -it myappcontainer bash
```

## Note 

The uploaded files and the logs are not persisted on Heroku, because this app is using [free dynos](https://devcenter.heroku.com/articles/dynos#ephemeral-filesystem). In the real scenario, any files that require permanence should be written to S3, or a similar durable store. 