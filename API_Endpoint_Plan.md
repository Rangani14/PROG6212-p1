# RaceDay API Endpoint Plan

**Module:** Programming 2B (PROG6212)\
**Project:** RaceDay Event Management System\
**Part:** Part 1 -- System Planning and Database\
**Document:** API Endpoint Plan\
**Version:** 1.0

------------------------------------------------------------------------

## 1. Purpose

This document defines the RESTful API endpoints planned for the RaceDay
system before API development begins.

The RaceDay platform supports two user roles:

-   **Organiser** -- can create, edit and delete events, manage event
    categories, capture participant results, and view enrolments for
    their events.
-   **Participant** -- can create an account, browse events, enter
    events by selecting a category, view their own enrolments, and track
    their personal results.

The endpoint plan is designed to cover the required Authentication, User
Profile, Events, Categories, Event Enrolments, and Results
functionality. The implemented API in Part 2 should closely follow this
plan.

> **Important:** Part 1 is a planning stage. No API implementation code
> is included in this document.

------------------------------------------------------------------------

## 2. API Conventions

### Base URL

``` text
/api
```

### HTTP Methods

  Method   Purpose
  -------- --------------------------------------------
  GET      Retrieve existing information
  POST     Create a new resource or perform an action
  PUT      Update an existing resource
  DELETE   Remove an existing resource

### Authentication and Authorisation

The API will use session-based authentication. After a successful login,
the authenticated user's ID and role will be maintained in the
server-side session.

Protected endpoints will require an authenticated session. Role-specific
endpoints will additionally check whether the logged-in user is an
**Organiser** or **Participant**.

Passwords will never be stored in their original form. Passwords will be
hashed before being stored in the database.

------------------------------------------------------------------------

# 3. Authentication Endpoints

Authentication allows users to register, log in, and end their
authenticated session.

  ---------------------------------------------------------------------------------------------------
  HTTP Method Route                  Description     Role Required   Request Body   Expected Response
  ----------- ---------------------- --------------- --------------- -------------- -----------------
  POST        `/api/auth/register`   Creates a new   None (Public)   `firstName`,   **201 Created**
                                     RaceDay user                    `lastName`,    -- account
                                     account and                     `email`,       created. **400
                                     validates the                   `phone`,       Bad Request** --
                                     selected role.                  `password`,    invalid data or
                                                                     `role`         role. **409
                                                                                    Conflict** --
                                                                                    email already
                                                                                    registered.

  POST        `/api/auth/login`      Authenticates a None (Public)   `email`,       **200 OK** --
                                     registered user                 `password`     login successful
                                     and creates a                                  and session
                                     server-side                                    created. **400
                                     session                                        Bad Request** --
                                     containing the                                 missing/invalid
                                     user ID and                                    input. **401
                                     role.                                          Unauthorized** --
                                                                                    incorrect
                                                                                    credentials.

  POST        `/api/auth/logout`     Ends the        Any             None           **200 OK** --
                                     current user's  authenticated                  session ended.
                                     authenticated   user                           **401
                                     session.                                       Unauthorized** --
                                                                                    no active
                                                                                    session.
  ---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 4. User Profile Endpoints

Both Organisers and Participants must be able to view and update their
own profile information.

  ---------------------------------------------------------------------------------------------
  HTTP Method Route             Description     Role Required   Request Body   Expected
                                                                               Response
  ----------- ----------------- --------------- --------------- -------------- ----------------
  GET         `/api/users/me`   Returns the     Any             None           **200 OK** --
                                profile         authenticated                  current user's
                                information of  user                           profile. **401
                                the currently                                  Unauthorized**
                                authenticated                                  -- user is not
                                user.                                          logged in. **404
                                                                               Not Found** --
                                                                               user profile
                                                                               does not exist.

  PUT         `/api/users/me`   Updates the     Any             `firstName`,   **200 OK** --
                                currently       authenticated   `lastName`,    profile updated.
                                authenticated   user            `email`,       **400 Bad
                                user's profile                  `phone`        Request** --
                                information.                                   invalid data.
                                                                               **401
                                                                               Unauthorized**
                                                                               -- user is not
                                                                               logged in. **409
                                                                               Conflict** --
                                                                               email already
                                                                               belongs to
                                                                               another user.
  ---------------------------------------------------------------------------------------------

