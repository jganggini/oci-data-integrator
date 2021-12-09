CREATE OR REPLACE PROCEDURE admin.truncate_partition_sp(p_table_name          IN VARCHAR2,
                    p_partition_name      IN VARCHAR2,
                    p_update_indexes_flag IN VARCHAR2 DEFAULT 'N') IS
    
    BEGIN
    
        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' TRUNCATE PARTITION ' || p_partition_name || (CASE
                      WHEN UPPER(p_update_indexes_flag) = 'S' THEN
                       '  UPDATE INDEXES'
                      ELSE
                       ' '
                  END);
    
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END truncate_partition_sp;
/