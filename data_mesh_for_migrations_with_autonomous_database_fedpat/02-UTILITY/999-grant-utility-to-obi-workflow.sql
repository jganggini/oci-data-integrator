--New
GRANT EXECUTE ON obi_utility.sp_get_date                 TO obi_workflow;
GRANT EXECUTE ON obi_utility.sp_get_date_d11_m1          TO obi_workflow;
GRANT EXECUTE ON obi_utility.sp_set_partition            TO obi_workflow;
--Old
GRANT EXECUTE ON obi_utility.get_months_list_fn          TO obi_workflow;
GRANT EXECUTE ON obi_utility.get_partition_list_fn       TO obi_workflow;
GRANT EXECUTE ON obi_utility.drop_partition_sp           TO obi_workflow;
GRANT EXECUTE ON obi_utility.truncate_partition_sp       TO obi_workflow;
GRANT EXECUTE ON obi_utility.purge_partitioned_tables_sp TO obi_workflow;

--obi_utility.get_partition_list_fn (TABLE: user_tab_partitions)
GRANT SELECT ANY TABLE                                   TO obi_utility;
--or
GRANT SELECT ON user_tab_partitions                      TO obi_utility;

--PLS-00904: insufficient privilege to access object C##CLOUD$SERVICE.DBMS_CLOUD for Data Loader
GRANT EXECUTE ON DBMS_CLOUD                              TO obi_staging;
GRANT EXECUTE ON DBMS_CLOUD                              TO obi_data;