**Security rule:** A user can only update their own profile through
these endpoints. A Participant cannot use the profile endpoint to change
their role to Organiser.

------------------------------------------------------------------------

# 5. Event Endpoints

Events contain the required event information:

-   Name
-   Description
-   Date
-   Location
-   Distance
-   Event type

Event type must be one of:

-   `Run`
-   `Walk`
-   `Cycle`

Organisers manage events, while both roles can view events.

  ---------------------------------------------------------------------------------------------
  HTTP Method Route                Description    Role        Request Body     Expected
                                                  Required                     Response
  ----------- -------------------- -------------- ----------- ---------------- ----------------
  GET         `/api/events`        Returns a list None        None             **200 OK** --
                                   of RaceDay     (Public)                     list of events.
                                   events that                                 
                                   users can                                   
                                   browse.                                     

  GET         `/api/events/{id}`   Returns the    None        None             **200 OK** --
                                   full details   (Public)                     event details.
                                   of one event,                               **404 Not
                                   including its                               Found** -- event
                                   basic event                                 does not exist.
                                   information.                                

  POST        `/api/events`        Creates a new  Organiser   `name`,          **201 Created**
                                   event with its             `description`,   -- event
                                   name,                      `date`,          created. **400
                                   description,               `location`,      Bad Request** --
                                   date,                      `distance`,      invalid event
                                   location,                  `eventType`      data. **401
                                   distance, and                               Unauthorized**
                                   event type.                                 -- not logged
                                                                               in. **403
                                                                               Forbidden** --
                                                                               Participant
                                                                               attempted
                                                                               access.

  PUT         `/api/events/{id}`   Updates an     Organiser   `name`,          **200 OK** --
                                   existing                   `description`,   event updated.
                                   event.                     `date`,          **400 Bad
                                                              `location`,      Request** --
                                                              `distance`,      invalid data.
                                                              `eventType`      **401
                                                                               Unauthorized**
                                                                               -- not logged
                                                                               in. **403
                                                                               Forbidden** --
                                                                               incorrect role.
                                                                               **404 Not
                                                                               Found** -- event
                                                                               does not exist.

  DELETE      `/api/events/{id}`   Deletes an     Organiser   None             **204 No
                                   existing event                              Content** --
                                   managed by the                              event deleted.
                                   Organiser.                                  **401
                                                                               Unauthorized**
                                                                               -- not logged
                                                                               in. **403
                                                                               Forbidden** --
                                                                               incorrect role.
                                                                               **404 Not
                                                                               Found** -- event
                                                                               does not exist.
                                                                               **409 Conflict**
                                                                               -- event cannot
                                                                               be deleted
                                                                               because
                                                                               dependent
                                                                               records prevent
                                                                               deletion.
  ---------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 6. Category Endpoints

Categories allow Organisers to define age-based or distance-based
categories for an event, such as:

-   Under 20
-   Senior
-   10km
-   21km

Both roles can view categories.

  -----------------------------------------------------------------------------------------------------------
  HTTP Method Route                                Description   Role        Request Body    Expected
                                                                 Required                    Response
  ----------- ------------------------------------ ------------- ----------- --------------- ----------------
  GET         `/api/events/{eventId}/categories`   Returns all   None        None            **200 OK** --
                                                   available     (Public)                    list of
                                                   categories                                categories.
                                                   belonging to                              **404 Not
                                                   a specific                                Found** -- event
                                                   event.                                    does not exist.

  GET         `/api/categories/{id}`               Returns       None        None            **200 OK** --
                                                   details for   (Public)                    category
                                                   one event                                 details. **404
                                                   category.                                 Not Found** --
                                                                                             category does
                                                                                             not exist.

  POST        `/api/events/{eventId}/categories`   Creates an    Organiser   `name`,         **201 Created**
                                                   age or                    `minimumAge`,   -- category
                                                   distance                  `maximumAge`,   created. **400
                                                   category for              `distance`      Bad Request** --
                                                   a specific                                invalid category
                                                   event.                                    data. **401
                                                                                             Unauthorized**
                                                                                             -- not logged
                                                                                             in. **403
                                                                                             Forbidden** --
                                                                                             Participant
                                                                                             attempted
                                                                                             access. **404
                                                                                             Not Found** --
                                                                                             event does not
                                                                                             exist.

  PUT         `/api/categories/{id}`               Updates an    Organiser   `name`,         **200 OK** --
                                                   existing                  `minimumAge`,   category
                                                   event                     `maximumAge`,   updated. **400
                                                   category.                 `distance`      Bad Request** --
                                                                                             invalid data.
                                                                                             **401
                                                                                             Unauthorized**
                                                                                             -- not logged
                                                                                             in. **403
                                                                                             Forbidden** --
                                                                                             incorrect role.
                                                                                             **404 Not
                                                                                             Found** --
                                                                                             category does
                                                                                             not exist.

  DELETE      `/api/categories/{id}`               Deletes an    Organiser   None            **204 No
                                                   existing                                  Content** --
                                                   event                                     category
                                                   category.                                 deleted. **401
                                                                                             Unauthorized**
                                                                                             -- not logged
                                                                                             in. **403
                                                                                             Forbidden** --
                                                                                             incorrect role.
                                                                                             **404 Not
                                                                                             Found** --
                                                                                             category does
                                                                                             not exist. **409
                                                                                             Conflict** --
                                                                                             category is
                                                                                             already linked
                                                                                             to an enrolment.
  -----------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 7. Event Enrolment Endpoints

