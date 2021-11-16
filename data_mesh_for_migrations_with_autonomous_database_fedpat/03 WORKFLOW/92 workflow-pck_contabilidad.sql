CREATE OR REPLACE 
PACKAGE obi_workflow.pck_contabilidad AS

    PROCEDURE procesa_anexo_comisionario (
        p_fecha_desde   IN   DATE,
        p_fecha_hasta   IN   DATE
    );   

END;
/

CREATE OR REPLACE 
PACKAGE BODY pck_contabilidad AS
    
    --[log: variables]----------------------------------------------------------
    l_nm_proceso         bi_log_procesos.nm_proceso%TYPE;                    --
    l_id_proceso         bi_log_procesos.id_proceso%TYPE;                    --
    l_id_subproceso      bi_log_procesos.id_subproceso%TYPE;                 --
    l_id_operacion       bi_log_procesos.id_operacion%TYPE;                  --
    l_nivel_proceso      BOOLEAN;                                            --
    l_cant_registros     bi_log_procesos.cant_registros%TYPE;                --
    l_msg                VARCHAR2(250);                                      --
    l_error              VARCHAR2(3000);                                     --
    --[Schemas/Tables]: variables para definir esquemas y tablespaces----------
    l_esquema_origen     VARCHAR2(20);                                       --
    l_esquema_destino    VARCHAR2(20);                                       --
    l_tblspace_origen    VARCHAR2(30);                                       --
    l_tblspace_destino   VARCHAR2(30);                                       --
    ---------------------------------------------------------------------------

