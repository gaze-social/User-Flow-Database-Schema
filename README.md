# User-Flow-Database-Schema
# Database Schema for Gaze Project

## Introduction

This repository contains the SQL database schema for the MVP User Flow project. This schema includes tables for storing user data, reviews, and other essential entities.

## Installation

1. Install PostgreSQL or your database of choice.
2. Clone this repository: `git clone <repository_URL>`.
3. Navigate to the cloned repository: `cd <repository_name>`.
4. Run the SQL scripts to set up the database.

## Schema

The database schema includes the following tables:

- `Shopper`
- `Seller`
- `Review`
- `Video`
- `Comment`
- `LikeTable`
- `Follow`

For detailed structure, see `db_schema.sql`.

## Archiving and Backup

Triggers have been added to archive data before deletion. The archived data is stored in tables with `_Archive` suffixes.

## Logging

Logging mechanisms are set up to track metrics like user registration and review sharing.

## Photo Storage

Photos are stored efficiently with compressed resolution and optimized file size.

## Contributing

1. Fork the repository.
2. Create a new branch: `git checkout -b <new_branch_name>`.
3. Make your changes.
4. Push to your fork and submit a pull request.
