[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <img src="img/img-100.png" alt="Logo" width="80" height="80">

  <h3 align="center">OCI Data Integrator</h3>

  <p align="center">
    Migración de Datos desde Oracle On-Premise a Autnomous Database
    <br />
    <a href="#"><strong>Explore the code »</strong></a>
    <br />
    <br />
    <a href="https://lnkd.in/e9n6iRAR">🎬 View Demo</a>
    ·
    <a href="https://github.com/jganggini/oci/issues">Report Bug</a>
    ·
    <a href="https://github.com/jganggini/oci/issues">Request Feature</a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Contenido</summary>
  <ol>
    <li><a href="#proyecto">Proyecto</a></li>
    <li>
        <a href="#descripción">Descripción</a>
        <ul>
            <li><a href="#parameters">Parameters</a></li>
        </ul>
    </li>
    <li><a href="#contacto">Contacto</a></li>
  </ol>
</details>

<!-- Proyecto -->
## Proyecto

Un gran reto para muchas empresas es poder migrar sus datos a la nube de una forma rápida y segura, con esta necesidad OCI Data Integrator es clave ya que es un servicio fácil y rápido de usar.

El siguiente flujo es un ejemplo que refleja la necesidad de procesas datos en una Base de Datos On-Premise (preparar los datos) antes de ser migrados ya que hay lógica de negocio que no se puede replicar como otras tablas o vistas que si se migrarían con cargas incrementales.

Los administradores, los ingenieros de datos, los desarrolladores de ETL y los operadores se encuentran entre los diferentes tipos de profesionales de datos que utilizan Oracle Cloud Infrastructure Data Integration.

El siguiente diagrama ilustra esta arquitectura de referencia:

<p align="center">
    <img src="img/img-101.png" alt="Componentes" width="1000">
</p>

<!-- Parameters -->
## Parameters

*   `PASO 01` — [01-CORE/01-data-layer.sql](01-CORE/01-data-layer.sql) — Parametros para la creación de capas para el tratamiento de datos.

    ```sql
    DECLARE
      -- Parameter
      par_data_layer          VARCHAR2(30)    := 'WORKFLOW';
      par_schema_name         VARCHAR2(30)    := 'OBI_WORKFLOW';
      par_schema_password     VARCHAR2(15)    := 'njPG[{B496U>';
      par_shema_drop          BOOLEAN         := FALSE;
      -- Variables
      var_query               VARCHAR2(32767) := NULL;
    BEGIN
    ```
    
    ```sql
    DECLARE
      -- Parameter
      par_data_layer          VARCHAR2(30)    := 'UTILITY';
      par_schema_name         VARCHAR2(30)    := 'OBI_UTILITY';
      par_schema_password     VARCHAR2(15)    := 'zU4Z+*n{uI[x';
      par_shema_drop          BOOLEAN         := FALSE;
      -- Variables
      var_query               VARCHAR2(32767) := NULL;
    BEGIN
    ```
*   `PASO 02` — [01-CORE/02-dbms_cloud.sql](01-CORE/02-dbms_cloud.sql) — Credenciales para conectarnos a un Bucket en OCI desde Autnomous Database.
    
    ```sql
    DECLARE
      -- ParameterDATA-LAYER
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
    ```
    
    ```sql
    DECLARE
      -- Parameter: DATA-LAYER
      par_data_layer          VARCHAR2(30)    := 'DATASET';
      par_schema_name         VARCHAR2(30)    := 'OBI_DATA';
      -- Parameter: OCI >> Identity >> Users >> User Details >> Auth Tokens
      par_credential_name     VARCHAR2(30)    := 'OBJ_STORE_CRED';
      par_username            VARCHAR2(100)   := 'oracleidentitycloudservice/joel.ganggini@oracle.com';
      par_password            VARCHAR2(100)   := 'a:sdMVACop{7oVd]JZM5';
      par_drop_credential     BOOLEAN         := FALSE;
      -- Variables
      var_query               VARCHAR2(32767) := NULL;
    BEGIN
    ```

*   `PASO 03` — Procedimiento y Funciones.

    1. [obi_utility.sp_get_date.sql](02-UTILITY/900-procedure-utility.sp_get_date.sql) (New)

    2. [obi_utility.sp_get_date_d11_m1.sql](02-UTILITY/901-procedure-utility.sp_get_date_d11_m1.sql) (New)
    
    3. [obi_utility.sp_set_partition.sql](02-UTILITY/902-procedure-utility.sp_set_partition.sql) (New)

    4. [obi_utility.partition_date_row_type.sql](02-UTILITY/903-type-utility.partition_date_row_type.sql) (Old)
    
    5. [obi_utility.get_months_list_fn.sql](02-UTILITY/904-function-utility.get_months_list_fn.sql) (Old)

    5. [obi_utility.get_partition_list_fn.sql](02-UTILITY/905-function-utility.get_partition_list_fn.sql) (Old)
    
    6. [obi_utility.drop_partition_sp.sql](02-UTILITY/906-procedure-utility.drop_partition_sp.sql) (Old)
    
    7. [obi_utility.truncate_partition_sp.sql](02-UTILITY/907-procedure-utility.truncate_partition_sp.sql) (Old)
    
    8. [obi_utility.purge_partitioned_tables_sp.sql](02-UTILITY/908-procedure-utility.purge_partitioned_tables_sp.sql) (Old)
    
    9. [obi_utility.purge_partitioned_tables_sp.sql](02-UTILITY/908-procedure-utility.purge_partitioned_tables_sp.sql) (Old)

*   `PASO 04` — [02-UTILITY/999-grant-utility-to-obi-workflow.sql](02-UTILITY/999-grant-utility-to-obi-workflow.sql) — Permisos para ejecutar utilitarios desde `obi_workflow` y permisos para Data Loader de OCI-DI.
    ```sql
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
    ```

*   `DATA FRAMEWORK`: Para mayor detalle

    <p align="left">
      <a href="https://youtu.be/KtZ0Nuiz4zA">
        <img src="img/img-116.png" width="800">
      </a>
    </p>
 
<!-- Contacto -->
## Contacto

Joel Ganggini García - [@jganggini](https://www.linkedin.com/in/jganggini/) - jganggini@gmail.com

Project Link: [https://github.com/jganggini/oci](https://github.com/jganggini/oci)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/jganggini/oci/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jganggini/