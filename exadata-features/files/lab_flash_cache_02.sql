declare
  a number;
begin
  for n in (select cust_id from customers_fc) loop
    if mod(n.cust_id, 200) = 0 then
      select cust_credit_limit
        into a
        from customers_fc
        where cust_id=n.cust_id
        and rownum < 2;
    end if;
  end loop;

  insert into fc_lab (msg)
  values (1);
  commit;
end;
/

SET FEEDBACK ON
SET ECHO ON
