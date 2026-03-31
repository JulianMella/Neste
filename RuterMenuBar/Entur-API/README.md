 

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

#### multiModal Parameter

TL;DR at the bottom.

The multimodal parameter is set as "parent" by default. This means that if the search query matches a public transportation stop, it will return the parent NSR:StopPlace ID. This can potentially contain multiple public transportation stops as children. An example of this is querying for Bislett, Oslo, which gives __62039__ as the NSR:StopPlace id. 

At first, I thought it would be necessary to retrieve the children's NSR:StopPlace IDs, so that I could get the accurate information for each transportation method in that area. This could be done by setting the multiModal argument to __child__. When you query for Bislett, Oslo like that, you end up getting the following NSR:StopPlace IDs:

- 62039
- 6260
- 6263

Or by first getting the Parent ID and then utilizing the [National Stop Register Read API](https://developer.entur.org/stop-places-v1-read) to get all the children data.

Fortunately, it turns out it is not necessary to get the children at all. By following the logic that the Ruter application has, all of the necessary information for search results is contained within the Parent NSR:StopPlace. The deeper details of the children are stored within the JourneyPlanner API, and all of that data is retrievable by utilizing the Parent NSR:StopPlace!

TL;DR: Use the default ```multiModal=parent```, the parent NSR:StopPlace ID gives sufficient data. 

### Reverse

I will not focus on this yet since this is for a future iteration of the project.
