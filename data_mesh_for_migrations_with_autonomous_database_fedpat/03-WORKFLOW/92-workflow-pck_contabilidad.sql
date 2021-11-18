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

        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 03                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Agregamos los registros a eliminar en el merge, estos quedaran con id_asiento en NULL     |
        |                 para poder identificarlos y borrarlos de la BT.                                           |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                    |
        --[Proceso] Truncando Particiones. Obteniendo lista de meses para truncatar--------------------------------*/
        l_partition_date_list := obi_utility.get_months_list_fn(p_start_date => p_fecha_desde,                    --|
                                                                p_end_date   => p_fecha_hasta);                   --|
        IF l_partition_date_list IS NOT NULL THEN                                                                 --|
            obi_utility.purge_partitioned_tables_sp(p_table_name           => 'BT_ANEXO_COMISIONARIO',            --|
                                                    p_high_value_date_list => l_partition_date_list,              --|
                                                    p_update_indexes_flag  => 'S');                               --|
        END IF;                                                                                                   --|
        --[fin] Step 03--------------------------------------------------------------------------------------------*/

        /*----------------------------------------------------------------------------------------------------------.
        | STEP          : 04                                                                                        |
        | LAYER         : WORKFLOW                                                                                  |
        | MODULE        : Contabilidad                                                                              |
        | DESCRIPTION   : Tabla final.                                                                              |
        `-----------------------------------------------------------------------------------------------------------|
                                                                                                                    |
        --[Proceso] Insertar Datos---------------------------------------------------------------------------------*/
        INSERT INTO obi_data.bt_anexo_comisionario(                                                               --|
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
        --[fin] Step 04--------------------------------------------------------------------------------------------*/

    END procesa_anexo_comisionario;

END pck_contabilidad;
/