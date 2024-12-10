DROP TABLE IF EXISTS participated CASCADE;
DROP TABLE IF EXISTS owns CASCADE;
DROP TABLE IF EXISTS accident CASCADE;
DROP TABLE IF EXISTS car CASCADE;
DROP TABLE IF EXISTS person CASCADE;

-- Create person table
CREATE TABLE person (
    driver_id VARCHAR(10),
    name VARCHAR(50),
    address VARCHAR(100),
    PRIMARY KEY (driver_id)
);

-- Create car table
CREATE TABLE car (
    license VARCHAR(10),
    model VARCHAR(50),
    year INT,
    PRIMARY KEY (license)
);

-- Create accident table
CREATE TABLE accident (
    report_number VARCHAR(10),
    date DATE,
    location VARCHAR(100),
    PRIMARY KEY (report_number)
);

-- Create owns table with ON DELETE CASCADE to handle deletions properly
CREATE TABLE owns (
    driver_id VARCHAR(10),
    license VARCHAR(10),
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id),
    FOREIGN KEY (license) REFERENCES car(license) ON DELETE CASCADE
);

-- Create participated table
CREATE TABLE participated (
    report_number VARCHAR(10),
    driver_id VARCHAR(10),
    damage_amount NUMERIC(10, 2),
    PRIMARY KEY (report_number, driver_id),
    FOREIGN KEY (report_number) REFERENCES accident(report_number),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
);


INSERT INTO person (driver_id, name, address)
VALUES ('D101', 'John Smith', '123 Main St');

INSERT INTO car (license, model, year)
VALUES ('ABC123', 'Mazda', 2010);

INSERT INTO owns (driver_id, license)
VALUES ('D101', 'ABC123');

INSERT INTO accident (report_number, date, location)
VALUES ('12345', '2009-06-15', 'Main Street');

INSERT INTO participated (report_number, driver_id, damage_amount)
VALUES ('12345', 'D101', 5000.00);



-- a. Find the total number of people who owned cars that were involved in accidents in 2009
SELECT COUNT(DISTINCT owns.driver_id) AS total_people
FROM owns
JOIN participated ON owns.driver_id = participated.driver_id
JOIN accident ON participated.report_number = accident.report_number
WHERE EXTRACT(YEAR FROM accident.date) = 2009;

-- b. Add a new accident to the database; assume any values for required attributes
INSERT INTO accident (report_number, date, location)
VALUES ('12346', '2009-06-20', 'Broadway Ave');

-- c. Delete the Mazda belonging to “John Smith”
DELETE FROM owns
WHERE license IN (
    SELECT owns.license
    FROM owns
    JOIN person ON owns.driver_id = person.driver_id
    JOIN car ON owns.license = car.license
    WHERE person.name = 'John Smith' AND car.model = 'Mazda'
);

DELETE FROM car
WHERE license = 'ABC123';