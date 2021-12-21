  CREATE OR REPLACE PROCEDURE utl.sp_get_data_join (
  p_Wkf_Name        IN  VARCHAR2        DEFAULT NULL,
  p_Map_Name        IN  VARCHAR2        DEFAULT NULL)
AS
  --Variables  
  v_Query           CLOB                                  := NULL;
  v_Query_All       CLOB                                  := NULL;
  v_Count           NUMBER(10)                            := 0;
BEGIN
  /*---------------------------------------------------------------------------------------------------------------.
  | LAYER         : UTILITY                                                                                        |
  | MODULE        : Data Join                                                                                      |
  | DESCRIPTION   : Union de tablas de forma dinamica con una misma estructura en diferentes esquemas.             |
  `----------------------------------------------------------------------------------------------------------------|
                                                                                                                   |
  --[01] Count----------------------------------------------------------------------------------------------------*/
    v_Count := 0;                                                                                                --|
                                                                                                                 --|
  --[02] Parametros del Proceso-----------------------------------------------------------------------------------*/
    FOR record IN (SELECT par_value FROM UTL.PARAMETER                                                           --|
                   WHERE (wkf_name = p_Wkf_Name AND audit_status = 1 AND par_order < 99)                         --|
                   ORDER BY par_order ASC)                                                                       --|
    LOOP                                                                                                         --|
                                                                                                                 --|
      --[02.1] Count----------------------------------------------------------------------------------------------*/
      v_count := v_count + 1;                                                                                    --|
                                                                                                                 --|
      --[02.1] Remplazar el parametro "p_rows" de la consulta-----------------------------------------------------*/
      v_Query := q'[SELECT p_rows, "v_schema_name" AS schema_name FROM p_table_name_]';                          --|
      utl.sp_set_parameter(p_Wkf_Name,v_Query,v_Query);                                                          --|
                                                                                                                 --|
      --[02.2] Remplazar el parametro "p_schema_#" de la consulta-------------------------------------------------*/
      v_Query := v_Query || TO_CHAR(v_count);                                                                    --|
      utl.sp_set_parameter(p_Wkf_Name,v_Query,v_Query);                                                          --|
                                                                                                                 --|
      --[02.3] Remplazar el parametro "v_schema_name" de la consulta----------------------------------------------*/
      v_Query := REPLACE(v_Query, 'v_schema_name', record.par_value);                                            --|
                                                                                                                 --|
      --[02.3] Agregar UNION ALL a la consulta--------------------------------------------------------------------*/
      v_Query := v_Query || 'UNION ALL ';                                                                        --|
                                                                                                                 --|
    END LOOP;                                                                                                    --|
                                                                                                                 --|
  --[03] Eliminar tabla temporal de mapeo-------------------------------------------------------------------------*/
    BEGIN                                                                                                        --|
      EXECUTE IMMEDIATE 'DROP TABLE MAP.'||p_Map_Name;                                                           --|
    EXCEPTION                                                                                                    --|
      WHEN OTHERS THEN                                                                                           --|
        IF SQLCODE != -942 THEN                                                                                  --|
          RAISE;                                                                                                 --|
        END IF;                                                                                                  --|
    END;                                                                                                         --|
                                                                                                                 --|
  --[04] Ejecutar consulta----------------------------------------------------------------------------------------*/
    v_Query := 'CREATE TABLE MAP.'||p_Map_Name||' AS '||SUBSTR(v_Query, 1, LENGTH(v_Query) - 10);                --|
    EXECUTE IMMEDIATE v_Query;                                                                                   --|
    COMMIT;                                                                                                      --|
                                                                                                                 --|
   --[fin]--------------------------------------------------------------------------------------------------------*/

END;
/