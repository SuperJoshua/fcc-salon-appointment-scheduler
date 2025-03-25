#! /bin/bash

# psql --username=freecodecamp --dbname=postgres

# create database salon;

# \c salon

PSQL="psql -d salon -U freecodecamp -t -X -c"

$PSQL "create table customers(customer_id serial primary key, name varchar(50) not null, phone varchar(15) unique not null)"

$PSQL "create table services(service_id serial primary key, name varchar(30) unique not null)"

$PSQL "create table appointments(appointment_id serial primary key, time varchar(10) not null, customer_id int, foreign key(customer_id) references customers(customer_id), service_id int, foreign key(service_id) references services(service_id))"

$PSQL "insert into services(name) values('mow it all off'), ('mow some of it off'), ('trim it a touch'), ('change the color'), ('make it wrinkly'), ('make it straight'), ('replace it with something')"
