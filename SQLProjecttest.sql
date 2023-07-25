
CREATE TABLE CUSTOMER (
  CU_id NUMERIC(6) NOT NULL ,
  CU_name VARCHAR(20) NOT NULL,
  CU_Mobile CHAR(8) CHECK (CU_Mobile >= '90000000' or CU_Mobile >= '70000000' ),
  CU_age   NUMERIC(2)   CHECK (CU_age >18)
);

CREATE TABLE CAR (
  CA_id NUMERIC(6) NOT NULL,
  CA_make VARCHAR(20) NOT NULL,
  CA_name CHAR(8),
  CA_year NUMERIC(4),
  CA_color CHAR(10),
  CA_Price DECIMAL(10, 2)
);

CREATE TABLE RENT (
  RE_id NUMERIC(6)NOT NULL,
  RE_name VARCHAR(20) NOT NULL,
  RE_DateTaken DATE NOT NULL,
  RE_DateReturn DATE ,
  RE_idCar NUMERIC(6)NOT NULL,
  RE_idCu NUMERIC(6)NOT NULL,
  RE_idManager VARCHAR(10) NOT NULL,
  CONSTRAINT Check_RENT_RE_DateReturn CHECK(RE_DateReturn>RE_DateTaken)
);

CREATE TABLE MANAGER (
  M_id VARCHAR(10) NOT NULL,
  M_name VARCHAR(20) NOT NULL,
  M_Idcar NUMERIC(6) NOT NULL
);

INSERT INTO CUSTOMER (CU_id, CU_name, CU_Mobile,CU_age)
VALUES 
  (123456, 'Faisal', '98765432',25),
  (789012, 'Khalid', '97654321',19),
  (345678, 'Ali', '96543210',30);


INSERT INTO CAR (CA_id, CA_make, CA_name, CA_year,CA_color, CA_price)
VALUES 
  (111, 'Toyota', 'Camry', 2021,'blue' ,14),
  (212, 'Honda', 'Civic', 2022,'black' ,10),
  (313, 'Ford', 'Mustang', 2020,'white' ,20),
  (113, 'Toyota', 'Camry', 2021,'blue' ,14);


INSERT INTO RENT (RE_id, RE_name, RE_DateTaken, RE_DateReturn, RE_idCar, RE_idCu,RE_idManager)
VALUES 
  (1, 'Rent 1', '2023-06-10', '2023-06-15', 111, 123456,'M001'),
  (2, 'Rent 2', '2023-06-12', '2023-06-18', 212, 789012,'M002'),
  (3, 'Rent 3', '2023-06-15', '2023-06-20', 313, 345678,'M003');

INSERT INTO MANAGER (M_id, M_name, M_Idcar)
VALUES 
  ('M001', 'Said', 111),
  ('M002', 'Ahmed', 212),
  ('M003', 'Sultan', 313),
  ('M004', 'Said', 113);


/*Adding and insert and updating columns*/
ALTER TABLE RENT add RE_NumDays NUMERIC(6) CHECK (RE_NumDays > 0); 

UPDATE RENT SET RE_NumDays= DATEDIFF(day, RE_DateTaken,RE_DateReturn);


select * from RENT

/*add PRIMARY KEY and foriegn key */
ALTER TABLE CUSTOMER
ADD CONSTRAINT CU_PK_CUSTOMER PRIMARY KEY (CU_id);

ALTER TABLE CAR
ADD CONSTRAINT CA_PK_CAR PRIMARY KEY (CA_id);

ALTER TABLE RENT
ADD CONSTRAINT PK_RENT PRIMARY KEY (RE_id);

ALTER TABLE RENT
ADD CONSTRAINT FK_RENT_CA_id
FOREIGN KEY (RE_idCar) REFERENCES CAR(CA_id);

ALTER TABLE RENT
ADD CONSTRAINT FK_RENT_CU_id
FOREIGN KEY (RE_idCu) REFERENCES CUSTOMER(CU_id);

ALTER TABLE MANAGER
ADD CONSTRAINT PK_MANAGER PRIMARY KEY (M_id);

ALTER TABLE MANAGER
ADD CONSTRAINT FK_MANAGER_CA_id
FOREIGN KEY (M_Idcar) REFERENCES CAR(CA_id);

/*ALTER TABLE RENT add RE_idManager VARCHAR(10);*/


ALTER TABLE RENT
ADD CONSTRAINT FK_RENT_M_id
FOREIGN KEY (RE_idManager) REFERENCES MANAGER(M_id);

/*Dropping Columns */
ALTER TABLE CAR
DROP COLUMN CA_color;


/*Retrieve all managers whose names start with 'S':*/
SELECT *FROM MANAGER WHERE M_name LIKE 'S%';

/*Using any table which contains a numeric field, retrieve the record which  has the maximum value for that field.  */

Select * from CAR where CA_Price = (Select Max(CA_Price)from CAR);

/*List related information from two tables. The list must contain at least  one field from each table. */
SELECT C.CU_name, R.RE_name
FROM CUSTOMER C
JOIN RENT R ON C.CU_id = R.RE_idCu;
/*Produce a statistical list (Query) of two columns only, which aggregates  the records within a table based on the values stored in one textual-field  
(the 1st column) while the 2nd column lists aggregated information using  
one of these functions: ‘COUNT’, ‘SUM’, or ‘AVERAGE’*/

SELECT CA_name ,CA_price, COUNT(CA_price) AS "Counting price" FROM CAR GROUP BY CA_name,CA_price;

/*Payment*/
CREATE VIEW BELL_view1 AS 
SELECT CA_id,Re_id,RE_idCu,CA_name,M_name,(CA_price * RE_NumDays) AS "Total price"
FROM CAR c,MANAGER m,RENT 
WHERE c.CA_id = RENT.RE_idCar and m.M_id = RENT.RE_idManager;


/*CREATE VIEW BELL_view AS 
SELECT CA_id,Re_id,RE_idCu,CA_name,(CA_price * RE_NumDays) AS "Total price"
FROM CAR 
JOIN RENT ON CAR.CA_id = RENT.RE_idCar;


group by CA_id,Re_id,RE_idCu,CA_name,RE_idManager;*/


select * from RENT

select * from BELL_view1
update MANAGER SET M_id='M001' where M_id='M004';
