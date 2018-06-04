# Models

## Connection
The core class handling connections between users. A connection record in the database with the status `:active` means that there is a sharing connection between two users and they can access each other's data. The connection object has two fields for storing the user information, `:initiated_by` and `:to`. At this point these fields are functionally identical for an active connection.

Determining a users active connections requires going outside of the typical Active Record relationship methods, because a user may be on either the `:initiated_by` or `:to` fields, so we ultimately need to load up a union of those two fields.

## User
The user record. This consists of just the basic display name information and a uuid to tie back to user objects from other databases.

## Score
A single named score for a user. We do each score as a seperate database role to make it easier to replace scores when new data comes along, and to make it easier to share scores more granularly in the future. 
