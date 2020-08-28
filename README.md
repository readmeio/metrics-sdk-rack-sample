# ReadMe Ruby SDK - Sample Rack Application

This repository contains a basic RACK application configured with the ReadMe
metrics gem to log all requests and responses to the ReadMe metrics API.

## Dependencies and Requirements

* Ruby 2.7.1

You'll also need an account for the [ReadMe Dashboard](dash.readme.com) to create a project and obtain an
API key.

## Setup

Clone the repo and in the root directory run:
```
bundle install
```

Open `config.ru` and replace `"YOUR_API_KEY"` with the key you obtained from the
ReadMe dashboard.

## Run the application

Once everything is installed and setup you can run the application with:

```
rackup
```

By default this will run at `localhost:9292`

## Endpoints

### Cars list

`GET http://localhost:9292/cars`

#### Response

```JSON
[
  {
    "id": 1,
    "make": "Volkswagen",
    "model": "Golf",
    "year": 2021
  },
  {
    "id": 2,
    "make": "Volkswagen",
    "model": "GTI",
    "year": 2021
  },
  {
    "id": 3,
    "make": "Volkswagen",
    "model": "Golf R",
    "year": 2020
  },
  {
    "id": 4,
    "make": "Audi",
    "model": "RS3",
    "year": 2020
  },
  {
    "id": 5,
    "make": "Audi",
    "model": "TT",
    "year": 2020
  },
  {
    "id": 6,
    "make": "Audi",
    "model": "R8",
    "year": 2020
  }
]
```

### Find car by id

`GET http://localhost:9292/cars/:id`

#### Response

```JSON
{
  "id": 1,
  "make": "Volkswagen",
  "model": "Golf",
  "year": 2021
}
```

### Add a new car to the list

`POST http://localhost:9292/cars/`

```JSON
{
  "make": "Tesla",
  "model": "Model S",
  "year": 2021
}
```

#### Response

```JSON
{
  "id": 7,
  "make": "Tesla",
  "model": "Model S",
  "year": 2021
}
```

### Delete a car from the list

`DELETE http://localhost:9292/cars/:id`

#### Response

`Car with id :id deleted`
