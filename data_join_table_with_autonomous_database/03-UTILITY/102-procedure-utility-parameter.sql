CREATE OR REPLACE PROCEDURE utl.sp_set_parameter (
  p_Wkf_Name        IN  VARCHAR2        DEFAULT NULL,
  p_Query           IN  CLOB            DEFAULT NULL,
  --Output
  o_Query           OUT CLOB)
AS
  --Variables:Output
  v_Query           CLOB                                  := NULL;
  --Variables
  v_IdParameter     utl.parameter.idparameter%TYPE        := 0;
  v_Order           utl.parameter.par_order%TYPE          := 0;
  v_Name            utl.parameter.par_name%TYPE           := 0;
  v_Value           utl.parameter.par_value%TYPE          := 0;
  CURSOR c_Parameter IS SELECT idParameter, par_order, par_name, par_value
                        FROM utl.parameter
                        WHERE (wkf_name = p_Wkf_Name AND audit_status = 1)
                        ORDER BY par_order;
BEGIN
  /*---------------------------------------------------------------------------------------------------------------.
  | LAYER         : UTILITY                                                                                        |
  | MODULE        : Parmeter                                                                                       |
  | DESCRIPTION   : Remplazo de variables dentro de una consulta PL/SQL.                                           |
  `----------------------------------------------------------------------------------------------------------------|
                                                                                                                   |
  --[01] Query----------------------------------------------------------------------------------------------------*/
    v_Query := p_Query;                                                                                          --|
                                                                                                                 --|
  --[02] Remplazando parametros-----------------------------------------------------------------------------------*/
    OPEN c_Parameter;                                                                                            --|
        LOOP                                                                                                     --|
            FETCH c_Parameter INTO v_IdParameter, v_Order, v_Name, v_Value;                                      --|
                                                                                                                 --|
            EXIT WHEN c_Parameter%NOTFOUND;                                                                      --|
                                                                                                                 --|
            SELECT                                                                                               --|
            REPLACE(v_Query, A.par_name, A.par_value) INTO v_Query                                               --|
            FROM utl.parameter A                                                                                 --|
            WHERE (A.idparameter = v_IdParameter);                                                               --|
        END LOOP;                                                                                                --|
    CLOSE c_Parameter;                                                                                           --|
                                                                                                                 --|
    --[03] Return-------------------------------------------------------------------------------------------------*/
    o_Query := v_Query;                                                                                          --|
                                                                                                                 --|
   --[fin]--------------------------------------------------------------------------------------------------------*/

END;
/