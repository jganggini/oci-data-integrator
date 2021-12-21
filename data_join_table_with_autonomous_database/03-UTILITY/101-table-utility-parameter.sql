
  /*-------------------------------------------------------------------------------------------.
  |                                     [UTILITY] PARAMETER                                    |
  |--------------------------------------------------------------------------------------------|
  | PROJECT       : DATA FRAMEWORK (Oracle) By Autonomous Database                             |
  | LAYER         : UTILITY                                                                    |
  | MODULE        : PARAMETER                                                                  |
  | DESCRIPTION   : Parametros usados por workflow.                                            |
  |------------------.-------------------------------------------------------------------------|
  | STEP             | DETAIL                                                                  |
  |------------------|-------------------------------------------------------------------------|
  | DROP_TABLE       | Eliminar tabla si existe.                                               |
  | DROP_SEQ         | Eliminar sequiencia si existe.                                          |
  ! CREATE_SEQ       | Crear sequencia.                                                        |
  | CREATE_TABLE     | Crear tabla.                                                            |
  | CREATE_TRIGGER   | Crear trigger.                                                          |
  | INSERT_TABLE     | Insertar Parametros.                                                    |
  `-------------------------------------------------------------------------------------------*/
  
  --[DROP_TABLE]
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE UTL.PARAMETER';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
        RAISE;
      END IF;
  END;
  /
  
  --[DROP_SEQ]
  BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE UTL.PARAMETER_SEQ';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
        RAISE;
      END IF;
  END;
  /

  --[CREATE_SEQ]
  CREATE SEQUENCE UTL.PARAMETER_SEQ
    minvalue 1
    maxvalue 9999999999999999999999999999
    start with 1
    increment by 1
    cache 20;

  --[CREATE_TABLE]
  CREATE TABLE UTL.PARAMETER (
    idparameter             NUMBER(10)            DEFAULT UTL.PARAMETER_SEQ.NEXTVAL NOT NULL,
    wkf_name                VARCHAR2(250)         NOT NULL,
    par_order               NUMBER(10)            DEFAULT 1,
    par_name                VARCHAR2(20)          NOT NULL,
    par_value               VARCHAR2(32000)       NOT NULL,
    par_detail              VARCHAR2(3000)        NOT NULL,
    audit_status            CHAR(1)               DEFAULT 1,
    audit_create_date       TIMESTAMP             DEFAULT SYSDATE NOT NULL,
    audit_activity_date     TIMESTAMP             DEFAULT SYSDATE NOT NULL,
    audit_user              VARCHAR2(500)         NOT NULL,
    audit_wkfrunid          NUMBER(30)            DEFAULT 0 NOT NULL
  );

  --[CREATE_TRIGGER]
  CREATE OR REPLACE TRIGGER UTL.PARAMETER_SEQ_TR
    BEFORE INSERT ON UTL.PARAMETER FOR EACH ROW
    WHEN (NEW.idParameter IS NULL)
  BEGIN
    SELECT UTL.PARAMETER_SEQ.NEXTVAL INTO :NEW.idParameter FROM DUAL;
  END;

  --[INSERT_TABLE]
  ------------------------->------------------------------------>--------------------->--------------------->--------------------->----------------------------->--------------------->--------------------->
  INSERT INTO UTL.PARAMETER (wkf_name,                           par_order,            par_name,             par_value,                                          par_detail,           audit_user)
                     VALUES ('wkf_data_join_table_for_process',  1,                    'p_table_name_1',     'stg1.persons_demo',                                'Process Name',       'joel.ganggini@oracle.com');
  INSERT INTO UTL.PARAMETER (wkf_name,                           par_order,            par_name,             par_value,                                          par_detail,           audit_user)
                     VALUES ('wkf_data_join_table_for_process',  2,                    'p_table_name_2',     'stg2.persons_demo',                                'Process Name',       'joel.ganggini@oracle.com');
  INSERT INTO UTL.PARAMETER (wkf_name,                           par_order,            par_name,             par_value,                                          par_detail,           audit_user)
                     VALUES ('wkf_data_join_table_for_process',  3,                    'p_table_name_3',     'stg3.persons_demo',                                'Process Name',       'joel.ganggini@oracle.com');
  INSERT INTO UTL.PARAMETER (wkf_name,                           par_order,            par_name,             par_value,                                          par_detail,           audit_user)
                     VALUES ('wkf_data_join_table_for_process',  99,                    'p_rows',             'person_id, first_name, last_name, creation_date',  'Process Name',       'joel.ganggini@oracle.com');
  COMMIT;

  