CREATE OR REPLACE PROCEDURE obi_workflow.refresca_anexo_comisionario(
  par_fecha_desde     IN  DATE     DEFAULT SYSDATE,
  par_fecha_hasta     IN  DATE     DEFAULT SYSDATE)
AS
BEGIN
   /*---------------------------------------------------------------------------------------------------------------.
   | STEP          : 01                                                                                             |
   | LAYER         : WORKFLOW                                                                                       |
   | MODULE        : Contabilidad                                                                                   |
   | DESCRIPTION   : Procesa Anexo Comisionario                                                                     |
   `----------------------------------------------------------------------------------------------------------------|
                                                                                                                    |
   --[proceso] Procesa Anexo Comisionario--------------------------------------------------------------------------*/
      pck_contabilidad.procesa_anexo_comisionario(p_fecha_desde => par_fecha_desde,                               --|
                                                  p_fecha_hasta => par_fecha_hasta);                              --|
   --[fin] Step 01-------------------------------------------------------------------------------------------------*/
END;
/