Event enrolments connect:

-   A Participant
-   An Event
-   The selected Category

Participants create their own enrolments. Organisers can view enrolments
belonging to events that they manage.

  ----------------------------------------------------------------------------------------------------------------
  HTTP Method Route                                Description     Role Required   Request Body   Expected
                                                                                                  Response
  ----------- ------------------------------------ --------------- --------------- -------------- ----------------
  POST        `/api/events/{eventId}/enrolments`   Enrols the      Participant     `categoryId`   **201 Created**
                                                   logged-in                                      -- enrolment
                                                   Participant                                    created. **400
                                                   into an event                                  Bad Request** --
                                                   using a                                        invalid
                                                   selected                                       category/event
                                                   category.                                      information.
                                                                                                  **401
                                                                                                  Unauthorized**
                                                                                                  -- not logged
                                                                                                  in. **403
                                                                                                  Forbidden** --
                                                                                                  Organiser
                                                                                                  attempted
                                                                                                  participant
                                                                                                  enrolment. **404
                                                                                                  Not Found** --
                                                                                                  event or
                                                                                                  category does
                                                                                                  not exist. **409
                                                                                                  Conflict** --
                                                                                                  Participant is
                                                                                                  already enrolled
                                                                                                  in the event.

  GET         `/api/users/me/enrolments`           Returns all     Participant     None           **200 OK** --
                                                   events in which                                participant's
                                                   the logged-in                                  enrolment list.
                                                   Participant is                                 **401
                                                   enrolled.                                      Unauthorized**
                                                                                                  -- not logged
                                                                                                  in. **403
                                                                                                  Forbidden** --
                                                                                                  Organiser
                                                                                                  attempted
                                                                                                  access.

  GET         `/api/events/{eventId}/enrolments`   Returns all     Organiser       None           **200 OK** --
                                                   enrolments for                                 list of event
                                                   a specific                                     enrolments.
                                                   event so the                                   **401
                                                   Organiser can                                  Unauthorized**
                                                   view                                           -- not logged
                                                   participating                                  in. **403
                                                   users and their                                Forbidden** --
                                                   selected                                       Participant
                                                   categories.                                    attempted
                                                                                                  access. **404
                                                                                                  Not Found** --
                                                                                                  event does not
                                                                                                  exist.

  GET         `/api/enrolments/{id}`               Returns details Any             None           **200 OK** --
                                                   of one          authenticated                  enrolment
                                                   enrolment.      user with                      details. **401
                                                   Access is       permission                     Unauthorized**
                                                   limited to the                                 -- not logged
                                                   relevant                                       in. **403
                                                   Participant or                                 Forbidden** --
                                                   the Organiser                                  user does not
                                                   responsible for                                have permission.
                                                   the event.                                     **404 Not
                                                                                                  Found** --
                                                                                                  enrolment does
                                                                                                  not exist.
  ----------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 8. Results Endpoints

Results are captured by Organisers after an event. The required result
information includes:

-   Finish time
-   Finishing position

