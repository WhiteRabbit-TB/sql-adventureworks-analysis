-- TASK 1
with PirmiUzsakymai as
(
   select
    customerid,
    min(orderdate) PirmasUzsakymas
    from sales_salesorderheader
    group by customerid
),
Uzsakymai2014 as 
(select
   customerid,
   salesorderid,
   orderdate,
  round(sum(case when year(orderdate) = 2014 then totaldue end) over (partition by customerid),2) suma
from sales_salesorderheader
where year(orderdate)= 2014
),

average2013 as
(select distinct
    customerid,
    round(avg(case when year(orderdate) = 2013 then totaldue end) over (partition by customerid),2) vidurk
from
    sales_salesorderheader
)
select
    sc.CustomerID id,
    pp.FirstName vardas,
    pp.LastName pavarde,
    a13.vidurk Uzsakymo_vidurkis_2013,
    u14.salesorderid uzsakymoID,
    date(u14.orderdate) uzsakymo_data,
    u14.suma suma,
    dense_rank() over(partition by sc.CustomerID order by u14.orderdate) as ranked
from
    sales_customer sc
join person_person pp on sc.personid = pp.businessentityid
join PirmiUzsakymai u on u.customerid = sc.customerid
left join Uzsakymai2014 u14 on u14.customerid = sc.customerid   -- Naudoju left join, nes ne visi turi uzsakymus 2014m.
join average2013 a13 on a13.customerid = sc.customerid
where year(u.PirmasUzsakymas) = 2013;

-- TASK 2
select
    ppc.name kategorija,
    sst.name regionas,
    round(sum(ssod.linetotal),2) suma
from sales_salesorderdetail ssod
join production_product pp on ssod.productid = pp.productid
join production_productsubcategory ppsc on pp.productsubcategoryid = ppsc.productsubcategoryid
join production_productcategory ppc on ppc.productcategoryid = ppsc.productcategoryid
join sales_salesorderheader ssh on ssh.salesorderid = ssod.salesorderid
join sales_salesterritory sst on sst.territoryid = ssh.territoryid
where year(ssh.orderdate) = 2013
group by ppc.name,sst.name;

-- TASK 3

with darbuotojopard as
(
   select
    pp.businessentityid id,
    pp.FirstName vardas,
    pp.lastname pavarde,
    hd.departmentid,
    hd.name departamentas,
    round(sum(ssh.totaldue),2) darbuotojo_pardavimai
    from sales_salesorderheader ssh
	join person_person pp on ssh.salespersonid = pp.businessentityid
    join humanresources_employeedepartmenthistory edh on edh.businessentityid = pp.businessentityid
    join humanresources_department hd on hd.departmentid = edh.departmentid
    group by pp.businessentityid, pp.FirstName, pp.lastname, hd.name
)

select
    id,
    vardas,
    pavarde,
    departamentas,
    darbuotojo_pardavimai,
    round(avg(darbuotojo_pardavimai) over (partition by departmentid),2) departamento_pard_vidurkis,
    round(darbuotojo_pardavimai / avg(darbuotojo_pardavimai) over (partition by departmentid) * 100, 1) santykinis_nasumas_proc,
    case when darbuotojo_pardavimai > avg(darbuotojo_pardavimai) over (partition by departmentid) then 'Viršija vidurkį'
         when darbuotojo_pardavimai = avg(darbuotojo_pardavimai) over (partition by departmentid) then 'Atitinka vidurkį'
         else 'Nesiekia vidurkio'
    end as vertinimas
from darbuotojopard
order by darbuotojo_pardavimai desc;

-- Task 4

select 
     pps.name prekes_grupe,
     sum(ssd.orderqty) kiekis,
     round(sum(ssd.linetotal),2) pardavimu_suma,
     round(sum(ssd.linetotal) / sum(ssd.orderqty),2) as vidutine_pardavimo_kaina
  from sales_salesorderdetail ssd 
  join sales_salesorderheader ssh on ssh.salesorderid = ssd.salesorderid
  join production_product pp on pp.productid = ssd.productid
  join production_productsubcategory pps on pps.productsubcategoryid = pp.productsubcategoryid
where year(ssh.orderdate) = 2013
group by pps.name
order by `vidutine_pardavimo_kaina` desc;

-- Task 5

select
    pv.Name as tiekejas,
    pp.Name as produktas,
    round(avg(datediff(poh.ShipDate, poh.OrderDate)), 0) as vid_pristatymo_laikas
from Production_Product pp
join Purchasing_PurchaseOrderDetail pod on pp.ProductID = pod.ProductID
join Purchasing_PurchaseOrderHeader poh on pod.PurchaseOrderID = poh.PurchaseOrderID
join Purchasing_Vendor pv on poh.VendorID = pv.BusinessEntityID
where poh.ShipDate is not null
group by pv.Name, pp.Name
order by pv.Name, pp.Name;

-- Task 6

select
   Month(orderdate) menuo,
   Monthname(orderdate) menuo_pavadinimas,
   count(orderdate) pardavimu_kiekis,
   round(sum(totaldue),2) pardavimu_suma
from sales_salesorderheader 
where year(orderdate) = 2013
group by Month(orderdate),Monthname(orderdate)