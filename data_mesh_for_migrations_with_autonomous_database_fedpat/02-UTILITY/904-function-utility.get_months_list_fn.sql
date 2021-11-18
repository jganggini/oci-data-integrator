CREATE OR REPLACE FUNCTION obi_utility.get_months_list_fn (
        p_start_date             IN   date,
        p_end_date   IN   date
    ) RETURN VARCHAR2 IS
        l_partition_date_list VARCHAR2(4000);
    BEGIN
        BEGIN
            SELECT
                LISTAGG(to_char((add_months(start_date, level - 1)),'DD/MM/YYYY'), ',') WITHIN GROUP(
                    ORDER BY
                        NULL
                )
            INTO l_partition_date_list
            FROM
                (
                    SELECT
                        p_start_date   start_date,
                        p_end_date   end_date
                    FROM
                        dual
                )
            CONNECT BY
                level <= months_between(trunc(end_date, 'MM'), trunc(start_date, 'MM')) + 1;

        EXCEPTION
            WHEN no_data_found THEN
                l_partition_date_list := NULL;
            WHEN OTHERS THEN
                RAISE;
        END;

        RETURN l_partition_date_list;
    END get_months_list_fn;
/