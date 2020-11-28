Use northwind;

# Vinicius Gustavo bicalho - 2002144 - 2020

#----------Exercicio 1-------------

select * from customers;
select * from orders;
select * from order_details;
select * from products;
select * from employees;

Select 	customers.first_name,
		customers.last_name,
        customers.city,
        customers.state_province,
        products.product_code,
        products.product_name,
        order_details.quantity,
        order_details.unit_price,
        (order_details.quantity * order_details.unit_price) Subtotal,
        employees.first_name,
        employees.last_name
        
        from order_details
        inner join orders on order_details.order_id = orders.id
		inner join customers on customers.id = orders.customer_id
        inner join products on order_details.product_id = products.id
        inner join employees on orders.employee_id = employees.id;
        
#----------Exercicio 2-------------

select * from orders;
select * from customers;
Select 	orders.ship_name,
		orders.ship_address,
		orders.ship_city,
        orders.ship_state_province,
        orders.payment_type = null
       
        from customers
        inner join orders on customer_id = customers.id;
        
#----------Exercicio 03-------------

select * from customers;

Update customers
set job_title = 'Owner'
where id='23';

#----------Exercicio 04-------------

select * from employees;
select * from employee_privileges;
select * from privileges;

select 	employees.id,
		employees.first_name,
        employees.last_name,
        employee_privileges.privilege_id
        
        from employee_privileges
        inner join employees on employees.id = employee_privileges.employee_id;
        
Update employee_privileges
set privilege_id = null
where employee_id = '9';

#----------Exercicio 05-------------

delimiter $$
create function func(produto_ int)
returns int
deterministic
begin

	declare vendido_ int;
	declare compra_ int;
	declare desperdicio_ int;
    declare em_espera int;
    declare stock_ int;
    
    select  avg(quantity)
			into compra_
			from inventory_transactions 
			where product_id = produto_
		    and transaction_type = 1;
	select  avg(quantity)
			into vendido_
			from inventory_transactions 
			where product_id = produto_
			and transaction_type = 2;
	select  avg(quantity)
			into em_espera
			from inventory_transactions
			where product_id = produto_
			and transaction_type = 3;
	select  avg(quantity)
			into desperdicio_
			from inventory_transactions 
			where product_id = produto_
			and transaction_type = 4;
            set stock_ = 0;
            if vendido_ > 0 then set stock_ = stock_ - vendido_;
            end if;
            if compra_ > 0 then set stock_ = stock_ + compra_;
            end if;
            if desperdicio_ > 0 then set stock_ = stock_ - desperdicio_;
            end if;
            if em_espera > 0 then set stock_ = stock_ - em_espera;
            end if;
    return stock_; 
end $$
delimiter ;
select func(2);
        
#----------Exercicio 6-------------

select * from  purchase_orders;

delimiter $$
create procedure sp_status(_purchase_order_id int, _purchase_order_status_id int)
begin
    update purchase_orders set status_id=_purchase_order_status_id where id=_purchase_order_id and exists(select id from purchase_order_status where id=_purchase_order_status_id);
end $$
delimiter ;

call sp_status(91,5);

select * from  purchase_orders where id = 91;
        
#----------Exercicio 7-------------

select * from products;
create view relatorio_produtos as
Select 	products.id,
		products.product_code,
		products.product_name,
        func(products.id) as estoque_
        
        from products;
select * from relatorio_produtos;

#----------Exercicio 8-------------

select * from employees;
select * from orders;
select * from order_details;

Select 	employees.id,
		employees.first_name,
        employees.last_name
        
        from orders
        inner join employees on employees.id = orders.employee_id;
        
#----------Exercicio 9-------------

select * from orders;
select * from order_details;

select
		extract(month from orders.order_date) mes,
		sum((order_details.quantity * order_details.unit_price)) faturamento_mensal
		from orders 
		left join order_details on orders.id = order_details.order_id
			group by mes;
        
#----------Exercicio 10-------------

select * from customers;
select * from orders;
select * from employees;

select	employees.id,
		employees.first_name,
        employees.last_name,
        count(orders.customer_id) AS clientes_atendidos
        
        from employees
        inner join orders on employees.id = orders.employee_id
		group by employees.id
        