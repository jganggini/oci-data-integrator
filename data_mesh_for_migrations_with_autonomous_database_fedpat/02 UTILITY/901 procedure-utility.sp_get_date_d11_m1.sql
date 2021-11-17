CREATE OR REPLACE PROCEDURE obi_utility.sp_get_date_d11_m1(
  out_end_date       IN  DATE     DEFAULT SYSDATE,
  out_start_date     OUT DATE,
  out_end_date       OUT DATE)
AS
BEGIN
  /*----------------------------------------------------------------------------------------------------------------.
  |                                    [UTILITY] DATA-LAYER                                                         |
  |-----------------------------------------------------------------------------------------------------------------|
  | PROJECT       : Contabilidad                                                                                    |
  | LAYER         : UTILITY                                                                                         |
  | MODULE        : FUNCTION                                                                                        |
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
  out_end_date := out_start_date;                                                                                 --|
  IF trunc(out_end_date) < trunc(out_end_date, 'MM') + 10 THEN                                                    --|
    out_start_date := add_months(trunc(out_end_date, 'MM'), -1);                                                  --|
  ELSE                                                                                                            --|
    out_start_date := trunc(out_end_date, 'MM');                                                                  --|
  END IF;                                                                                                         --|
  --[fin] Step 01--------------------------------------------------------------------------------------------------*/
END;
/