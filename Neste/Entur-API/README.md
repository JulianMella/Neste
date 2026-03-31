 

## Introduction

This document describes my current understanding of the Entur API endpoints.

## [Geocoder](https://developer.entur.org/pages-geocoder-intro)

The Geocoder API will be useful to search for public transportation stops from both a search field and based upon the location given by CoreLocation.

### Autocomplete

The autocomplete endpoint is the initial step for much of the functionality of the Neste Menu Bar Application. This endpoint has autocomplete functionality (Hence the name), which allows you to query for a Location such as "Bisle" and it will give you all the relevant results matching that query (Bislett, Oslo for example). 

```
https://api.entur.io/geocoder/v1/autocomplete?text={Location}
```

This is great, since it allows users to be imprecise with their search queries and still get relevant results.

#### Query Results

The query returns a list of ```features```, which contains the following relevant information:

-  Each feature has a geographical position given in the form of coordinates. The coordinates will definitely come in handy for map-based visualization.

- Each feature has a ```properties``` object, which contains all of the data that we care about (I will only be mentioning the ones that are relevant):
  - ```id```: The kind of feature this is. As far as I can see, this can either be
    - ```NSR:GroupOfStopPlaces:{amount}``` 
    - ```NSR:StopPlace:{ID}```__The relevant identifier for this application__
    - ```KVE:TopographicPlace...```

Everything beyond this point is only for id = NSR:StopPlace:{ID}

- ```county``` :  Since this application will be firstly developed for Oslo, I will filter results based upon this as well.
- ```name```: The name of the stop place.
- ```category```: A list of public transportation that runs through this area.

It also includes ```tariff_zones```, which indicate what kind of Ruter membership is required for a given route. This information has been intentionally excluded from the application. The main priority of Neste is quick and easy access to public transportation routes, not fare information. Other sources already cover this adequately. 

#### Note aobut the multiModal Parameter

TL;DR: Use the default ```multiModal=parent```, the parent NSR:StopPlace ID gives sufficient data. 

The multimodal parameter is set as "parent" by default. This means that if the search query matches a public transportation stop, it will return the parent NSR:StopPlace ID. This can potentially contain multiple public transportation stops as children. An example of this is querying for Bislett, Oslo, which gives __62039__ as the NSR:StopPlace id. 

At first, I thought it would be necessary to retrieve the children's NSR:StopPlace IDs, so that I could get the accurate information for each transportation method in that area. This could be done by setting the multiModal argument to __child__. When you query for Bislett, Oslo like that, you end up getting the following NSR:StopPlace IDs:

- 62039
- 6260
- 6263

Or by first getting the Parent ID and then utilizing the [National Stop Register Read API](https://developer.entur.org/stop-places-v1-read) to get all the children data.

Fortunately, it turns out it is not necessary to get the children at this current iteration. The only data point we cannot get from the parent is the coordinates of a specific child, since map integration is further down the line, this will be left as a to-do. The other details from children are stored within the JourneyPlanner API, and all of that data is retrievable by utilizing the Parent NSR:StopPlace.

### Reverse

I will not focus on this yet since this is for a future iteration of the project.

## [JourneyPlanner](https://developer.entur.org/pages-journeyplanner-journeyplanner)

### Public Transportation Details

At this point, we have retrieved all of the necessary information from Geocoder. To get deeper information about the public transportation provided at a specific NSR:StopPlace:{ID}, we must move on to JourneyPlanner. 

Although JourneyPlanner is initially designed to plan a journey between point A and B, it also provides the final destination, the number of the public transportation and the transportation mode. This is all retrievable by utilizing the following GraphQL query. Keep in mind that at this point, we have already filtered for results in Oslo in Geocoder.

```json
{
  stopPlace(id: "NSR:StopPlace:{ID}") {
    estimatedCalls(
    	numberOfDeparturesPerLineAndDestinationDisplay: 1
      numberOfDepartures: 100
      whiteListed: {authorities: ["RUT:Authority:RUT"]}
    ) {
      destinationDisplay {
        frontText
      }
      serviceJourney {
        journeyPattern {
          line {
            publicCode
          }
        }
        transportMode
      }
    }
  }
}
```

Let us dissect this query a little bit, first beginning with the estimatedCalls. 

Since the purpose of this query is to get all of the public transportation available at a specific stop, we limit ```numberOfDeparturesPerLineAndDestinationDisplay``` to 1. By doing so, we get one unique result per transportation that exists at that specific stop. 

```numberOfDepartures``` is by default set to 5, the issue with this is that if a stop with more than 5 transportation methods is selected, only 5 will be shown. Therefore, 100 has been set as a safe ceiling, but it could definitely be lower. Either way, this guarantees that all the available transportation methods are displayed. 

Since this application will initially be for public transportation in Oslo, the whitelist has been set to only show results from the Ruter authority. To get this authority ID, I had to do the following GraphQL query, which gives a list of all the existing public transportation authorities in Norway.

```
{
	authorities
	{
		id
	}
}
```

Now let us move on to the actual results.

```destinationDisplay.frontText``` gives the final destination of a specific public transport.

```serviceJourney.journeyPattern.line.publicCode``` gives the number of a specific public transport.

```serviceJourney.transportMode``` gives the type of vehicle of a specific public transport.



### Journey Planning

This will be written once implementation up until this point is finished!
