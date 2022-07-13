use mydb;

#创建订单表
create table orders(
	id int(10) unsigned not null primary key,
    oid varchar(20) not null default '-' comment '订单ID',
    orderdate date,
    senddate date,
    deliverytype varchar(20),
    customerid varchar(20),
    customername varchar(10),
    customertype varchar(10),
    city varchar(10),
    province varchar(20),
    country varchar(20),
    region varchar(10),
    productid varchar(50),
    category varchar(20),
    subcategory varchar(20),
    productname varchar(50),
    salesvolume decimal(8,3),
    salesnum int(5),
    discount decimal(3,2),
    profit decimal(8,3)
);

show tables;
#导入数据
load data infile 'E:/data/db_mysql/orders.txt' into table orders
fields terminated by '\t' lines terminated by '\r\n';

select * from orders limit 100;
select count(*) from orders;

#创建退货记录表并导入数据
create table refunds(
	oid varchar(20) not null primary key,
    isRefund char(1) not null
);

load data infile 'E:/data/db_mysql/refunds.txt' into table refunds
fields terminated by '\t' lines terminated by '\r\n';

select * from refunds limit 100;
select count(*) from refunds;

#创建地区经理表，并导入数据
create table region_managers(
	region varchar(10) not null,
    manager varchar(20) not null
);

load data infile 'E:/data/db_mysql/region_managers.txt' into table region_managers
fields terminated by '\t' lines terminated by '\r\n';
select * from region_managers;

#########################################
#1、按客户：客户ID、客户名称、城市、销售额、数量、利润
select customerid,customername,city,sum(salesvolume),sum(salesnum),sum(profit)
from orders group by customerid;

#数据导出
select customerid,customername,city,sum(salesvolume),sum(salesnum),sum(profit)
into outfile 'E:/data/db_mysql/export/1.csv'
fields terminated by ',' lines terminated by '\r\n'
from orders group by customerid;

#2、按产品：产品ID、类别、子类别、产品名称、销售额、数量、利润
select productid,category,subcategory,productname,sum(salesvolume),sum(salesnum),sum(profit)
from orders group by productid;

select productid,category,subcategory,productname,sum(salesvolume),sum(salesnum),sum(profit)
into outfile 'E:/data/db_mysql/export/2.csv'
fields terminated by ',' lines terminated by '\r\n'
from orders group by productid;

#3、按照地区经理：地区经理、地区、销售额、数量、利润
select manager,region_managers.region,sum(salesvolume),sum(salesnum),sum(profit)
from orders right join region_managers on orders.region=region_managers.region
group by manager;

#4、按城市：城市、销售额、数量、利润
select city,sum(salesvolume),sum(salesnum),sum(profit)
from orders group by city;

###################################
#用一条SQL语句，查询总销售（销售额）大于3000000的地区经理
select manager,sum(salesvolume)
from orders right join region_managers
on orders.region=region_managers.region
group by manager having sum(salesvolume)>3000000;

#用一条SQL语句，查询退货订单信息
select * from orders right join refunds on orders.oid=refunds.oid;

#用一条SQL语句，查询每个地区经理每年的平均销售金额、平均利润
#查询年份数
select manager,count(distinct date_format(orderdate,'%Y')) as year_num
from orders right join region_managers
on orders.region=region_managers.region
group by manager;

select manager,
	sum(salesvolume)/count(distinct date_format(orderdate,'%Y')) as sales_avg,
    sum(profit)/count(distinct date_format(orderdate,'%Y'))as profit_avg
from orders right join region_managers
on orders.region=region_managers.region
group by manager;

#用一条SQL语句，查询不同类别的产品的销售金额、利润
select category,sum(salesvolume),sum(profit) from orders group by category;

#用一条SQL语句，查询2017年销售额最高的10个订单
select * from orders where date_format(orderdate,'%Y')='2017'
order by salesvolume desc limit 10;

#用一条SQL语句，查询出每个月的销售额都大于1万元的城市
select city,date_format(orderdate,'%Y-%m') orderdate1,sum(salesvolume)
from orders group by city,orderdate1 having sum(salesvolume)>10000;

select city,date_format(orderdate,'%Y-%m') orderdate1,sum(salesvolume)
from orders group by city,orderdate1 order by city;

#首先，查询出每月销售额有小于等于1万的城市
select distinct city from orders 
group by city,date_format(orderdate,'%Y-%m') having sum(salesvolume)<=10000;

#然后，查询出所有的城市（去重后）
select distinct city from orders
group by city,date_format(orderdate,'%Y-%m');

#最后，从所有城市中排除有小于等于1万元的城市
select city from(
	select distinct city from orders
	group by city,date_format(orderdate,'%Y-%m')
) as all_city
where city not in(
	select distinct city from orders 
	group by city,date_format(orderdate,'%Y-%m') having sum(salesvolume)<=10000
);

#用一条SQL语句，查询2017年5月到10月的订单，按照月份升序排序，月份相同的按照销售金额降序排序
select oid,date_format(orderdate,'%Y-%m') as orderYM,salesvolume
from orders where date_format(orderdate,'%Y-%m') between '2017-05' and '2017-10'
order by orderYM,salesvolume desc;


