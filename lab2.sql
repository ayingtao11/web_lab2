.mode csv
.headers on
drop table if exists Data;
drop table if exists Cars;
drop table if exists Judges;
drop table if exists Car_Score;
drop table if exists Rank;
drop table if exists Merg;
drop table if exists merg2;
create table Data(Timestamp,Email,Name,Year,Make,Model,Car_ID,Judge_ID,Judge_Name,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall);
.import /usershome/Xinjin.Weng07/web_lab2/data_lab2/data.csv Data 

create table Cars (Car_ID PRIMARY key,Year,Make,Model,Email,Name);
insert into Cars(Car_ID,Year,Make,Model,Email,Name) SELECT Car_ID,Year,Make,Model,Email,Name from Data;
create table Judges as select Judge_ID,Judge_Name from Data;
create table Car_Score (Car_ID primary key,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall);
insert into Car_Score(Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall) select Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall from Data;
create table Rank (Ranking integer primary key autoincrement,Total,Car_ID,Year,Make,Model);
insert into Rank(Total,Car_ID,Year,Make,Model)select(Racer_Turbo+Racer_Supercharged+Racer_Performance+Racer_Horsepower+Car_Overall+Engine_Modifications+Engine_Performance+Engine_Chrome+Engine_Detailing+Engine_Cleanliness+Body_Frame_Undercarriage+Body_Frame_Suspension+Body_Frame_Chrome+Body_Frame_Detailing+Body_Frame_Cleanliness+Mods_Paint+Mods_Body+Mods_Wrap+Mods_Rims+Mods_Interior+Mods_Other+Mods_ICE+Mods_Aftermarket+Mods_WIP+Mods_Overall)
 as [total],
Car_ID,Year,Make,Model 
from Cars left join Car_Score using (Car_ID) order by total desc;
.output extract1.csv
select * from Rank;
.output stdout
.output extract2.csv
select Ranking,Make,Car_ID,Total from Rank where (select count(*) from Rank as r where r.Make=Rank.Make and r.Total >= Rank.Total)<= 3 order by Make,Total desc;
.output stdout
alter table Judges add Ct;

create table Merg as select Judge_ID,count(Judge_ID)as C from Judges group by Judge_ID;
select Judge_ID,Merg.C from Judges cross join Merg using(Judge_ID);
create table Merg2 as select Judge_ID,Merg.C from Judges cross join Merg using(Judge_ID);
insert into Judges (Ct) select C from Merg2;
select max(Timestamp),min(Timestamp),cast(julianday(replace(Max(Timestamp),'/','-'))-julianday(replace(Min(Timestamp),'/','-'))as integer)*24*60 from Data where Timestamp!='Timestamp';
