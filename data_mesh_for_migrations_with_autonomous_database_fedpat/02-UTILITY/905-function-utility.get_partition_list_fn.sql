CREATE OR REPLACE FUNCTION obi_utility.get_partition_list_fn (
        p_table_name             IN   VARCHAR2,
        p_high_value_date_list   IN   VARCHAR2
    ) RETURN VARCHAR2 IS
        v_partition_list         VARCHAR2(4000);
        v_partition_date_table   partition_date_table_type := partition_date_table_type();
    BEGIN
        WITH partition_date AS (
            SELECT
                p_high_value_date_list partition_date_list
            FROM
                dual
        )
        SELECT
            obi_utility.partition_date_row_type(trunc(last_day(to_date(regexp_substr(partition_date_list, '[^,]+', 1, level), 'DD/MM/YYYY')) +
            1))
        BULK COLLECT
        INTO v_partition_date_table
        FROM
            partition_date
        CONNECT BY
            level <= length(regexp_replace(partition_date_list, '[^,]+')) + 1;

        BEGIN
            WITH tab_partitions AS (
                SELECT
                    table_name,
                    partition_name,
                    to_date(TRIM('''' FROM regexp_substr(extractvalue(dbms_xmlgen.getxmltype('select high_value from user_tab_partitions where table_name='''
                                                                                             || table_name
                                                                                             || ''' and partition_name = '''
                                                                                             || partition_name
                                                                                             || ''''), '//text()'), '''.*?''')), 'syyyy-mm-dd hh24:mi:ss'
                                                                                             ) high_value_in_date_format
                FROM
                    user_tab_partitions
                WHERE
                    table_name = p_table_name
                    AND interval = 'YES'
            )
            SELECT
                LISTAGG(partition_name, ',') WITHIN GROUP(
                    ORDER BY
                        high_value_in_date_format
                ) AS table_partition_list
            INTO v_partition_list
            FROM
                tab_partitions
            WHERE
                high_value_in_date_format IN (
                    SELECT
                        partition_date
                    FROM
                        TABLE ( v_partition_date_table )
                );
        v_partition_date_table.DELETE;
        EXCEPTION
            WHEN no_data_found THEN
                v_partition_list := NULL;
            WHEN OTHERS THEN
                RAISE;
        END;

        RETURN v_partition_list;
    END get_partition_list_fn;
/