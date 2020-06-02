/*Test Data required before any queries can be executed*/

/*All available appointment times added. first appointment is 00 to use as a place holder in the patient chart*/
insert into doctor_schedule values(null,'0000-00-00 00:00');
insert into doctor_schedule values(null,'2019-04-23 10:00');
insert into doctor_schedule values(null,'2019-04-23 11:00');
insert into doctor_schedule values(null,'2019-04-23 12:00');
insert into doctor_schedule values(null,'2019-04-23 14:00');
insert into doctor_schedule values(null,'2019-04-23 15:00');
insert into doctor_schedule values(null,'2019-04-23 16:00');
insert into doctor_schedule values(null,'2019-04-24 09:00');
insert into doctor_schedule values(null,'2019-04-24 10:00');
insert into doctor_schedule values(null,'2019-04-24 11:00');
insert into doctor_schedule values(null,'2019-04-24 12:00');
insert into doctor_schedule values(null,'2019-04-24 14:00');
insert into doctor_schedule values(null,'2019-04-24 15:00');
insert into doctor_schedule values(null,'2019-04-24 16:00');
insert into doctor_schedule values(null,'2019-04-25 09:00');
insert into doctor_schedule values(null,'2019-04-25 10:00');
insert into doctor_schedule values(null,'2019-04-25 11:00');
insert into doctor_schedule values(null,'2019-04-25 12:00');
insert into doctor_schedule values(null,'2019-04-25 14:00');
insert into doctor_schedule values(null,'2019-04-25 15:00');
insert into doctor_schedule values(null,'2019-04-25 16:00');
insert into doctor_schedule values(null,'2019-04-26 09:00');
insert into doctor_schedule values(null,'2019-04-26 10:00');
insert into doctor_schedule values(null,'2019-04-26 11:00');
insert into doctor_schedule values(null,'2019-04-26 12:00');
insert into doctor_schedule values(null,'2019-04-26 14:00');
insert into doctor_schedule values(null,'2019-04-26 15:00');
insert into doctor_schedule values(null,'2019-04-26 16:00');

/*All available treatments are added. A treatment of no booking yet is added as a placeholder for the patient chart*/
insert into treatments values (null,"Clean",'Polish of teeth',70);
insert into treatments values (null,"Bridges and Impants",'Bridges and implants are two ways to replace a missing tooth or teeth',500);
insert into treatments values (null,"Extraction",'A severely damaged tooth may need to be extracted',201);
insert into treatments values (null,"Bonding",'Bonding is a treatment that can be used to repair teeth that are decayed, chipped, fractured or discoloured or to reduce gaps between teeth',100);
insert into treatments values (null,"Braces",'Not Available',null);
insert into treatments values (null,"Crowns and Caps",'A crown or cap is a cover that fits over a tooth that has been damaged by decay, broken, badly stained or mis-shaped',300);
insert into treatments values (null,"Dentures",'Dentures are prosthetic devices replacing lost teeth',1200);
insert into treatments values (null,"Fillings and Repair",'Dental fillings and repairs use restorative materials used to repair teeth which have been compromised due to cavities or trauma',120);
insert into treatments values (null,"Gum Surgery",'Periodontal or gum disease is an infection that affects the gums and jaw bone, which can lead to a loss of gum and teeth',450);
insert into treatments values (null,"Root Canal",'Root canals treat diseases or absessed teeth',600);
insert into treatments values (null,"Teeth Whitening",'Teeth naturally darken with age, however staining may be caused by various foods and beverages such as coffee, tea and berries, some drugs such as tetracycline, smoking, or a trauma to a tooth',200);
insert into treatments values (null,"Late Cancellation",'Cancelled within 24 hours',10);
insert into treatments values (null,"No Booking Yet",'No Booking Yet',null);


/*An example of the patient life cycle
Each patient is set up with placeholders if they have not set an appointment to ensure the patient chart is updated,
If the patient makes an appointment this is entered with the schedule id & treatment name (the ability to cancel and reschedule is available),
If the appointment takes place then the treatment provided is updated and the bill is updated,
If a payment is made then this comes off the final bill as viewed from the outstanding view,
Any specialist referrals are viewed from the specialist view and
a general look at the patients chart is viewed on the patient chart view*/