END pck_contabilidad;
/

    PROCEDURE procesa_anexo_comisionario (
        p_fecha_desde   IN   DATE,
        p_fecha_hasta   IN   DATE
    ) IS
        l_partition_date_list VARCHAR2(4000);
    BEGIN
        l_cant_registros := NULL;
    
        --[log] Inicio Subproceso-----------------------------------------------------------------------------------.
        l_id_subproceso := obi_staging.pck_bi_log_procesos.ini_subproceso(l_id_proceso, l_nm_proceso,             --|
                                                                         'PROCESA_ANEXO_COMISIONARIO');           --|
        -----------------------------------------------------------------------------------------------------------*/
    
        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 01                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Vista Origen                                                                              |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                  --|
        --[Log] Inicio de Operación--------------------------------------------------------------------------------*/
        l_id_operacion := obi_staging.pck_bi_log_procesos.ini_operacion(l_id_proceso, l_id_subproceso,            --|
                                                                       'BI_READER.VAUX_ANEXO_COMISIONARIO',       --|
                                                                       'BI_READER.TMP_ANEXO_COMISIONARIO_GTT');   --|
        --[proceso] Anexo Comisionario------------------------------------------------------------------------------|
        --obi_staging.sp_anexo_comisionario_ins_tmp(p_fecha_desde => p_fecha_desde,                                 --|
        --                                          p_fecha_hasta => p_fecha_hasta);                                --|
        --[Log] Fin de Operación------------------------------------------------------------------------------------|
        SELECT COUNT(1) INTO l_cant_registros FROM tmp_anexo_comisionario_gtt;                                    --|
        obi_staging.pck_bi_log_procesos.fin_operacion(l_id_proceso, l_id_subproceso,                              --|
                                                      l_id_operacion, l_cant_registros);                          --|
        --[fin] Step 01--------------------------------------------------------------------------------------------*/
    
        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 02                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Traspaso de datos a tabla local para luego hacer merge                                    |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                  --|
        --[Log] Inicio de Operación--------------------------------------------------------------------------------*/
        l_id_operacion := obi_staging.pck_bi_log_procesos.ini_operacion(l_id_proceso, l_id_subproceso,            --|
                                                           'BI_READER.TMP_ANEXO_COMISIONARIO_GTT',                --|
                                                            l_esquema_origen||'.TMP_CON_ANEXO_COMISIONARIO_GTT'); --|
        --[proceso] Truncate Table----------------------------------------------------------------------------------|
        EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CON_ANEXO_COMISIONARIO_GTT';                                        --|
        ------------------------------------------------------------------------------------------------------------|
        INSERT INTO obi_staging.tmp_con_anexo_comisionario_gtt(                                                   --|
            --------------------------------->--------------------------------->----------------------------------->|
            ttac_id_anexo_comisionario,       ttac_cd_compania,                 ttac_am_comision,                 --|
            ttac_fe_comision,                 ttac_cd_tipo_anexo_com,           ttac_nu_cuit,                     --|
            ttac_cd_productor,                ttac_cd_rol_productor,            ttac_tp_comision,                 --|
            ttac_cd_sucursal,                 ttac_cd_ramo,                     ttac_nu_poliza,                   --|
            ttac_nu_certificado,              ttac_nu_endoso,                   ttac_nu_siniestro,                --|
            ttac_nu_annio,                    ttac_id_siniestro,                ttac_id_poliza,                   --|
            ttac_id_certificado,              ttac_id_endoso,                   ttac_mt_prima,                    --|
            ttac_mt_comision_normal,          ttac_mt_comision_cobranza,        ttac_mt_comision_fomento,         --|
            ttac_mt_comision_otras,           ttac_mt_comision_total,           ttac_mt_comision_total_pesos,     --|
            ttac_tasa_cambio                                                                                      --|
        ) SELECT                                                                                                  --|
            --------------------------------->--------------------------------->----------------------------------->|
            ttac_id_anexo_comisionario,       ttac_cd_compania,                 ttac_am_comision,                 --|
            ttac_fe_comision,                 ttac_cd_tipo_anexo_com,           ttac_nu_cuit,                     --|
            ttac_cd_productor,                ttac_cd_rol_productor,            ttac_tp_comision,                 --|
            ttac_cd_sucursal,                 ttac_cd_ramo,                     ttac_nu_poliza,                   --|
            ttac_nu_certificado,              ttac_nu_endoso,                   ttac_nu_siniestro,                --|
            ttac_nu_annio,                    ttac_id_siniestro,                ttac_id_poliza,                   --|
            ttac_id_certificado,              ttac_id_endoso,                   ttac_mt_prima,                    --|
            ttac_mt_comision_normal,          ttac_mt_comision_cobranza,        ttac_mt_comision_fomento,         --|
            ttac_mt_comision_otras,           ttac_mt_comision_total,           ttac_mt_comision_total_pesos,     --|
            ttac_tasa_cambio                                                                                      --|
        FROM obi.staging.tmp_anexo_comisionario_gtt;                                                                          --|
        --[Log] Fin de Operación------------------------------------------------------------------------------------|
        l_cant_registros := SQL%rowcount;                                                                         --|
        pck_bi_log_procesos.fin_operacion(l_id_proceso, l_id_subproceso, l_id_operacion, l_cant_registros);       --|
        --[fin] Step 02--------------------------------------------------------------------------------------------*/

        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 03                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Agregamos los registros a eliminar en el merge, estos quedaran con id_asiento en NULL     |
        |                 para poder identificarlos y borrarlos de la BT.                                           |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                    |
        --[inicio] Log Operación-----------------------------------------------------------------------------------*/
        l_id_operacion := obi_staging.pck_bi_log_procesos.ini_operacion(l_id_proceso, l_id_subproceso,            --|
                                                            l_esquema_destino || '.BT_ANEXO_COMISIONARIO', '');   --|
        --[Proceso] Truncando Particiones. Obteniendo lista de meses para truncatar---------------------------------|
        l_partition_date_list := pck_utils.get_months_list_fn(p_start_date => p_fecha_desde,                      --|
                                                            p_end_date => p_fecha_hasta);                         --|
        IF l_partition_date_list IS NOT NULL THEN                                                                 --|
            pck_utils.purge_partitioned_tables_sp(p_table_name => 'BT_ANEXO_COMISIONARIO',                        --|
                                                p_high_value_date_list => l_partition_date_list,                  --|
                                                p_update_indexes_flag => 'S');                                    --|
        END IF;                                                                                                   --|
        --[Log] Fin de Operación------------------------------------------------------------------------------------|
        obi_staging.pck_bi_log_procesos.fin_operacion(l_id_proceso, l_id_subproceso,                              --|
                                                     l_id_operacion, l_cant_registros);                           --|
        --[fin] Step 03--------------------------------------------------------------------------------------------*/

        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 04                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Tabla final.                                                                              |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                    |
        --[inicio] Log Operación-----------------------------------------------------------------------------------*/
        l_id_operacion := obi_staging.pck_bi_log_procesos.ini_operacion(l_id_proceso, l_id_subproceso,            --|
                                                            l_esquema_origen||'.TMP_CON_ANEXO_COMISIONARIO_GTT',  --|
                                                            l_esquema_destino||'.BT_ANEXO_COMISIONARIO');         --|
        --[Proceso] Insertar Datos----------------------------------------------------------------------------------|
        INSERT INTO obi_data.bt_anexo_comisionario(                                                                        --|
            --------------------------------->--------------------------------->----------------------------------->|
            btac_id_anexo_comisionario,       btac_cd_compania,                 btac_am_comision,                 --|
            btac_fe_comision,                 btac_cd_tipo_anexo_com,           btac_nu_cuit,                     --|
            btac_cd_productor,                btac_cd_rol_productor,            btac_tp_comision,                 --|
            btac_cd_sucursal,                 btac_cd_ramo,                     btac_nu_poliza,                   --|
            btac_nu_certificado,              btac_nu_endoso,                   btac_nu_siniestro,                --|
            btac_nu_annio,                    btac_id_siniestro,                btac_id_poliza,                   --|
            btac_id_certificado,              btac_id_endoso,                   btac_mt_prima,                    --|
            btac_mt_comision_normal,          btac_mt_comision_cobranza,        btac_mt_comision_fomento,         --|
            btac_mt_comision_otras,           btac_mt_comision_total,           btac_mt_comision_total_pesos,     --|
            btac_tasa_cambio                                                                                      --|
        ) SELECT                                                                                                  --|
            --------------------------------->--------------------------------->----------------------------------->|
            ttac_id_anexo_comisionario,       ttac_cd_compania,                 ttac_am_comision,                 --|
            ttac_fe_comision,                 ttac_cd_tipo_anexo_com,           ttac_nu_cuit,                     --|
            ttac_cd_productor,                ttac_cd_rol_productor,            ttac_tp_comision,                 --|
            ttac_cd_sucursal,                 ttac_cd_ramo,                     ttac_nu_poliza,                   --|
            ttac_nu_certificado,              ttac_nu_endoso,                   ttac_nu_siniestro,                --|
            ttac_nu_annio,                    ttac_id_siniestro,                ttac_id_poliza,                   --|
            ttac_id_certificado,              ttac_id_endoso,                   ttac_mt_prima,                    --|
            ttac_mt_comision_normal,          ttac_mt_comision_cobranza,        ttac_mt_comision_fomento,         --|
            ttac_mt_comision_otras,           ttac_mt_comision_total,           ttac_mt_comision_total_pesos,     --|
            ttac_tasa_cambio                                                                                      --|
        FROM obi_staging.tmp_con_anexo_comisionario_gtt;                                                          --|
                                                                                                                  --|
        --[Proceso] Analizar Datos----------------------------------------------------------------------------------|
        l_cant_registros := SQL%rowcount;                                                                         --|
        COMMIT;                                                                                                   --|
        obi_data.analiza_tabla('BT_ANEXO_COMISIONARIO');                                                          --|
        --[Log] Fin de Operación------------------------------------------------------------------------------------|
        obi_staging.pck_bi_log_procesos.fin_operacion(l_id_proceso, l_id_subproceso,                              --|
                                                      l_id_operacion, l_cant_registros);                          --|
        --[fin] Step 04--------------------------------------------------------------------------------------------*/

        --[log] Fin Subproceso--------------------------------------------------------------------------------------.
        obi_staging.pck_bi_log_procesos.fin_subproceso(l_id_proceso, l_id_subproceso, l_nivel_proceso);           --|
        -----------------------------------------------------------------------------------------------------------*/

    EXCEPTION
        WHEN OTHERS THEN
            l_error := substr(dbms_utility.format_error_stack, 1, 3800)
                       || replace(dbms_utility.format_error_backtrace, 'ORA-06512');

            l_error := l_msg
                       || ': '
                       || l_error;
            pck_bi_log_procesos.fin_subproceso(l_id_proceso, l_id_subproceso, l_nivel_proceso, l_id_operacion, l_error);
            pck_bi_log_procesos.fin_proceso(l_id_proceso, l_error);
            RAISE;
    END procesa_anexo_comisionario;

END pck_contabilidad;
/