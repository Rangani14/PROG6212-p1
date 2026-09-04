# PROG6212-p1
Part 1
System overview

RaceDay is a South African road-event management platform designed for running, walking and cycling events. It replaces fragmented paper forms and spreadsheets with a structured system for event administration, participant enrolment and result tracking.

User roles

Organiser

An Organiser can:

create, update and delete events;

create and manage event categories;

view enrolments for events they manage;

capture participant finish times and finishing positions;

manage event banner images in the final MVC/Azure phase.

Participant

A Participant can:

create an account and log in;

browse events and available categories;

enrol in an event by selecting a category;

view their own enrolments;

view their own race results;

maintain profile details and upload a profile image in the final phase.

Part 1 contents

The /docs folder contains:

RaceDay_ERD.png – ERD showing entities, attributes, PKs, FKs and relationships.

RaceDay_ERD.dot – editable Graphviz source for the ERD.

API_Endpoint_Plan.md – planned REST API routes.

RaceDay_Database.sql – SQL Server schema, constraints and seed data.

Part1_Video_Script.md – suggested presentation structure.

Part1_Commit_Plan.md – examples of meaningful commit milestones.

Database design

The database contains seven entities:

Users

Events

Categories

Enrolments

Results

EventImages

ProfileImages

The Users.Role field distinguishes Organiser from Participant. Events are owned by Organisers. Enrolments link a Participant to an Event and a selected Category. A result belongs to a single enrolment.

The image tables are included now so the database is ready for the Azure Blob Storage requirement introduced in the final part.

SQL setup

Open SQL Server Management Studio.

Open /docs/RaceDay_Database.sql.

Execute the script.

Confirm that the RaceDayDB database is created.

Confirm that all seven tables exist and the final SELECT statements return seed data.

GitHub Actions

The workflow is stored at:

.github/workflows/part1-docs-check.yml

It checks that the required Part 1 files are present.

CI/CD evidence

Add your own successful GitHub Actions screenshot here before submission:

[INSERT GREEN BUILD SCREENSHOT HERE]

Video

Add your own unlisted YouTube link here:

[INSERT YOUTUBE LINK HERE]
