show databases;

#创建数据库
create database Testdb;

#指定编码格式
create database mydb character set utf8mb4;

use mydb;
show tables;

#删除数据库
drop database Testdb;

use world;
show tables;

select * from city;
select * from city limit 100;

use mydb;
#建表
create table stuInfo(
	stuid int unsigned primary key,
    stuname varchar(10) not null,
    gender varchar(5),
    birthdate date,
    age int(3),
    city varchar(20)
);
show tables;
#查看表结构
describe stuinfo;
#修改表-增加字段
alter table stuinfo add major varchar(20);
select * from stuinfo;
#删除字段
alter table stuinfo drop major;
#在某个字段后增加字段
alter table stuinfo add major varchar(20) after age;
alter table stuinfo drop major;
#重命名表
create table stuInfoTest(
	stuid int unsigned primary key,
    stuname varchar(10) not null,
    gender varchar(5),
    birthdate date,
    age int(3),
    city varchar(20)
);
show tables;
alter table stuinfotest rename stuinfotest1;
#删除表
drop table stuinfotest1;

select * from stuinfo;
#插入一条记录
insert into stuinfo(stuid,stuname,gender,birthdate,age,city) 
values(20161001,'Sunbin','男','1990/1/1',28,'Beijing');
#插入多条记录
insert into stuinfo(stuid,stuname,gender,birthdate,age,city) 
values(20161002,'Wangwu','女','1991/1/3',19,'Beijing'),
(20161003,'Lisi','男','1990/11/4',21,'Shanghai');
select * from stuinfo;
#删除记录
delete from stuinfo where stuid=20161002;
#更新记录
update stuinfo set stuname='Jack' where stuid=20161001;
select * from stuinfo;
select * from stuinfo where stuid=20161001;

#############
#常用查询命令
use world;
select * from country;
#排序
select * from country order by population;
select * from country order by population desc;
#对字符串进行排序
select * from country order by name;
#分组
select Region,count(*) from country group by Region;
select continent,count(*) from country group by continent;

#空值
select count(*) from country where indepyear is not null;
select count(*) from country where indepyear is null;
#去重
select count(continent) from country;
select count(distinct continent) from country;

#常用的汇总函数
select count(*) from country;
select count(name) from country;

select max(population) from country;
select min(population) from country where population>0;
#查找人口最多的国家
select name,population from country where population=(select max(population) from country);
select name,population from country order by population desc limit 1;
#查找人口最少的国家
select name,population from country where population=(select min(population) from country where population>0);
select name,population from country where population>0 order by population limit 1;
#max,min也可以用于日期查询
#求和,sum
select sum(population) from country;
#求均值,avg
select avg(lifeexpectancy) from country;
#也可以这样来求均值
select count(lifeexpectancy) from country;
select sum(lifeexpectancy) from country;
select sum(lifeexpectancy)/count(lifeexpectancy) as lifeexp_avg from country;

###########
#表的连接
select * from country;
select * from countrylanguage;

select country.name,countrylanguage.language,country.population
from country,countrylanguage
where country.code=countrylanguage.countrycode;
#内连接-inner join
select country.name,countrylanguage.language,country.population
from country inner join countrylanguage
on country.code=countrylanguage.countrycode;

#左连接-left join...on
select country.name,countrylanguage.language,country.population
from country left join countrylanguage
on country.code=countrylanguage.countrycode;
#查询哪些记录的language为空
select * from(
	select country.name,countrylanguage.language,country.population
	from country left join countrylanguage
	on country.code=countrylanguage.countrycode
) as temp_tb
where language is null;
#右连接-right join...on
#查询每个城市对应的国家、该城市的人口数
select * from city;
select city.name as city_name,country.name as country_name,city.population
from city right join country
on country.code=city.countrycode;

#其他
select * from city where countrycode='CHN';
select count(*) from city where countrycode='CHN';
#查找省份以Guang开头的记录
select * from city where countrycode='CHN' and district like 'Guang%';
#查找省份以nan结尾的记录
select * from city where countrycode='CHN' and district like '%nan';
#查找湖南、广东、河南
select * from city where district in('Hunan','Guangdong','Henan');
#having
select * from city where countrycode='CHN';
select district,sum(population) from city where countrycode='CHN' group by district
having sum(population)>10000000;
#查找人口介于500万到1000万之间的省份,between...and...
select district,sum(population) from city where countrycode='CHN' group by district
having sum(population) between 5e6 and 10e6;
#union,合并多个select语句的结果集
select code from country;
select distinct countrycode from city;
select code from country union select distinct countrycode from city;
select code from country union all select distinct countrycode from city;

#date_format
use sakila;
select * from payment;
select payment_id,date_format(payment_date,'%Y') as date_year from payment;
select payment_id,date_format(payment_date,'%Y-%M') as pm_date from payment;

#case表达式
use world;
select * from city where countrycode='CHN';
#case表达式的第一种用法
select distinct district,
	case district
		when 'Peking' then '直辖市'
        when 'Tianjin' then '直辖市'
        when 'Shanghai' then '直辖市'
        when 'Chongqing' then '直辖市'
        else '省份' end as province_level
from city where countrycode='CHN';

#case表达式的第二种用法
select * from city where countrycode='CHN';

select name,population,
	case 
		when population>5e6 then '一线城市'
		when population>=2e6 and population<5e6 then '二线城市'
        else '三线城市' end as city_tier
from city where countrycode='CHN';

select
	case district
		when 'Peking' then '直辖市'
        when 'Tianjin' then '直辖市'
        when 'Shanghai' then '直辖市'
        when 'Chongqing' then '直辖市'
        else '省份' end as province_level,count(distinct district)
from city where countrycode='CHN'
group by
	case district
		when 'Peking' then '直辖市'
        when 'Tianjin' then '直辖市'
        when 'Shanghai' then '直辖市'
        when 'Chongqing' then '直辖市'
        else '省份' end;

select
	case 
		when population>5e6 then '一线城市'
		when population>=2e6 and population<5e6 then '二线城市'
        else '三线城市' end as city_tier,count(name)
from city where countrycode='CHN'
group by
	case 
		when population>5e6 then '一线城市'
		when population>=2e6 and population<5e6 then '二线城市'
        else '三线城市' end;
################
#数据导出与导入
use world;
select * from city where countrycode='CHN';
#方法1：工具

#方法2：通过sql命令导出
select * from city where countrycode='CHN'
into outfile 'E:/data/db_mysql/export/city.csv'
fields terminated by ',' lines terminated by '\r\n';

show variables like '%secure%';

#数据导入
use mydb;

select * from stuinfo;
truncate stuinfo;
#导入数据的第一种方式：工具

#导入数据的第二种方式：sql命令
load data infile 'E:/data/db_mysql/stuinfo.txt' 
into table stuinfo
fields terminated by '\t' lines terminated by '\r\n';