/*#################################################Patient 1*#################################################################*/
insert into patient values (null,"Con Kirwan","5 Waterford","0851234568",'1979-07-05','1980-01-01',"Male","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "Con Kirwan"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Con Kirwan"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Con Kirwan")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Con Kirwan") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Con Kirwan") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,1,"Booking",504);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values
((select treatment_id from treatments where Treatment_name = "Gum Surgery"),
(select appointment_id from appointment where patient_id=2 and schedule_id = 504));

insert into treatment_provided values((select appointment_id from appointment where patient_id=1 and schedule_id = 504),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=1 and schedule_id = 504));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=2 and schedule_id = 504)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=1 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=1 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=1 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=1 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 1 /*Update*/
and schedule_id = 500;

/*Example of cancellation with fee*/
Update appointment 
set 
appointment_status = "Cancelled"
where appointment_id = 1000;

Update treatment_provided set 
Treatment_id= 111,
Treatment_Status="Cancelled",
Treatment_notes="Cancelled within 24 Hours",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1000;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1000),
Bill_Date=curdate()
Where bill.appointment_id = 1000;
/*#################################################Patient 2*#################################################################*/
insert into patient values (null,"Brian Cheasty","4 Waterford","0851234567",'1980-05-28','1990-01-01',"Male","Yes"); 
insert into appointment values (null,(select patient_id from patient where patient_name = "Brian Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Brian Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Brian Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Brian Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Brian Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 3*#################################################################*/
insert into patient values (null,"Sean Nolan","6 Waterford","0851234569",'1982-12-12','2000-01-01',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Sean Nolan"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Nolan"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Nolan")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Nolan") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Sean Nolan") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,3,"Booking",518);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Fillings and Repair"),(select appointment_id from appointment where patient_id=3 and schedule_id = 518));

insert into treatment_provided values((select appointment_id from appointment where patient_id=3 and schedule_id = 518),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=3 and schedule_id = 518));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=3 and schedule_id = 518)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=3 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=3 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=3 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=3 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 3 /*Update*/
and schedule_id = 500;

Update treatment_provided set 
Treatment_id= 109,
Treatment_Status="Complete",
Treatment_notes="No Issue",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1004;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_Cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1004),
Bill_Date=curdate()
Where bill.appointment_id = 1004;

insert into payments values (1504,600,curdate(),null,"Credit Card");
/*#################################################Patient 4*#################################################################*/
insert into patient values (null,"Sean Matthews","7 Waterford","0851234570",'1985-07-14','2005-01-01',"Male","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "Sean Matthews"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Matthews"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Matthews")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Sean Matthews") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Sean Matthews") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 5*#################################################################*/
insert into patient values (null,"Rhona Caffrey","8 Waterford","0851234571",'1985-07-15','2005-01-02',"Female","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Rhona Caffrey"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rhona Caffrey"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rhona Caffrey")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rhona Caffrey") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Rhona Caffrey") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 6*#################################################################*/
insert into patient values (null,"Kevin Cheasty","9 Waterford","0851234572",'1985-07-15','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Kevin Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Kevin Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Kevin Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Kevin Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Kevin Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 7*#################################################################*/
insert into patient values (null,"Ian Cheasty","10 Waterford","0851234573",'1985-07-16','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Ian Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Ian Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Ian Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Ian Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Ian Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,7,"Booking",507);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Dentures"),(select appointment_id from appointment where patient_id=7 and schedule_id = 507));

insert into treatment_provided values((select appointment_id from appointment where patient_id=7 and schedule_id = 507),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=7 and schedule_id = 507));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=7 and schedule_id = 507)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=7 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=7 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=7 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=7 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 7 /*Update*/
and schedule_id = 500;

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=7 and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=7 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=7 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=7 and schedule_id = 500);
Delete from appointment where patient_id = 7 and schedule_id = 500;

Update treatment_provided set 
Treatment_id= 102,
Treatment_Status="Complete",
Treatment_notes="No Issue",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1009;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_Cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1009),
Bill_Date=curdate()
Where bill.appointment_id = 1009;

insert into payments values (1509,150,curdate(),null,"Cash");
/*#################################################Patient 8*#################################################################*/
insert into patient values (null,"Rian Cheasty","11 Waterford","0851234574",'1985-07-17','2005-01-02',"Male","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "Rian Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rian Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rian Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Rian Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Rian Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,8,"Booking",502);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Clean"),(select appointment_id from appointment where patient_id=8 and schedule_id = 502));

insert into treatment_provided values((select appointment_id from appointment where patient_id=8 and schedule_id = 502),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=8 and schedule_id = 502));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=8 and schedule_id = 502)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=8 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=8 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=8 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=8 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 8 /*Update*/
and schedule_id = 500;

