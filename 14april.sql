#1.write a SQL query to identify the physicians who are the department heads.
# Return Department name as “Department” and Physician name as “Physician”.
select 
	d.name as "Department",
	p.name as "Physician"
from department d
inner join physician p
on d.head=p.employeeid;

# Using where
select 
	d.name AS "Department",
	p.name AS "Physician"
from department d, physician p
where d.head=p.employeeid;

#2. write a SQL query to locate the floor and block where room number 212 is located. 
#Return block floor as "Floor" and block code as "Block".
select blockfloor as "Floor",
       blockcode as "Block"
from room
where roomnumber=212;

#3. write a SQL query to count the number of unavailable rooms.
# Return count as "Number of unavailable rooms".
select count(*) AS "Number of unavailable rooms"
from room
where unavailable='t';


#4. write a SQL query to identify the physician and the department with which he or she is affiliated. 
#Return Physician name as "Physician", and department name as "Department". 

SELECT p.name AS "Physician",
       d.name AS "Department"
FROM physician p,
     department d,
     affiliated_with a
WHERE p.employeeid=a.physician
  AND a.department=d.departmentid;
  
  
  #5. write a SQL query to find those physicians who have received special training.
# Return Physician name as “Physician”, treatment procedure name as "Treatment".
select p.name as "Physician",
c.name AS "Treatment"
FROM physician p,
     procedures c,
trained_in t
where t.physician=p.employeeid
  and t.treatment=c.code;
 
 #6. write a SQL query to find those physicians who are yet to be affiliated.
# Return Physician name as "Physician", Position, and department as "Department". 
select p.name as "Physician",
       p.position,
       d.name as "Department"
from physician p
inner join affiliated_with a on a.physician=p.employeeid
inner join department d on a.department=d.departmentid
where primaryaffiliation='f';

#7. write a SQL query to identify physicians who are not specialists. 
#Return Physician name as "Physician", position as "Designation"
select p.name AS "Physician",
       p.position "Designation"
from physician p
left join trained_in t 
ON p.employeeid=t.physician
where t.treatment is null;

#8. write a SQL query to identify the patients and the number of physicians with whom they have scheduled appointments. 
#Return Patient name as "Patient", number of Physicians as "Appointment for No. of Physicians".
SELECT p.name  "Patient",
       count(t.patient) "Appointment for No. of Physicians"
FROM appointment t
JOIN patient p ON t.patient=p.ssn
GROUP BY p.name HAVING count(t.patient)>=1;



#9. write a SQL query to count the number of unique patients who have been scheduled for examination room 'C'.
# Return unique patients as "No. of patients got appointment for room C". 
SELECT count(DISTINCT patient) AS "No. of patients got appointment for room C"
FROM appointment
WHERE examinationroom='C';

#10. write a SQL query to identify the nurses and the room in which they will assist the physicians. 
#Return Nurse Name as "Name of the Nurse" and examination room as "Room No.".
select n.name as "name of  the nurce",
		a.examinationroom as "room no"
	from nurse n
     join appointment a on a.prepnurse=n.employeeid;
     
#11. write a SQL query to locate the patients' treating physicians and medications. 
#Return Patient name as "Patient", Physician name as "Physician", Medication name as "Medication". 

SELECT t.name AS "Patient",
       p.name AS "Physician",
       m.name AS "Medication"
FROM patient t
JOIN prescribes s ON s.patient=t.ssn
JOIN physician p ON s.physician=p.employeeid
JOIN medication m ON s.medication=m.code;


#12. write a SQL query to count the number of available rooms in each block. Sort the result-set on ID of the block. 
#Return ID of the block as "Block", count number of available rooms as "Number of available rooms".

select blockcode as "block",
		count(*) as  "Number of available rooms"
	from room
    where unavailable="f"
    group by blockcode
    order by blockcode;
    
#13. write a SQL query to count the number of available rooms for each floor in each block. Sort the result-set on floor ID, ID of the block. 
#Return the floor ID as "Floor", ID of the block as "Block", and number of available rooms as "Number of available rooms".
select blockcode as "block",
		blockfloor as "floor",
		count(*) as  "Number of available rooms"
	from room
    where unavailable="f"
    group by blockcode,blockfloor
    order by blockcode,blockfloor;
    
#14.  write a SQL query to count the number of rooms that are unavailable in each block and on each floor. Sort the result-set on block floor, block code. 
# Return the floor ID as "Floor", block ID as "Block", and number of unavailable as “Number of unavailable rooms"
select blockfloor as "floor",
	blockcode as "block",
    count(*) as "Number of unavailable rooms"
from room
    where unavailable="t"
    group by blockcode,blockfloor
    order by blockcode,blockfloor;
    
#15.  write a SQL query to find the name of the patients, their block, floor, and room number where they admitted. room number where they 

select p.name as "patient",
		s.room as "room",
        r.blockcode as "block",
        r.blockfloor as "floor"
	from stay s
    join patient p on s.patient=p.ssn
    join room r on s.room=r.roomnumber;
    
#16. write a SQL query to find all physicians who have performed a medical procedure but are not certified to do so.
# Return Physician name as "Physician".

select name as "physician"
from physician
where employeeid in (
	select undergoes.physician
    from undergoes
    left join trained_in on undergoes.physician=trained_in.physician
    and undergoes.procedure=trained_in.treatment
    where treatment is null );
    
select name as "physician"
from physician
where employeeid in (3);


#17.  write a SQL query to determine which patients have been prescribed medication by their primary care physician.
# Return Patient name as "Patient", and Physician Name as "Physician".

select pt.name as "patient",
	p.name as "physician"
from patient pt
join prescribes pr on pr.patient=pt.ssn
join physician p on pt.pcp=p.employeeid
where pt.pcp=pr.physician
and pt.pcp=p.employeeid;

#18. write a SQL query to find those patients who have undergone a procedure costing more than $5,000, as well as the name of the physician
# who has provided primary care, should be identified. 
#Return name of the patient as "Patient", name of the physician as "Primary Physician", and cost for the procedure as "Procedure Cost".
select pt.name AS " Patient ",
p.name as "Primary Physician",
pd.cost as " Procedure Cost"
from patient pt
join undergoes u on u.patient=pt.ssn
join physician p on pt.pcp=p.employeeid
join procedures pd on u.procedure=pd.code
where pd.cost>5000;


#19. write a SQL query to identify those patients whose primary care is provided by a physician who is not the head of any department. 
# Return Patient name as "Patient", Physician Name as "Primary care Physician".
select pt.name as "Patient",
       p.name as "Primary care Physician"
from patient pt
join physician p on pt.pcp=p.employeeid
where pt.pcp not in(
    select head
     from department
     );
