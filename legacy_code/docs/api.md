# Axon-Connect API

This document outlines the behavior and structure of the Axon-Connect API. Axon Connect is the primary api used by both third party and internal applications to load profile data on thinkers other than the currently logged in user.

## Core Concepts

## Authorization

Authorization in the api is modeled around the concept of "connections". A connection is a representation of the fact that a thinker has "connected" to another thinker or a third party application and granted them the right to see their profile data. Api clients can only see data for thinkers who have made a connection with the entity (organization, application, person) that they are currently authenticated as.

Initially every connection will be treated the same, and return the same list of scores no matter what. Eventually though, we may allow thinkers to control which scores are shared as a part of which connection.

## Authentication
The connect API has a couple of ways to authenticate requests made to it, as outlined below

#### Cookie Based
This is the mechanism meant for internal client-side applications. The api simply uses the existing session cookie to authenticate the user, which will allow these javascript apps to make requests for any thinkers that have connected directly to the currently logged in user.

#### Token based authentication
This is the mechanism meant for mobile device applications. Devices can request an authentication token by providing the username and password for a specific thinker, and receive a token that can be used for subsequent requests. Similarly to cookie based authentication the requests are made in the authentication context of a specific thinker, and so the results will only show data for other thinkers who have made a connection to that user.

#### OAuth
This mechanism is meant for third party applications that want to access data  on multiple thinkers, and want to make requests acting as an application or an organization, not acting as an individual thinker. Applications or organization wanting to use this mechanism will have to be registered with Axon-Connect, and thinkers will need to grant those application explicit permissions to their data.

## JSON API