/*Reschedule Example*/
Update appointment set schedule_id = 513 where schedule_id = 502;
/*#################################################Patient 9*#################################################################*/
insert into patient values (null,"Tessa Cheasty","12 Waterford","0851234575",'1985-07-18','2005-01-02',"Female","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Tessa Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Tessa Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Tessa Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Tessa Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Tessa Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,9,"Booking",510);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Extraction"),(select appointment_id from appointment where patient_id=9 and schedule_id = 510));

insert into treatment_provided values((select appointment_id from appointment where patient_id=9 and schedule_id = 510),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=9 and schedule_id = 510));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=9 and schedule_id = 510)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=9 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=9 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=9 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=9 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 9 /*Update*/
and schedule_id = 500;

Update treatment_provided set 
Treatment_id= 107,
Treatment_Status="Complete",
Treatment_notes="No Issue",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1013;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_Cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1013),
Bill_Date=curdate()
Where bill.appointment_id = 1013;
/*#################################################Patient 10*#################################################################*/
insert into patient values (null,"Pat Matthews","13 Waterford","0851234576",'1985-07-19','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Pat Matthews"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Pat Matthews"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Pat Matthews")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Pat Matthews") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Pat Matthews") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 11*#################################################################*/
insert into patient values (null,"Seamus Nolan","14 Waterford","0851234577",'1985-07-11','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Seamus Nolan"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Seamus Nolan"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Seamus Nolan")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name ="Seamus Nolan") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Seamus Nolan") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,11,"Booking",511);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Fillings and Repair"),
(select appointment_id from appointment where patient_id=11 and schedule_id = 511));

insert into treatment_provided values((select appointment_id from appointment where patient_id=11 and schedule_id = 511),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=11 and schedule_id = 511));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=11 and schedule_id = 511)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=11 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=11 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=11 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=11/*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 11 /*Update*/
and schedule_id = 500;

Update treatment_provided set 
Treatment_id= 100,
Treatment_Status="Complete",
Treatment_notes="No Issue",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1016;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_Cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1016),
Bill_Date=curdate()
Where bill.appointment_id = 1016;
/*#################################################Patient 12*#################################################################*/
insert into patient values (null,"Conor Nolan","15 Waterford","0851234578",'1985-07-12','2005-01-02',"Male","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "Conor Nolan"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Conor Nolan"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Conor Nolan")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Conor Nolan") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Conor Nolan") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,12,"Booking",516);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "clean"),(select appointment_id from appointment where patient_id=12 and schedule_id = 516));

insert into treatment_provided values((select appointment_id from appointment where patient_id=12 and schedule_id = 516),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=12 and schedule_id = 516));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=12 and schedule_id = 516)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=12 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=12 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=12 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=12 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 12 /*Update*/
and schedule_id = 500;

Update treatment_provided set 
Treatment_id= 104,
Treatment_Status="Specialist",
Treatment_notes="Requires Braces",
Treatment_Date= Curdate(),
Treatment_Price=null
/*Treatment ID, Status and notes to be updated, treatment date and price to remain as is. Must know appointment id at this stage*/
where treatment_provided.appointment_id = 1018;

update Treatment_Provided set Treatment_Price = 
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID) 
where Treatment_Price is null and exists
(select Price from Treatments where Treatments.Treatment_ID = Treatment_Provided.Treatment_ID);

