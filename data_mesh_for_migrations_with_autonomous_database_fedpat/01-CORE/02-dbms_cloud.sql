

  /*--------------------------------------------------------------------------------------------------------------.
  |                                               [CORE] DBMS_CLOUD                                               |
  |---------------------------------------------------------------------------------------------------------------|
  | PROJECT       : DATA FRAMEWORK (Oracle) By Autonomous Database                                                |
  | LAYER         : STAGING, WORKFLOW, MAPPING, UTILITY, DATASET                                                  |
  | MODULE        : DBMS_CLOUD                                                                                    |
  | DESCRIPTION   : Credenciales para conectarnos a un Bucket en OCI desde Autnomous Database                     |
  |---------------------------------------------------------------------------------------------------------------|
  |    .----------------------.      .----------------------.      .----------------------.                       |
  |    | DATA-LAYER: STAGING  |------| DATA-LAYER: WORKFLOW |------| DATA-LAYER: DATASET  |                       |
  |    `----------------------´      `----------------------´      `----------------------´                       |
  |                                              |                                                                |
  |                                  .----------------------.      .-------Optional-------.                       |
  |                                  | DATA-LAYER: MAPPING  |      | DATA-LAYER: UTILITY  |                       |
  |                                  `----------------------´      `----------------------´                       |
  |------------.--------------.------------------------------------------------------------.----------------------|
  | DATA-LAYER | SCHEMA NAME  | USERNAME SCHEMA                                            | PASSWORD             |
  |---------------------------|------------------------------------------------------------|----------------------|
  | STAGING    | OBI_STAGING  | oracleidentitycloudservice/joel.ganggini@oracle.com        | a:sdMVACop{7oVd]JZM5 |
  |---------------------------|------------------------------------------------------------|----------------------|
  | WORKFLOW   | OBI_WORKFLOW | oracleidentitycloudservice/joel.ganggini@oracle.com        | a:sdMVACop{7oVd]JZM5 |
  |------------|--------------|------------------------------------------------------------|----------------------|
  | MAPPING    | OBI_MAPPING  | oracleidentitycloudservice/joel.ganggini@oracle.com        | a:sdMVACop{7oVd]JZM5 |
  |------------|--------------|------------------------------------------------------------|----------------------|
  | UTILITY    | OBI_UTILITY  | oracleidentitycloudservice/joel.ganggini@oracle.com        | a:sdMVACop{7oVd]JZM5 |
  |------------|--------------|------------------------------------------------------------|----------------------|
  | DATASET    | OBI_DATA     | oracleidentitycloudservice/joel.ganggini@oracle.com        | a:sdMVACop{7oVd]JZM5 |
  `--------------------------------------------------------------------------------------------------------------*/

DECLARE
    -- Parameter: DATA-LAYER
    par_data_layer          VARCHAR2(30)    := 'STAGING';
    par_schema_name         VARCHAR2(30)    := 'OBI_STAGING';
    -- Parameter: OCI >> Identity >> Users >> User Details >> Auth Tokens
    par_credential_name     VARCHAR2(30)    := 'OBJ_STORE_CRED';
    par_username            VARCHAR2(100)   := 'oracleidentitycloudservice/joel.ganggini@oracle.com';
    par_password            VARCHAR2(100)   := 'a:sdMVACop{7oVd]JZM5';
    par_drop_credential     BOOLEAN         := FALSE;
    -- Variables
    var_query               VARCHAR2(32767) := NULL;
BEGIN
    -- [1] Drop Credential
    IF par_drop_credential THEN
        DBMS_CREDENTIAL.DROP_CREDENTIAL (
            par_credential_name,
            FALSE
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DBMS_CLOUD] Drop Credential [Succeeded]');
    END IF;

    -- [1] Create Credential
    DBMS_CLOUD.CREATE_CREDENTIAL (
        credential_name     => par_credential_name,
        username            => par_username,
        password            => par_password
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DBMS_CLOUD] Create Credential [Succeeded]');

    -- [3] Grant User
    var_query := 'GRANT DWROLE TO '||par_schema_name;
    EXECUTE IMMEDIATE var_query;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DBMS_CLOUD] Grant DWROLE [Succeeded] '||var_query);
    --REVOKE dwrole FROM <par_schema_name>;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DBMS_CLOUD] [Error] Message: '|| SQLERRM);
END;
/