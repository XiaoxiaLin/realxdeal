
# Task1: Database

**Load the data in csv in a database and analyze the data.**

I decided to build a custom Docker image based on MySQL to: 

- set up the database
- load the data
- query the data to answer the questions 
- save resuting output as csv files

### Requirments

- Docker >= 20.10.2
- An internet connection

### Instructions

To run the solution, one option is to pull my [custom Docker image on Docker Hub](https://hub.docker.com/r/xiaoxia908/my_image) and run the container:

```
docker pull xiaoxia908/my_image

docker run -d --name mysqlcontainer -v /PATH/TO/DIR/CONTAINING/postings_february.csv:/var/lib/mysql-files/ -e MYSQL_ROOT_PASSWORD=password xiaoxia908/my_image
```

Another option is to build the docker image from `Dockerfile` in the repository, and run the container.
(I've named the image 'realxdeal-image' in the command below):

```
docker build -t realxdeal-image .

docker run -d --name mysqlcontainer -v /PATH/TO/DIR/CONTAINING/postings_february.csv:/var/lib/mysql-files/ -e MYSQL_ROOT_PASSWORD=password realxdeal-image
```

Once the container has run, csv result tables for each question will be generated in the same folder where the input data `postings_february.csv` is stored. 


# Task2: Coding

### Serving the model

I decided to build Flask API to serve the univariate regression model, using a custom docker image based on python:3.6-buster.  

### Instructions to run in local

To run the solution in local, one option is to pull my [custom Docker image on Docker Hub](https://hub.docker.com/r/xiaoxia908/serving_ml_model) and run the container:

```
docker pull xiaoxia908/serving_ml_model

docker run -d --name myappcontainer  -p 5000:5000 -d xiaoxia908/serving_ml_model
```

Another option is to build the docker image from `Dockerfile` in the repository, and run the container:
(I've named the image 'serving_ml_model' in the command below)

```
docker build -t serving_ml_model .

docker run -d --name myappcontainer  -p 5000:5000 -d serving_ml_model
```

Now navigate to http://0.0.0.0:5000/ to get your predictions!

### Endpoints

There are different endpoints for `single prediction` and `batch predictions`:

**Single Predictions:**

- `single_prediction`: enter a number in the form to get prediction.
- `predict`: ask for a prediction directly on the url, for example 
'http://0.0.0.0:5000/predict?x=2' will return the prediction in json format.

    
**Batch Predictions:** 

- `batch_prediction`: upload a csv file and get prediction for all the values. 


### Deploying ML model

The application is dockerized and deployed onto Heroku:  https://realxdeal.herokuapp.com/

**Note:** 

The uploaded files and the logs are not persisted on Heroku, because this app is using [free dynos](https://devcenter.heroku.com/articles/dynos#ephemeral-filesystem). In the real scenario, any files that require permanence should be written to S3, or any persistent storage. 


# Task3: Productionization

Please see the jupyter notebook in Task3 folder.


# Rationale

I decided to use Docker for the tasks becuase I wanted the solution to be portable, easy to deliver, and simple for other users to run locally on their own machines without needing to install dependencies or deploy infrastructure.

