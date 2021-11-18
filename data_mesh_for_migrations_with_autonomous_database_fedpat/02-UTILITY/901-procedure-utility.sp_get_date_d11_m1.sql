CREATE OR REPLACE PROCEDURE obi_utility.sp_get_date_d11_m1(
  out_start_date     OUT DATE)
AS
  var_current_date  DATE;
BEGIN
  /*----------------------------------------------------------------------------------------------------------------.
  |                                    [UTILITY] DATA-LAYER                                                         |
  |-----------------------------------------------------------------------------------------------------------------|
  | PROJECT       : Contabilidad                                                                                    |
  | LAYER         : UTILITY                                                                                         |
  | MODULE        : PROCEDURE                                                                                       |
  | DESCRIPTION   : La fecha del proceso corresponde al mes vigente y el anterior, en caso de                       |
  |                 estar dentro de los primeros 10 dias del mes vigente, o el vigente si                           |
  |                 pasaron mas de 10 dias.                                                                         |
  |-----------------------.----------------------.------------------------------------------------------------------|
  | DATA-LAYER            | SCHEMA NAME          | OBJECT NAME                                                      |
  |-----------------------|----------------------|------------------------------------------------------------------|
  | UTILITY               | OBI_UTILITY          | sp_get_date_d11_m1                                               |
  `-----------------------------------------------------------------------------------------------------------------|
                                                                                                                    |
  --Inicio del Proceso---------------------------------------------------------------------------------------------*/
  var_current_date := trunc(sysdate);
  IF trunc(var_current_date) < trunc(var_current_date, 'MM') + 10 THEN                                            --|
    out_start_date := add_months(trunc(var_current_date, 'MM'), -1);                                              --|
  ELSE                                                                                                            --|
    out_start_date := trunc(var_current_date, 'MM');                                                              --|
  END IF;                                                                                                         --|
  --[fin] Step 01--------------------------------------------------------------------------------------------------*/
END;
/