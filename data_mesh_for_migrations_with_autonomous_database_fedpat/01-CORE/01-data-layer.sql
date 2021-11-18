
  /*-------------------------------------------------------------------------------------------.
  |                                    [CORE] DATA-LAYER                                       |
  |--------------------------------------------------------------------------------------------|
  | PROJECT       : DATA FRAMEWORK (Oracle) By Autonomous Database                             |
  | LAYER         : STAGING, WORKFLOW, MAPPING, UTILITY, DATASET                               |
  | MODULE        : DATA-LAYER                                                                 |
  | DESCRIPTION   : Esquemas de trabajo para el Data Framework                                 |
  |--------------------------------------------------------------------------------------------|
  |    .----------------------.      .----------------------.      .----------------------.    |
  |    | DATA-LAYER: STAGING  |------| DATA-LAYER: WORKFLOW |------| DATA-LAYER: DATASET  |    |
  |    `----------------------´      `----------------------´      `----------------------´    |
  |                                              |                                             |
  |                                  .----------------------.      .-------Optional-------.    |
  |                                  | DATA-LAYER: MAPPING  |      | DATA-LAYER: UTILITY  |    |
  |                                  `----------------------´      `----------------------´    |
  |------------------------------.------------------------------.------------------------------|
  | DATA-LAYER                   | SCHEMA NAME                  | SCHEMA PASSWORD              |
  |------------------------------|------------------------------|------------------------------|
  | STAGING                      | OBI_STAGING                  | fLkq,756z5{i                 |
  |------------------------------|------------------------------|------------------------------|
  | WORKFLOW                     | OBI_WORKFLOW                 | njPG[{B496U>                 |
  |------------------------------|------------------------------|------------------------------|
  | MAPPING                      | OBI_MAPPING                  | Hjt3&|`\3PnW                 |
  |------------------------------|------------------------------|------------------------------|
  | UTILITY                      | OBI_UTILITY                  | zU4Z+*n{uI[x                 |
  |------------------------------|------------------------------|------------------------------|
  | DATASET                      | OBI_DATA                     | 30VCHeZV}z!K                 |
  `-------------------------------------------------------------------------------------------*/

DECLARE
    -- Parameter
    par_data_layer          VARCHAR2(30)    := 'WORKFLOW';
    par_schema_name         VARCHAR2(30)    := 'OBI_WORKFLOW';
    par_schema_password     VARCHAR2(15)    := 'njPG[{B496U>';
    par_shema_drop          BOOLEAN         := FALSE;
    -- Variables
    var_query               VARCHAR2(32767) := NULL;
BEGIN
    -- [1] Drop User
    IF par_shema_drop THEN
        var_query := 'DROP USER '||par_schema_name||' CASCADE';
        EXECUTE IMMEDIATE var_query;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DATA-LAYER] Drop User [Succeeded]');
    END IF;

    -- [2] Create User
    var_query := 'CREATE USER '||par_schema_name||' IDENTIFIED BY "'||par_schema_password||'"';
    EXECUTE IMMEDIATE var_query;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DATA-LAYER] Create User [Succeeded]');

    -- [3] Grant User
    IF (par_data_layer = 'STAGING') THEN
        var_query := 'GRANT CREATE SESSION, ALTER SESSION, UNLIMITED TABLESPACE TO '||par_schema_name;
    ELSIF (par_data_layer = 'WORKFLOW') THEN
        var_query := 'GRANT CREATE SESSION, ALTER SESSION, CREATE VIEW, CREATE ANY PROCEDURE, SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, CREATE ANY TYPE, UNLIMITED TABLESPACE TO '||par_schema_name;
    ELSIF (par_data_layer = 'MAPPING') THEN
        var_query := 'GRANT CREATE SESSION, ALTER SESSION, UNLIMITED TABLESPACE TO '||par_schema_name;
    ELSIF (par_data_layer = 'UTILITY') THEN
        var_query := 'GRANT CREATE SESSION, ALTER SESSION, UNLIMITED TABLESPACE TO '||par_schema_name;
    ELSIF (par_data_layer = 'DATASET') THEN
        var_query := 'GRANT CREATE SESSION, ALTER SESSION, UNLIMITED TABLESPACE TO '||par_schema_name;
    END IF;
    EXECUTE IMMEDIATE var_query;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DATA-LAYER] Grant User [Succeeded] '||var_query);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MM:SS')||'] [CORE].[DATA-LAYER] [Error] Message: '|| SQLERRM);
END;
/