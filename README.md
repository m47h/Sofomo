# README

This is a Sofomo JSON Application.

Seamless JWT authentication for Rails API
https://tools.ietf.org/html/rfc7519
## Description

Knock is an authentication solution for Rails API-only application based on JSON Web Tokens.

### What are JSON Web Tokens?

[![JWT](http://jwt.io/assets/badge.svg)](http://jwt.io/)

## Getting Started

### Installation

Just clone app from git and then execute:

    $ bundle install
    $ rails db:create
    $ rails db:migrate
    $ rails db:seed

### Authenticating from a web or mobile application

Example request to get a token from API:
```
POST /login
{"email": "senior@sofomo.io", "password": "Password1"}
```

Example response from the API:
```
200 OK
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InNlbmlvckBzb2ZvbW8uY29tIiwiZXhwIjoxNTY0NDI2NTczfQ.RUfCYY-YyDxbiAUxXmVJPn-RQWgVFc42hVi7v0qrGyQ"
}
```

To make an authenticated request to API, you need to pass the token via the request header:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InNlbmlvckBzb2ZvbW8uY29tIiwiZXhwIjoxNTY0NDI2NTczfQ.RUfCYY-YyDxbiAUxXmVJPn-RQWgVFc42hVi7v0qrGyQ

POST /geolocations/
params: {
    "ip_or_hostname": "sofomo.com"
}

GET /geolocations/sofomo.com

DELETE /geolocations/sofomo.com
```

**NB:** HTTPS should always be enabled when sending a password or token in your request.

### DEMO

https://sofomo.herokuapp.com/
POST /login
{"email": "senior@sofomo.io", "password": "Password1"}
