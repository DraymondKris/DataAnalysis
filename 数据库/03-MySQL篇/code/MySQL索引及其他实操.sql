use mydb;

#查看索引
show index from orders;

#创建索引
create index oid_index on orders(oid);
alter table orders add index cid_index(customerid);
#删除索引
drop index cid_index on orders;
#explain语句
explain select * from orders where oid='US-2017-1357144';
explain select * from orders;
explain select count(*) from orders;

#函数
#内置函数
select count(*) from orders;
select current_date();

#自定义函数
select customername,sum(salesnum) from orders 
	where customername='马丽' group by customername;

select customername,sum(salesnum) from orders 
	where customername='邹涛' group by customername;

show variables like 'log_bin_trust_%';
set global log_bin_trust_function_creators=1;
show variables like 'log_bin_trust_%';

delimiter //
create
	function customer_sales(ct_name varchar(10))
    returns int
begin
	declare sales_num int;
    select sum(salesnum) into sales_num from orders where customername=ct_name group by customername;
	return sales_num;
end //
delimiter ;

#调用函数
select customer_sales('邹涛');

#存储过程
select * from orders where customername='邹涛';
select * from orders where customername='马丽';

delimiter //
create procedure ct_info(ct_name varchar(10))
begin
	select * from orders where customername=ct_name;
end //
delimiter ;

#调用存储过程
call ct_info('马丽');
drop procedure ct_info;

#游标
create table delivery_days_tb(
	id int(10),
    oid varchar(20),
    delivery_days int(5)
);

select * from delivery_days_tb;

delimiter //
create procedure days_rst_pro(ct_name varchar(10))
begin
	declare done int default 0;
    declare para_id int(5);
    declare para_oid varchar(20);
    declare para_senddate date;
    declare para_orderdate date;
    declare days_cursor cursor for select id,oid,senddate,orderdate from orders where customername=ct_name;
    declare continue handler for not FOUND set done=1;
    open days_cursor;
    repeat
		fetch days_cursor into para_id,para_oid,para_senddate,para_orderdate;
        if not done then
			insert into delivery_days_tb(id,oid,delivery_days)
				select para_id,para_oid,datediff(para_senddate,para_orderdate) as delivery_days;
		end if;
	until done end repeat;
    close days_cursor;
end //
delimiter ;

call days_rst_pro('马丽');
select * from delivery_days_tb;

#事务
create table bank_account(
	id int unsigned auto_increment primary key,
    account_name varchar(10),
    account_balance decimal(10,2)
);

insert into bank_account(account_name,account_balance) values('客户A',500),('客户B',300);
select * from bank_account;

#创建事务
begin;
update bank_account set account_balance=400 where id=1;
update bank_account set account_balance=400 where id=2;
#如果以上之一发生异常，则执行rollback
rollback;
#如果没有问题，则提交
commit;

select * from bank_account;
