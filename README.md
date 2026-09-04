 RACEDAY-P1
raceday poe part 1
RaceDay

 Description

RaceDay is a race event management system that allows *Organisers* to create and
manage running events, and *Participants* to browse events and enrol in race
categories. The system tracks events, their categories (e.g. 5km, 10km, half
marathon), participant enrolments, and finishing results.

This repository contains the planning and database design for Part 1 of the POE:
an Entity Relationship Diagram, a RESTful API endpoint plan, and a SQL Server
script that creates and seeds the full database schema.

 Roles

The system supports two roles:

- Organiser — creates and manages events, defines race categories for each
  event, views who has enrolled in a category, and records finishing results
  once a race is complete.
- Participant — browses available events and categories, enrols in a
  category, views their own enrolments, and checks their own results once
  published.

 Repository Structure


/docs
  RaceDay_ERD.pdf                  - Entity Relationship Diagram
  RaceDay_API_Endpoint_Plan.md     - API endpoint specification table
  RaceDay_Schema.sql               - SQL Server database creation + seed script
.github/workflows/
  validate-docs.yml                - GitHub Actions workflow validating repo structure
README.md


 Database

The database consists of six entities: Roles, Users, Events, Categories,
Enrolments, and Results. See docs/RaceDay_ERD.pdf for the full data model
and docs/RaceDay_Schema.sql for the corresponding schema and seed data.

To run the script:

1. Open SQL Server Management Studio (SSMS) and connect to a clean SQL Server
   instance.
2. Open docs/RaceDay_Schema.sql.
3. Execute the script. It creates the RaceDayDB database, all tables with
   their constraints, and seeds sample data (2 organisers, 2 participants,
   3 events, 7 categories, and sample enrolments and results).

 API Plan

The full endpoint plan — covering authentication, user profile, events,
categories, enrolments, and results — is in
docs/RaceDay_API_Endpoint_Plan.md.

 CI/CD

A GitHub Actions workflow (.github/workflows/validate-docs.yml) runs on every
push and pull request. It checks that the /docs folder exists and contains
the required ERD image, endpoint plan, and SQL script, and that README.md is
present at the repository root.





 Video Walkthrough

<!-- Replace with your unlisted YouTube link -->
[YouTube video walkthrough](https://youtu.be/YOUR-VIDEO-ID)

The video walks through:
- The planning documents and how they map to the RaceDay system
- The ERD and the reasoning behind each entity and relationship
- The API endpoint plan and key design choices
- A live run of the SQL script in SSMS

## Author


KOKETSO KHALO-ST10477909