Update bill set
Treatment_Cost=(select sum(treatment_provided.treatment_price) 
from appointment,treatment_provided 
where appointment.appointment_ID=Treatment_provided.appointment_id 
and appointment.appointment_id =1018),
Bill_Date=curdate()
Where bill.appointment_id = 1018;
/*#################################################Patient 13*#################################################################*/
insert into patient values (null,"Lorcan Cosgrave","16 Waterford","0851234579",'1985-07-13','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Lorcan Cosgrave"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Lorcan Cosgrave"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Lorcan Cosgrave")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Lorcan Cosgrave") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Lorcan Cosgrave") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,13,"Booking",514);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Root Canal"),(select appointment_id from appointment where patient_id=13 and schedule_id = 514));

insert into treatment_provided values((select appointment_id from appointment where patient_id=13 and schedule_id = 514),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=13 and schedule_id = 514));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=13 and schedule_id = 514)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=13 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=13 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=13 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=13 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 13 /*Update*/
and schedule_id = 500;
/*#################################################Patient 14*#################################################################*/
insert into patient values (null,"John Cosgrave","17 Waterford","0851234580",'1985-08-15','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "John Cosgrave"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "John Cosgrave"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "John Cosgrave")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "John Cosgrave") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "John Cosgrave") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 15*#################################################################*/
insert into patient values (null,"Wayne Power","18 Waterford","0851234581",'1985-09-15','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Wayne Power"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Wayne Power"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Wayne Power")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Wayne Power") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Wayne Power") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 16*#################################################################*/
insert into patient values (null,"James Cantwell","19 Waterford","0851234582",'1985-01-15','2005-01-02',"Male","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "James Cantwell"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "James Cantwell"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "James Cantwell")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "James Cantwell") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "James Cantwell") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,16,"Booking",520);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "Bonding"),(select appointment_id from appointment where patient_id=16 and schedule_id = 520));

insert into treatment_provided values((select appointment_id from appointment where patient_id=16 and schedule_id = 520),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=16 and schedule_id = 520));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=16 and schedule_id = 520)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=16 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=16 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=16 /*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=16 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 16 /*Update*/
and schedule_id = 500;
/*#################################################Patient 17*#################################################################*/
insert into patient values (null,"Hugh Kavanagh","20 Waterford","0851234583",'1985-02-15','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Hugh Kavanagh"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Hugh Kavanagh"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Hugh Kavanagh")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Hugh Kavanagh") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Hugh Kavanagh") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 18*#################################################################*/
insert into patient values (null,"Liam Cheasty","21 Waterford","0851234584",'1985-03-15','2005-01-02',"Male","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Liam Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Liam Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Liam Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Liam Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Liam Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);
/*#################################################Patient 19*#################################################################*/
insert into patient values (null,"Mary Cheasty","22 Waterford","0851234585",'1985-04-15','2005-01-02',"Female","Yes");
insert into appointment values (null,(select patient_id from patient where patient_name = "Mary Cheasty"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Mary Cheasty"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Mary Cheasty")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Mary Cheasty") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Mary Cheasty") 
and schedule_id = 500)),0,curdate(),null,null);

insert into appointment values (null,19,"Booking",525);
/*null for appointment id then you need to know patientID,
Booking Status,ScheduleID*/

/*Create a placeholder in other tables
add in the treatment id*/

insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "clean"),(select appointment_id from appointment where patient_id=19 and schedule_id = 525));

insert into treatment_provided values((select appointment_id from appointment where patient_id=19 and schedule_id = 525),null,null,null,null,null);

insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=19 and schedule_id = 525));

insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=19 and schedule_id = 525)),0,curdate(),null,null);

/*This statement removes any placeholders to ensure that a patient does not have a record of no booking and a booking*/
Delete from payments where bill_id = (select bill_id from bill 
where bill.appointment_id=(select appointment_id from appointment where patient_id=19 /*Update*/
and schedule_id = 500));
Delete from Bill where appointment_id = (select appointment_id from appointment where patient_id=19 /*Update*/
 and schedule_id = 500);
Delete from treatment_provided where appointment_id= (select appointment_id from appointment where patient_id=19/*Update*/
 and schedule_id = 500);
Delete from treatment_booked where appointment_id= (select appointment_id from appointment where patient_id=19 /*Update*/
and schedule_id = 500);
Delete from appointment where patient_id = 19 /*Update*/
and schedule_id = 500;
/*#################################################Patient 20*#################################################################*/
insert into patient values (null,"Una OSullivan","23 Waterford","0851234586",'1985-05-15','2005-01-02',"Female","No");
insert into appointment values (null,(select patient_id from patient where patient_name = "Una OSullivan"
),null,500);
insert into treatment_booked values((select treatment_id from treatments where Treatment_name = "No Booking Yet"),
(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Una OSullivan"
) and schedule_id = 500));
insert into treatment_provided values((select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Una OSullivan")
 and schedule_id = 500),null,null,null,null,null);
insert into Bill values (null,null,null,(select appointment_id from appointment where patient_id=(select patient_id from patient where patient_name = "Una OSullivan") 
and schedule_id = 500));
insert into payments values((select bill_id from bill where bill.appointment_id=(select appointment_id from appointment 
where patient_id=(select patient_id from patient where patient_name = "Una OSullivan") 
and schedule_id = 500)),0,curdate(),null,null);