The Axon-Connect conforms to the JSON API specification. For more on JSON API check out the [website](http://jsonapi.org/)

## Resource Endpoints

#### `/thinkers`
The `/thinkers` endpoint returns a list of thinkers that the client has access to. With no parameters, the response will be a list of thinkers and basic metadata and the key scores that make up their "profile" like so.

    {      
      data: [{
        "id": "E_zUrN7gRj6A9Hr0M3tzcA",
        "type": "thinker",
        "attributes": {
          name: "Brian Brains",
          "email": "bb@hbdi.com",
          "profile": {
            "four_quadrant_score": { "A":65, "B":92, "C":87, "D":104 },
            "under_pressure_score": { "A":65, "B":92, "C":87, "D":104 },
            "preference_codes": { "A":3, "B":2, "C":2, "D":1}
          },
        "relationships": {
          "scores": {
            "links": {
              "related": "http://example.com/connections/E_zUrN7gRj6A9Hr0M3tzcA/scores"
            }
          }               
        }
      },
      {
        "id": "e1NHum6KQXWX2qF4u_v9Aw",
        "type": "thinker",
        "attributes":{
          name: "Ned Herrmann",
          email: "nedherrmann@hbdi.com",
          "profile": {
            "four_quadrant_score": { "A":65, "B":92, "C":87, "D":104 },
            "under_pressure_score": { "A":65, "B":92, "C":87, "D":104 },
            "preference_codes": { "A":3, "B":2, "C":2, "D":1}
          }
        },
        "relationships": {
          "scores": {
            "links": {
              "related": "http://example.com/connections/e1NHum6KQXWX2qF4u_v9Aw/scores"
            }
          }               
        }
      }
    ]}

##### Pagination
TODO

##### Filters
You can filter the results of this endpoint using the `filter` query parameter like so `?filter[id]=<id>` for a single id, or `?filter[id][]=<id1>&filter[id][]=<id2>` for multiple ids

You can use the following attributes to filter
* `id`
* `email`

#### `/thinkers/id`
This endpoint will return the data for a specific thinker identified by an id.

    {
      data:{
        "id": "e1NHum6KQXWX2qF4u_v9Aw",
        "type": "thinker",
        "attributes":{
          name: "Ned Herrmann",
          email: "nedherrmann@hbdi.com",
          "profile": {
            "four_quadrant_score": { "A":65, "B":92, "C":87, "D":104 },
            "under_pressure_score": { "A":65, "B":92, "C":87, "D":104 },
            "preference_codes": { "A":3, "B":2, "C":2, "D":1 }
          }
        },
        "relationships": {
          "scores": {
            "links": {
              "related": "http://example.com/connections/e1NHum6KQXWX2qF4u_v9Aw/scores"
            }
          }
        }
      }
    }

 The `scores` relationship offers access to the collection of scores beyond the 3 included in the `profile` attribute directly on this resource. Resources from this relationship can be loaded via an `include` parameter. If you only want certain scores, you can do something like

    ?include=scores&filter[scores][name]=key_descriptors`

#### `/thinkers/id/scores`
This endpoint returns a list of scores tied to the thinker defined by `id`, looking something like this.

    {
      data:[{
        "id": "CAsLCAsDBQwDCQcGBAUIDA",
        "type": "score",
        "attributes" : {
          "name": "preference_codes",
          "data" : { "A":3, "B":2, "C":2, "D":1 }
        },
        "relationships": {
          "thinker": {
            "links": {
              "related": "http://example.com/connections/e1NHum6KQXWX2qF4u_v9Aw"
            }
          }
        }
      },
      {
        "id": "AAkMBgUPCAkCCwwGBA4MDw",
        "type": "score",
        "attributes" : {
          "name": "four_quadrant_score",
          "data" : { "A":95, "B":77, "C":102, "D":66 }
        },
        "relationships": {
          "thinker": {
            "links": {
              "related": "http://example.com/connections/e1NHum6KQXWX2qF4u_v9Aw"
            }
          }
        }
      }]
    }

##### Filters

The syntax for filter is the same as other endpoints. Filterable fields are:
* name

#### `/connections`
The connections endpoint returns the actual information about the "connections" that determine whether or not a given client can see data on the `/thinkers` endpoint

    {
      data:[{
        "id": "Dw8IDAYLBQwBBQAHBAsJDw",
        "type": "connection",
        "attributes" : {
          "status" : "active"
        },
        "relationships": {
          "to": {
            "links":{
              "self": "http://example.com/connections/Dw8IDAYLBQwBBQAHBAsJDw/relationships/to",
              "related": "http://example.com/connections/Dw8IDAYLBQwBBQAHBAsJDw/relationships/to"
            },
            "data" : {"type": "thinker", id: "DQ4NBg4FBAUNDgwJBAUDCQ"}
          }          
        }
      },
      {
        "id": "DQIEAA4DAQQGCQwDBAQAAg",
        "type": "connection",
        "attributes" : {
          "status" : "pending",
          "email_to_invite": "sue.blue@hbdi.com"
        },
        "relationships": {
          "to": {
            "links":{
              "self": "http://example.com/connections/Dw4NAgAEBwQNCQQJBAUJBw/relationships/to",
              "related": "http://example.com/connections/Dw4NAgAEBwQNCQQJBAUJBw/relationships/to"
            },
            "data" : null
          }          
        }
      }]
    }

Notice how the relationships for a connection depend upon it's status. Pending connections don't have any data for the `to` relationship.

##### Creating Connections
Creating connections can only be done when authenticated in the context of a thinker. As a result third party applications cannot currently automatically create new connections for a user. To create a new connection between the currently logged in thinker and another, you post a request like this.

    {
      "data": {
        "type": "connection",
        "attributes": {
          invited-email-address: "sue.blue@hbdi.com"  
        },        
      }
    }

Where email to invite is the email address of the thinker who you'd like to create a connection to.

#### `/connections/id/events`
Over the life of a connection the members involved may want to edit or change the connection in some way. Approving a pending connection, removing an existing connection, etc. The `connections/id/events` endpoint allows clients to initiate these events.

A get request to this endpoint looks like this

    {
      "data": [{
        "type": "connectionEvent",
        "attributes": {
          "performed_at": "1994-11-05T13:15:30Z"
          "event": "approved"
        },
        "relationships": {
          "connection": {
            "data": { "type": "connection", "id": "AAoKAQoOAQkODQQMBAgFBA" }
          },
          "initiated_by": {
            "data": { "type": "initiated_by", "id": "CgAHAQoCDA4EDQkDBAoGAg" }
          }
        }]
      }
    }

##### Creating new event
To create and new event you can post to this endpoint like this.

    {
      "data": {
        "type": "connectionEvent",
        "attributes": {
          "event": "approved"
        }  
      }
    }

The valid values for the `event` attribute are `approved`, `removed` and `declined`
