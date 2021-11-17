CREATE OR REPLACE PROCEDURE obi_workflow.refresca_anexo_comisionario(
  par_fecha_desde     IN  DATE     DEFAULT SYSDATE)
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
                                                  p_fecha_hasta => trunc(sysdate));                               --|
   --[fin] Step 01-------------------------------------------------------------------------------------------------*/
END;
/