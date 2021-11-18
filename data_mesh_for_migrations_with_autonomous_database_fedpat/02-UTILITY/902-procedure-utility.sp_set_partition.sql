CREATE OR REPLACE PROCEDURE obi_utility.sp_set_partition(
  par_start_date           IN   DATE,
  par_fecha_hasta          IN   DATE,
  par_table_name           IN   VARCHAR2,
  par_update_indexes_flag  IN   VARCHAR2 DEFAULT 'S')
AS
  var_partition_date_list VARCHAR2(4000);
BEGIN
  /*----------------------------------------------------------------------------------------------------------------.
  |                                    [UTILITY] DATA-LAYER                                                         |
  |-----------------------------------------------------------------------------------------------------------------|
  | PROJECT       : Contabilidad                                                                                    |
  | LAYER         : UTILITY                                                                                         |
  | MODULE        : PROCEDURE                                                                                       |
  | DESCRIPTION   : Truncando Particiones. Obteniendo lista de meses para truncatar.                                |
  |-----------------------.----------------------.------------------------------------------------------------------|
  | DATA-LAYER            | SCHEMA NAME          | OBJECT NAME                                                      |
  |-----------------------|----------------------|------------------------------------------------------------------|
  | UTILITY               | OBI_UTILITY          | sp_set_partition                                                 |
  `-----------------------------------------------------------------------------------------------------------------|
                                                                                                                    |
  --Inicio del Proceso---------------------------------------------------------------------------------------------*/
        var_partition_date_list := obi_utility.get_months_list_fn(p_start_date => par_start_date,                 --|
                                                                  p_end_date   => par_fecha_hasta);               --|
        IF var_partition_date_list IS NOT NULL THEN                                                               --|
            obi_utility.purge_partitioned_tables_sp(p_table_name           => par_table_name,                     --|
                                                    p_high_value_date_list => var_partition_date_list,            --|
                                                    p_update_indexes_flag  => par_update_indexes_flag);           --|
        END IF;                                                                                                   --|
                                                                                                                  --|
  --[fin] Step 01--------------------------------------------------------------------------------------------------*/
END;
/