Objectives
==========

The main objective of this project is to generate SQL commands (mostly CREATE) that can generate a database system from a YAML configuration file.  

The program should also generate Java model classes with fields corresponding to the database schema.  

Goals
-----

- [DONE] Parse YAML file to get a Table-Row structure
- [DONE] Generate SQL file with commands that can be used in any DBMS (Database Management System)
- [    ] Generate a Java class for every table, containing fields for every table row
- [    ] Refactor code to significantly improve readability and maintainability
- [    ] Show Comprehensible error messages about mistakes on the YAML configuration file
- [    ] Make good unit tests to find any bugs and fix them
