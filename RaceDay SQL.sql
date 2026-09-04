/* =========================================================
   RaceDay Database Schema
   PROG6212 POE - Part 1, Section C
   Target: SQL Server (SSMS)
   ========================================================= */

IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

/* Drop tables if they already exist, in dependency order,
   so the script can be re-run cleanly on a clean instance. */
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;
GO

/* =========================================================
   1. Roles
   ========================================================= */
CREATE TABLE dbo.Roles (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50) NOT NULL UNIQUE
);
GO

/* =========================================================
   2. Users
   ========================================================= */
CREATE TABLE dbo.Users (
    UserID          INT IDENTITY(1,1) PRIMARY KEY,
    RoleID          INT NOT NULL,
    FullName        NVARCHAR(100) NOT NULL,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID)
        REFERENCES dbo.Roles(RoleID)
);
GO

/* =========================================================
   3. Events
   ========================================================= */
CREATE TABLE dbo.Events (
    EventID         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID     INT NOT NULL,
    EventName       NVARCHAR(150) NOT NULL,
    EventDate       DATE NOT NULL,
    Location        NVARCHAR(150) NOT NULL,
    Description     NVARCHAR(1000) NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserID)
        REFERENCES dbo.Users(UserID)
);
GO

/* =========================================================
   4. Categories
   ========================================================= */
CREATE TABLE dbo.Categories (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    EventID         INT NOT NULL,
    CategoryName    NVARCHAR(100) NOT NULL,
    DistanceKm      DECIMAL(5,2) NOT NULL,
    MaxParticipants INT NOT NULL DEFAULT 100,
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID)
        REFERENCES dbo.Events(EventID)
);
GO

/* =========================================================
   5. Enrolments
   ========================================================= */
CREATE TABLE dbo.Enrolments (
    EnrolmentID     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID   INT NOT NULL,
    CategoryID      INT NOT NULL,
    EnrolmentDate   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantID)
        REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID)
        REFERENCES dbo.Categories(CategoryID),
    CONSTRAINT UQ_Enrolments_ParticipantCategory UNIQUE (ParticipantID, CategoryID)
);
GO

/* =========================================================
   6. Results
   ========================================================= */
CREATE TABLE dbo.Results (
    ResultID        INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID     INT NOT NULL UNIQUE,
    FinishTime      NVARCHAR(20) NULL,
    Position        INT NULL,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Finished',
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID)
        REFERENCES dbo.Enrolments(EnrolmentID)
);
GO

/* =========================================================
   Seed Data
   ========================================================= */

-- Roles
INSERT INTO dbo.Roles (RoleName) VALUES
    ('Organiser'),
    ('Participant');
GO

-- Users: 2 Organisers, 2 Participants
INSERT INTO dbo.Users (RoleID, FullName, Email, PasswordHash) VALUES
    (1, 'Sarah Mitchell', 'sarah.mitchell@raceday.com', 'HASHED_PASSWORD_1'),
    (1, 'David Nkosi',    'david.nkosi@raceday.com',    'HASHED_PASSWORD_2'),
    (2, 'Liam Botha',     'liam.botha@example.com',     'HASHED_PASSWORD_3'),
    (2, 'Priya Naidoo',   'priya.naidoo@example.com',   'HASHED_PASSWORD_4');
GO

-- Events: 3 events, each created by an Organiser
INSERT INTO dbo.Events (OrganiserID, EventName, EventDate, Location, Description) VALUES
    (1, 'City Spring Marathon',     '2026-10-10', 'Cape Town CBD',   'Annual road race through the city centre.'),
    (1, 'Riverside Fun Run',        '2026-11-02', 'Riverside Park',  'Family-friendly community fun run.'),
    (2, 'Trail Blazer Challenge',   '2026-11-22', 'Table Mountain',  'Off-road trail running event across varied terrain.');
GO

-- Categories: multiple per event
INSERT INTO dbo.Categories (EventID, CategoryName, DistanceKm, MaxParticipants) VALUES
    (1, '10km',            10.0, 200),
    (1, 'Half Marathon',   21.1, 150),
    (1, 'Full Marathon',   42.2, 100),
    (2, '5km Fun Run',      5.0, 300),
    (2, '10km',            10.0, 150),
    (3, 'Short Trail',     15.0, 80),
    (3, 'Long Trail',      30.0, 60);
GO

-- Enrolments: sample participants enrolling in categories
INSERT INTO dbo.Enrolments (ParticipantID, CategoryID, Status) VALUES
    (3, 1, 'Confirmed'),
    (3, 6, 'Confirmed'),
    (4, 2, 'Confirmed'),
    (4, 4, 'Confirmed');
GO

-- Results: sample finish data for completed enrolments
INSERT INTO dbo.Results (EnrolmentID, FinishTime, Position, Status) VALUES
    (1, '00:52:14', 3, 'Finished'),
    (3, '01:58:40', 12, 'Finished');
GO
