CREATE OR REPLACE PROCEDURE obi_utility.purge_partitioned_tables_sp(p_table_name          IN VARCHAR2,
                          p_high_value_date_list   IN   VARCHAR2,
                          p_drop_partition_flag IN VARCHAR2 DEFAULT 'N',
                          p_update_indexes_flag IN VARCHAR2 DEFAULT 'N') IS
        v_partition_list VARCHAR2(4000);
    BEGIN
        v_partition_list := obi_utility.get_partition_list_fn(p_table_name      => p_table_name,
                              p_high_value_date_list => p_high_value_date_list);
        IF v_partition_list IS NOT NULL
        THEN
            IF p_drop_partition_flag = 'S'
            THEN
                obi_utility.drop_partition_sp(p_table_name          => p_table_name,
                          p_partition_name      => v_partition_list,
                          p_update_indexes_flag => p_update_indexes_flag);
            ELSE
                obi_utility.truncate_partition_sp(p_table_name          => p_table_name,
                              p_partition_name      => v_partition_list,
                              p_update_indexes_flag => p_update_indexes_flag);
            
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END purge_partitioned_tables_sp;
/