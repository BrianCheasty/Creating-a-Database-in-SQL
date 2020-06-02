/*Creating a patient table to hold all patients personal information.*/
Create table if not exists Patient (
Patient_ID int auto_increment,
Patient_Name varchar(50),
Patient_Address varchar(150),
Tel_No varchar(10),
Date_of_Birth date,
Patient_Set_Up_Date date,
Gender varchar(6),
Marketing_Preference varchar(3),
primary key (Patient_ID));

/*Creating a treatments table to hold all information on treatments available*/
Create table if not exists Treatments (
Treatment_ID int auto_increment,
Treatment_Name varchar(255),
Treatment_Description varchar(255),
Price decimal(10,2),
Primary key (Treatment_ID));
/*To ensure that the each primary key starts from a different point I will specify the starting point.
Greater distance between starting points would be required in a commercial environment.*/
Alter table Treatments auto_increment = 100;

/*To ensure that the secretary can search all available appointments I am setting up a doctor schedule.*/
Create table if not exists Doctor_Schedule (
Schedule_ID int auto_increment,
Appointments datetime,
primary key (Schedule_ID));
/*To ensure that the each primary key starts from a different point I will specify the starting point.
Greater distance between starting points would be required in a commercial environment.*/
Alter table Doctor_Schedule auto_increment = 500;

/*The appointment is the central table and activities are focused around appointments*/
Create table if not exists Appointment (
Appointment_ID int Auto_increment,
Patient_ID int,
Appointment_Status varchar(12),
Schedule_ID int,
Foreign Key (Patient_ID) references Patient(Patient_ID),
Foreign Key (Schedule_ID) references Doctor_Schedule(Schedule_ID),
Primary key (Appointment_ID));
/*To ensure that the each primary key starts from a different point I will specify the starting point.
Greater distance between starting points would be required in a commercial environment.*/
Alter table Appointment auto_increment = 1000;

/*The bill table is updated after the treatment is provided*/
Create table if not exists  Bill (
Bill_ID int auto_increment,
Treatment_Cost decimal(10,2),
Bill_Date date,
Appointment_ID int,
foreign key (appointment_id) references appointment(appointment_id),
Primary key (Bill_ID));
/*To ensure that the each primary key starts from a different point I will specify the starting point.
Greater distance between starting points would be required in a commercial environment.*/
Alter table Bill auto_increment = 1500;

/*An appointment can have many treatments and a treatment can be on many appointments so
Treatment Booked is a junction table*/
Create table if not exists Treatment_Booked (
Treatment_ID int,
Appointment_ID int,
Foreign key (Treatment_ID) references Treatments(Treatment_ID),
Foreign Key (Appointment_ID) references Appointment(Appointment_ID));

/*In the course of an appointment the treatment may change, treatment booked will have different data to treatment provided in that case,
an appointment can result in many treatments provided and many treatments will be provided to appointments therefore 
Treatment Provided is a junction table*/
Create table if not exists Treatment_Provided (
Appointment_ID int,
Treatment_ID int,
Treatment_Status varchar(10),
Treatment_Notes varchar(255),
Treatment_Date date,
Treatment_Price decimal(10,2),
Foreign key (Appointment_ID) references Appointment(Appointment_ID),
Foreign key (Treatment_ID) references Treatments(Treatment_ID));

/*This table record the many payments that can take place for any given bill*/
Create table if not exists Payments (
Bill_ID int,
Payment_Amount decimal(10,2),
Payment_Date date,
Payment_ID int Auto_increment,
Payment_Type varchar(12),
Foreign key (Bill_ID) references Bill(Bill_ID),
Primary key (Payment_ID));
/*To ensure that the each primary key starts from a different point I will specify the starting point.
Greater distance between starting points would be required in a commercial environment.*/
Alter table Payments auto_increment = 2000;

/*The secretary can view all treatments marked are specialist to process the referral
Notes are included for the specialist, these are updated when the specialist returns the referral*/
Create view Specialist_referral as
select 
appointment.patient_id as 'Account_ID',
patient.Patient_name as 'Patient_Name',
treatment_provided.Treatment_Notes as 'Notes',
treatment_provided.Treatment_Status as 'Consultation_Status',
Treatment_provided.Treatment_Date as 'Referral_Date'
from appointment,treatment_provided,patient
where 
treatment_provided.appointment_id=appointment.Appointment_ID
and patient.patient_id = appointment.patient_id
and treatment_provided.treatment_status = "Specialist";

/*The outstanding view groups the bill and payments to calculate how much is owed for each appointment*/
Create View Outstanding as select 
bill.appointment_id,bill.bill_id,
curdate()-ifnull(bill_date,curdate()) as 'Days_Outstanding',
ifnull(Bill.Treatment_cost,0) - sum(ifnull(payments.Payment_amount,0)) as 'Amount_Outstanding'
from Bill
LEFT JOIN Payments ON Bill.Bill_id = Payments.Bill_id 
WHERE Bill.Bill_id = Payments.Bill_id
GROUP BY Bill.appointment_id;

/*The patient chart provides a summary for the secretary and doctor for each patient*/
Create view Patient_Chart as
select 
Patient.patient_id as 'Account_ID',
patient.Patient_name as 'Patient_Name',
appointment.appointment_status as 'Appointment_Status',
doctor_schedule.appointments as 'Appointment_Time',
treatments.Treatment_Name as 'Treatments_Booked',
Treatment_provided.treatment_id as 'Treatment_Completed',
treatment_provided.Treatment_Notes as 'Notes',
treatment_provided.Treatment_Status as 'Consultation_Status',
treatment_provided.Treatment_Price as 'Cost_of_Treatment',
Outstanding.Days_Outstanding as 'Time_Since_Lst_Pmt',
Outstanding.Amount_Outstanding as 'Remaining_to_Pay'
from appointment,doctor_schedule,treatment_booked,treatments,treatment_provided,patient,Outstanding,bill
where 
appointment.Schedule_ID=doctor_schedule.Schedule_ID 
and appointment.appointment_id=treatment_booked.appointment_id 
and treatment_booked.Treatment_ID=treatments.Treatment_ID 
and treatment_provided.appointment_id=appointment.Appointment_ID
and patient.patient_id = appointment.patient_id
and outstanding.appointment_id = bill.appointment_id
and bill.appointment_id=appointment.appointment_id;