Participants can view their own results.

  -------------------------------------------------------------------------------------------------------------------------
  HTTP Method Route                                    Description     Role Required Request Body          Expected
                                                                                                           Response
  ----------- ---------------------------------------- --------------- ------------- --------------------- ----------------
  POST        `/api/enrolments/{enrolmentId}/result`   Records the     Organiser     `finishTime`,         **201 Created**
                                                       finish time and               `finishingPosition`   -- result
                                                       finishing                                           recorded. **400
                                                       position for a                                      Bad Request** --
                                                       Participant                                         invalid result
                                                       after the                                           data. **401
                                                       event.                                              Unauthorized**
                                                                                                           -- not logged
                                                                                                           in. **403
                                                                                                           Forbidden** --
                                                                                                           Participant
                                                                                                           attempted
                                                                                                           access. **404
                                                                                                           Not Found** --
                                                                                                           enrolment does
                                                                                                           not exist. **409
                                                                                                           Conflict** --
                                                                                                           result already
                                                                                                           exists.

  PUT         `/api/results/{id}`                      Corrects or     Organiser     `finishTime`,         **200 OK** --
                                                       updates an                    `finishingPosition`   result updated.
                                                       existing                                            **400 Bad
                                                       participant                                         Request** --
                                                       result.                                             invalid result
                                                                                                           data. **401
                                                                                                           Unauthorized**
                                                                                                           -- not logged
                                                                                                           in. **403
                                                                                                           Forbidden** --
                                                                                                           incorrect role.
                                                                                                           **404 Not
                                                                                                           Found** --
                                                                                                           result does not
                                                                                                           exist.

  GET         `/api/users/me/results`                  Returns the     Participant   None                  **200 OK** --
                                                       logged-in                                           participant's
                                                       Participant's                                       results. **401
                                                       personal race                                       Unauthorized**
                                                       results and                                         -- not logged
                                                       performance                                         in. **403
                                                       history.                                            Forbidden** --
                                                                                                           Organiser
                                                                                                           attempted
                                                                                                           access.

  GET         `/api/results/{id}`                      Returns one     Participant   None                  **200 OK** --
                                                       result where    (own result)                        result details.
                                                       the             / Organiser                         **401
                                                       authenticated   (managed                            Unauthorized**
                                                       user has        event)                              -- not logged
                                                       permission to                                       in. **403
                                                       view it.                                            Forbidden** --
                                                                                                           insufficient
                                                                                                           permission.
                                                                                                           **404 Not
                                                                                                           Found** --
                                                                                                           result does not
                                                                                                           exist.
  -------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 9. Role-Based Access Summary

  Resource / Action         Public   Participant   Organiser
  ----------------------- -------- ------------- -----------
  Register                     Yes           Yes         Yes
  Login                        Yes           Yes         Yes
  Logout                        No           Yes         Yes
  View events                  Yes           Yes         Yes
  View event details           Yes           Yes         Yes
  Create event                  No            No         Yes
  Update event                  No            No         Yes
  Delete event                  No            No         Yes
  View categories              Yes           Yes         Yes
  Create category               No            No         Yes
  Update category               No            No         Yes
  Delete category               No            No         Yes
  View own profile              No           Yes         Yes
  Update own profile            No           Yes         Yes
  Enrol in event                No           Yes          No
  View own enrolments           No           Yes          No
  View event enrolments         No            No         Yes
  Capture result                No            No         Yes
  Update result                 No            No         Yes
  View own results              No           Yes          No

------------------------------------------------------------------------

# 10. Standard HTTP Status Codes

The API will use HTTP status codes consistently.

  -----------------------------------------------------------------------
  Status Code             Meaning                 Example
  ----------------------- ----------------------- -----------------------
  200 OK                  Request completed       Successful GET or PUT
                          successfully            

  201 Created             A new resource was      Registration, event,
                          created                 category, enrolment, or
                                                  result

  204 No Content          Resource was            Event/category deletion
                          successfully deleted    

  400 Bad Request         Request contains        Invalid event type or
                          invalid data            missing required field

  401 Unauthorized        User is not             Accessing a protected
                          authenticated or        endpoint without a
                          credentials are invalid session

  403 Forbidden           User is authenticated   Participant attempting
                          but does not have the   to create an event
                          required                
                          role/permission         

  404 Not Found           Requested resource does Event ID does not exist
                          not exist               

  409 Conflict            Request conflicts with  Duplicate email or
                          existing data or        duplicate enrolment
                          relationships           
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 11. Example Request Bodies

These examples show the planned JSON structure that can be used when
implementing the API in Part 2.

## Register

