CREATE OR REPLACE PROCEDURE obi_workflow.refresca_anexo_comisionario(
  par_current_date     IN  DATE     DEFAULT SYSDATE)
AS
  --[log: variables]------------------------------------------------------------------------------------------------.
  l_nm_proceso         bi_log_procesos.nm_proceso%TYPE;                                                           --|
  l_id_proceso         bi_log_procesos.id_proceso%TYPE;                                                           --|
  l_id_subproceso      bi_log_procesos.id_subproceso%TYPE;                                                        --|
  l_id_operacion       bi_log_procesos.id_operacion%TYPE;                                                         --|
  l_nivel_proceso      BOOLEAN;                                                                                   --|
  l_cant_registros     bi_log_procesos.cant_registros%TYPE;                                                       --|
  l_msg                VARCHAR2(250);                                                                             --|
  l_error              VARCHAR2(3000);                                                                            --|
  --[Schemas/Tables]: variables para definir esquemas y tablespaces-------------------------------------------------|
  l_esquema_origen     VARCHAR2(20);                                                                              --|
  l_esquema_destino    VARCHAR2(20);                                                                              --|
  l_tblspace_origen    VARCHAR2(30);                                                                              --|
  l_tblspace_destino   VARCHAR2(30);                                                                              --|
  -----------------------------------------------------------------------------------------------------------------*/
BEGIN
   /*---------------------------------------------------------------------------------------------------------------.
   | STEP          : 01                                                                                             |
   | LAYER         : WORKFLOW                                                                                       |
   | MODULE        : Contabilidad                                                                                   |
   | DESCRIPTION   : Procesa Anexo Comisionario                                                                     |
   `----------------------------------------------------------------------------------------------------------------|
                                                                                                                    |
   --[log] Inicio Log Proceso--------------------------------------------------------------------------------------*/
      l_nivel_proceso := true;                                                                                    --|
      l_nm_proceso    := 'REFRESCA_ANEXO_COMISIONARIO';                                                           --|
      l_id_proceso    := pck_bi_log_procesos.ini_proceso(l_nm_proceso);                                           --|
   --[proceso] Procesa Anexo Comisionario---------------------------------------------------------------------------|
      pck_contabilidad.procesa_anexo_comisionario(p_fecha_desde => obi_utility.get_date_d11_m1(par_current_date), --|
                                                p_fecha_hasta => par_current_date);                               --|
   --[utl] Fin de Monitor-------------------------------------------------------------------------------------------|
      pck_bi_log_procesos.fin_proceso(l_id_proceso);                                                              --|
   --[fin] Step 01-------------------------------------------------------------------------------------------------*/

EXCEPTION
   WHEN OTHERS THEN
            l_error := substr(dbms_utility.format_error_stack, 1, 3800)
                       || replace(dbms_utility.format_error_backtrace, 'ORA-06512');

            l_error := l_msg
                       || ': '
                       || l_error;
            pck_bi_log_procesos.fin_proceso(l_id_proceso, l_error);
            pck_bi_log_procesos.fin_proceso (l_id_proceso, l_error);
            RAISE;
END;
/