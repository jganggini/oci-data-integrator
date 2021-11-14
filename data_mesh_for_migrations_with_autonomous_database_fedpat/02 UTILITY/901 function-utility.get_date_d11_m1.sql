
  /*-------------------------------------------------------------------------------------------.
  |                                    [UTILITY] DATA-LAYER                                    |
  |--------------------------------------------------------------------------------------------|
  | PROJECT       : Contabilidad                                                               |
  | LAYER         : UTILITY                                                                    |
  | MODULE        : FUNCTION                                                                   |
  | DESCRIPTION   : La fecha del proceso corresponde al mes vigente y el anterior, en caso de  |
  |                 estar dentro de los primeros 10 dias del mes vigente, o el vigente si      |
  |                 pasaron mas de 10 dias.                                                    |
  |-----------------------.----------------------.---------------------------------------------|
  | DATA-LAYER            | SCHEMA NAME          | OBJECT NAME                                 |
  |-----------------------|----------------------|---------------------------------------------|
  | UTILITY               | OBI_UTILITY          | get_date_d11_m1                             |
  `-------------------------------------------------------------------------------------------*/
  
  CREATE OR REPLACE FUNCTION obi_utility.get_date_d11_m1(
    i_start_date IN DATE
  )
  RETURN DATE
    IS v_return DATE;
  BEGIN
  
    IF trunc(i_start_date) < trunc(i_start_date, 'MM') + 10 THEN
        v_return := add_months(trunc(i_start_date, 'MM'), -1);
    ELSE
        v_return := trunc(i_start_date, 'MM');
    END IF;
  
  RETURN(v_return);
END;
/