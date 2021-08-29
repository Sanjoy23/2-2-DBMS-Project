create table Airport( 
              ID            varchar(20) not null, 
                 Country_code numeric(5,0), 
              City         varchar(15), 
              Name          varchar(50), 
              Runway_length  numeric(8,0),
              Runway_width  numeric(8,0),
              primary key(ID)  
); 
             
 
 
create table Flight (
         ID            varchar(20) not null, 
     No_of_Tickets        numeric(8,0), 
     Source            varchar(15), 
     Destination        varchar(15), 
     Primary key (ID), 
     foreign key (Source) references Airport(ID), 
      foreign key (Destination) references Airport(ID)
       
    );


create table Staff( 
                ID         varchar(20) not null, 
                  Name       varchar(30), 
                   Rank       varchar(20), 
                   Salary     numeric(12,3), 
                primary key  (ID) 
          ) ;
 
create table Phone( 
                   S_id         varchar(20) not null, 
                   phone01      numeric(11,0), 
                   phone02      numeric(11,0), 
                   foreign key  (S_id) references Staff(ID) 
) ;
 
create table Email( 
                   S_id         varchar(20) not null , 
                   Email01      varchar(20), 
                   Email02      varchar(20), 
                   foreign key  (S_id) references Staff(ID) 
); 
 
 
create table Airplane( 
             ID         varchar(20) not null, 
             Name       varchar(30), 
             Type       varchar(15), 
             Capacity   numeric(5,0),   
             primary key(ID)  
) ;
 
 
create table Passengers( 
             ID             varchar(20) not null, 
             Name           varchar(30), 
             Phone          numeric(11,0), 
             Email          varchar(30), 
             Address        varchar(11), 
                Passport_no     numeric(12,0), 
             NID             numeric(12,0),  
                primary key (ID) 
) ;
 
   
create table Schedule( 
                F_id               varchar(20) not null, 
             Airplane_id        varchar(255) not null, 
             S_Date          varchar(20), 
             Start_time         varchar(20), 
             End_time           varchar(20), 
             foreign key    (F_id) references Flight (ID), 
                foreign key     (Airplane_id) references Airplane(ID) 
) ;
 
 
create table Pilot( 
                  S_id                   varchar(20) not null, 
                  F_id                   varchar(20) not null, 
                  foreign key  (F_id) references Flight (ID), 
                  foreign key  (S_id) references Staff(ID) 
);

create table Air_host( 
                  S_id                   varchar(20) not null, 
                  F_id                   varchar(20) not null, 
                  foreign key  (F_id) references Flight (ID), 
                  foreign key  (S_id) references Staff(ID) 
);


create table Books( 
                   P_id                  varchar(20) not null, 
                   F_id                  varchar(20) not null, 
                   F_date                varchar(20), 
                   class                 varchar(20), 
                   Seat_no               varchar(20), 
                   Fare                  numeric(8,2), 
                   foreign key  (P_id) references Passengers(ID), 
                   foreign key  (F_id) references Flight(ID) 
);



Functions
1.A function that's return maximum salary of staff?

create or replace function max_salary
       return number is
       x number;
begin
     select max(salary) into x
     from staff;
     return x;
end max_salary;


begin
  dbms_output.put_line(max_salary);
end;




2. A function that's take staff name and return the phone numbers of that staff?


create or replace type array as object (num1 number,num2 number);
create or replace type my_array as table of array;

create or replace function phone_arry(x in varchar)
     return my_array is
     nm my_array;
begin
     select array(phone01,phone02) bulk collect into nm
     from phone join staff on phone.s_id = staff.id and x=staff.name;
     return nm;
end phone_arry;




3.average salary of staffs

create or replace function avg_salary
    return number is 
    average number;
begin
    average:=0;
    select avg(salary) into average
    from staff;
    return average;
end avg_salary;

begin
  dbms_output.put_line(avg_salary);
end;


 





 Procedure

1. a procedure take a flight id as a parameter and print the schedule time of the flight


create or replace type array2 as object (tim1 varchar(20),tim2 varchar(20));
create or replace type my_array2 as table of array2;

create or replace procedure schedule_time(x in varchar)
      is 
         res my_array2;
         n number;
begin
     select array2(start_time,end_time) bulk collect into res 
     from flight f join schedule s on f.id=s.f_id and x=f.id;
     n:=res.count;
     for i in 1..n loop
     dbms_output.put_line(res(i).tim1||' '||res(i).tim2);
     end loop;
end;


begin
      schedule_time('F001');
end;




2. a procedure that's shows the flight no, pilot name and airplane name'.


create or replace type array3 as object (id varchar(20),nam1 varchar(20),nam2 varchar(20));
create or replace type my_array3 as table of array3;


create or replace procedure pilot_flight
         is 
         res my_array3;
         n number;

begin
    select array3(f.id,s.name,a.name) bulk collect into res
    from (((flight f join pilot p on f.id=p.F_id)  join staff s on s_id = s.id) join schedule on f.id = schedule.f_id) join airplane a on a.id = schedule.airplane_id;
      n:=res.count;
     for i in 1..n loop
     dbms_output.put_line(res(i).id||' '||res(i).nam1||'     '||res(i).nam2);
     end loop;
end;   

begin
   pilot_flight;
end;





trigger

1.
create or replace trigger budget_055 after update on department
for each row
declare 
     x number;
     y number;
begin
    if(:new.budget>:old.budget) then x:= :new.budget-:old.budget;
    y:=1;
    elsif(:new.budget<:old.budget) then x:= :old.budget-:new.budget;
    y:=2;
    end if;
    if(y=1) then dbms_output.put_line('Budget increased:'||x||'tk');
    elsif(y=2) then dbms_output.put_line('Budget decreased:'||x||'tk');   
    else dbms_output.put_line('Budget unchanged');
end if;
end;


2.
create or replace trigger airplane_55 after insert on airplane
for each row
declare 
     n number;
     y number;
begin
    select count(ID) into n
    from airplane;
    dbms_output.put_line(n);
    dbms_output.put_line(:new.name);
end;

3.

create or replace trigger aft_name_55
after insert on passengers
for each row
declare
    n number;
begin
    select count(ID) into n
    from passengers;
    dbms_output.put_line(n);
    dbms_output.put_line(:new.name);
end aft_name_55;


