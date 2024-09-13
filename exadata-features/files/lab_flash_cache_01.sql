SET ECHO OFF 
SET FEEDBACK OFF
SET SERVEROUTPUT ON


DECLARE
    TYPE stats_rec IS RECORD (
        name v$sysstat.name%TYPE, 
        value v$mystat.value%TYPE);
    TYPE stats_type IS TABLE OF stats_rec;
    prtir stats_type;
    fcl NUMBER;
    outp_cola_name VARCHAR2(30) := 'NAME';
    outp_cola_width NUMBER := 50;
    outp_colb_name VARCHAR2(30) := 'VALUE';
    outp_colb_width NUMBER := 10;
BEGIN   
    SELECT a.name, b.value
    BULK COLLECT INTO prtir
    FROM v$sysstat a, v$mystat b 
    WHERE a.statistic# = b.statistic# AND 
        a.name IN ('physical read total IO requests',
                   'physical read requests optimized',
                   'cell flash cache read hits');

    SELECT COUNT(*)
    INTO fcl
    FROM fc_lab;

    DBMS_OUTPUT.PUT_LINE(RPAD(outp_cola_name, outp_cola_width + 2) || LPAD(outp_colb_name, outp_colb_width)); 
    DBMS_OUTPUT.PUT_LINE(RPAD('-', outp_cola_width, '-') || '  ' || RPAD('-', outp_colb_width, '-'));

    FOR idx IN prtir.first .. prtir.last LOOP
        IF fcl < 2 AND (prtir(idx).name IN ('physical read requests optimized', 'cell flash cache read hits')) THEN
            prtir(idx).value := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE(RPAD(prtir(idx).name, outp_cola_width + 2) || LPAD(prtir(idx).value, outp_colb_width)); 
    END LOOP;
END;
/
