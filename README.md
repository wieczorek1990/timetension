# Timetension

Implementations of simple datetime server.

## Implementation description

The purpose of the implementation is to respond with current server time on requests.

The implementation also stores historical request data in a database.

### Docker

Our application should live in a container which:

* should provide an image based on Debian or its derivatives
* should provide a `Dockerfile` and `docker-compose.yml` for running with `sudo docker-compose up`
* should provide a service named `${language}-${framework}-timing`
* should expose container port `80` as `8888`

### Server

The server:

* should bind to address `0.0.0.0` and port `80`
* should contain one `POST` route on `/`

### Database models

We should be able to define such models:

* `Request:{result:datetime, ip:string, id:integer, created_at:datetime, updated_at:datetime}`
  * `result:datetime` is current time on server when request is received
  * `ip:string` is the request IP which can be both IPv4 or IPv6
* `Difference:{result:float, request_id:integer, id:integer, created_at:datetime, updated_at:datetime}`
  * `result:float` is equal to current time on server subtracted by request `now:datetime` in seconds
  * `request_id:integer` is the foreign key to `Request:id:integer`

### API

The API:

* accepts and returns JSON body
* accepts optional `now:datetime` in requests
* only permits `now:datetime` in request body
  * when `now:datetime` is not present serializes `Request:{result:datetime}`
  * when `now:datetime` is present serializes `Request:{result:datetime}`, `Difference:{result:float}` and appends `average_difference:float`
* `average_difference:float` is the average difference for requests from the same IP address
* `datetime` should be serialized as `string` according to ISO 8601, e.g. `2016-10-13T16:08:34.453Z` and should only conform to this regex: `/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\z/`
* handles ORM errors
* should conform to [RAML API definition](api.raml)

### Sample responses

Default:

```
{
    "request": {
        "result": "2016-10-13T16:08:34.447Z"
    }
}
```

Extended:

```
{
    "average_difference": 0.249358422988692,
    "difference": {
        "result": 0.24935842298869212
    },
    "request": {
        "result": "2016-10-13T16:08:48.567Z"
    }
}
```

## Testing

The testing commands should be run on host.

### Correctness

#### httpie

Use for manually testing responses.

Install [httpie](https://github.com/jkbrzt/httpie) and test:

```
sudo apt-get install --assume-yes httpie

http POST localhost:8888
http POST localhost:8888 now="2016-10-13T16:08:48.570Z"
```

#### Airborne

Use for checking response types correctness.

Download [Airborne](https://github.com/brooklynDev/airborne) and run tests:

```
sudo apt-get install build-essential ruby ruby-dev
sudo gem install airborne minitest --pre --no-document

rspec test/spec.rb
```

### Performance

> Running simulations makes sense when using production setup and sane database.

#### Galting

Use for running simulations.

Download [Galting](http://gatling.io/) and unzip as `galting`.

Move `timing/test/TimingSimulation.scala` to `galting/user-files/simulations/`.

Run simulation:

```
bin/galting.sh -s timing.TimingSimulation
```

#### wrk

Use for stress tests.

Download, compile and install [wrk](https://github.com/wg/wrk):

```
sudo apt-get install build-essential

git clone git@github.com:wg/wrk.git
cd wrk
make
sudo cp wrk /usr/local/bin/
```

Run test supplying variables:

```
threads=4; connections=128; duration=8

wrk -t ${threads} -c ${connections} -d ${duration} -s test/default.lua http://localhost:8888
wrk -t ${threads} -c ${connections} -d ${duration} -s test/extended.lua http://localhost:8888
```