``` json
{
  "firstName": "John",
  "lastName": "Mokoena",
  "email": "john@example.com",
  "phone": "0821234567",
  "password": "SecurePassword123!",
  "role": "Participant"
}
```

## Login

``` json
{
  "email": "john@example.com",
  "password": "SecurePassword123!"
}
```

## Create Event

``` json
{
  "name": "Johannesburg City Run",
  "description": "Annual road running event.",
  "date": "2026-10-18T07:00:00",
  "location": "Johannesburg",
  "distance": 10,
  "eventType": "Run"
}
```

## Create Category

``` json
{
  "name": "Senior 10km",
  "minimumAge": 18,
  "maximumAge": 39,
  "distance": 10
}
```

## Create Enrolment

``` json
{
  "categoryId": 3
}
```

## Capture Result

``` json
{
  "finishTime": "00:52:34",
  "finishingPosition": 47
}
```

------------------------------------------------------------------------

# 12. Security and Validation Considerations

The following rules should be followed when the endpoints are
implemented in Part 2:

1.  Passwords must be hashed and never stored as plain text.
2.  Authentication must create and maintain a server-side session.
3.  The session must maintain the authenticated user's ID and role.
4.  Protected endpoints must reject unauthenticated requests.
5.  Organiser-only endpoints must reject Participants with
    `403 Forbidden`.
6.  Participant-only endpoints must reject Organisers with
    `403 Forbidden`.
7.  Users must only be able to view or modify data they are authorised
    to access.
8.  Event types must be restricted to `Run`, `Walk`, or `Cycle`.
9.  Required fields must be validated before records are inserted or
    updated.
10. Duplicate participant enrolments should be prevented.
11. Foreign-key relationships must be validated before related records
    are created.
12. Appropriate `404 Not Found` responses should be returned when IDs do
    not exist.
13. Appropriate `409 Conflict` responses should be returned where an
    operation conflicts with existing data.
14. Swagger should expose all implemented endpoints and provide clear
    descriptions, expected inputs, and responses.

------------------------------------------------------------------------

# 13. Planned API Structure

The planned API is grouped into six main functional areas:

``` text
/api
├── /auth
│   ├── POST /register
│   ├── POST /login
│   └── POST /logout
│
├── /users
│   └── GET  /me
│       PUT  /me
│
├── /events
│   ├── GET  /
│   ├── GET  /{id}
│   ├── POST /
│   ├── PUT  /{id}
│   ├── DELETE /{id}
│   └── /{eventId}/categories
│
├── /categories
│   ├── GET  /{id}
│   ├── PUT  /{id}
│   └── DELETE /{id}
│
├── /enrolments
│   └── GET /{id}
│
└── /results
    ├── GET /{id}
    └── PUT /{id}
```

Participant-specific operations are exposed through the authenticated
user's resource:

``` text
/api/users/me/enrolments
/api/users/me/results
```

Event-specific operations are exposed through the event resource:

``` text
/api/events/{eventId}/enrolments
/api/events/{eventId}/categories
/api/events/{eventId}/enrolments
```

------------------------------------------------------------------------

# 14. Alignment With Part 1 Requirements

This endpoint plan covers all six API areas specifically required in the
Part 1 brief:

-   Authentication -- registration and login
-   User Profile -- view and update own profile
-   Events -- view and Organiser CRUD
-   Categories -- view and Organiser management
-   Event Enrolments -- Participant enrolment and Organiser viewing
-   Results -- Organiser capture and Participant viewing

The plan also includes logout and individual-resource endpoints to
support a complete session-based REST API.

The Part 1 brief requires the endpoint table to contain **HTTP Method,
Route, Description, Role Required, Request Body, and Expected
Response**, and requires the plan to be submitted as a Markdown or PDF
file in the `/docs` folder. The implemented Part 2 API should closely
match this plan.

------------------------------------------------------------------------

# 15. Part 2 Implementation Reminder

When moving from Part 1 to Part 2, the following technologies and
requirements should be maintained:

-   ASP.NET Core Web API
-   C#
-   SQL Server
-   Entity Framework Core using the Code-First approach
-   Session-based authentication
-   Role-based access for Organiser and Participant
-   Password hashing
-   Swagger
-   Unit testing
-   GitHub Actions CI/CD

The database schema implemented in Part 2 must remain consistent with
the ERD and SQL script produced for Part 1.
