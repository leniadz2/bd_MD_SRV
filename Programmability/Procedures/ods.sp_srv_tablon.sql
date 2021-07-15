SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[sp_srv_tablon] @prceso NVARCHAR(50), @objtnm NVARCHAR(50), @strgFT NVARCHAR(14), @s_fld1 NVARCHAR(50), @s_fld2 NVARCHAR(14), @strgTim NVARCHAR(6)
AS
/***************************************************************************************************
Procedure:          ods.sp_srv_carga
Create Date:        20210524
Author:             dÁlvarez
Description:        -carga la ods del SRV
                    -mantiene la historia de las cargas
                     -FHCARGA: fecha de carga
                     -ORCARGA: origen de carga (Azure/archivoXlsCsv)
Call by:            bds.sp_srv
Affected table(s):  ods.SRV_TABLON
                    ods.H_SRV_TABLON
                    ods.SRV_TABLON_tmp
                    ods.SRV_TABLON_dlt_excptIZ
                    ods.SRV_TABLON_dlt_intrsct
                    ods.SRV_TABLON_dlt_excptDE
Used By:            BI
Parameter(s):       
                    @prceso  -> 'CARGATABLA'
                    @objtnm  -> nombre de la tabla
                    @strgFT  -> horafecha ejecucion proceso YYYYMMDDHHMISS
                    @s_fld1  -> 'azure'/'excel'
                    @s_fld2  -> NVARCHAR nulo
                             -> maxima FECHOR en la tabla control
                    @strgTim -> hora ejecucion proceso HHMISS
Log:                ctl.CONTROL
                    **hora fin de proceso ODS / hist tablon -> campo S_FLD7
                    **hora fin de proceso deltas / hist dlt -> campo S_FLD6
Prerequisites:      [stg].[sp_srv_carga*]
****************************************************************************************************
SUMMARY OF CHANGES
Date(YYYYMMDD)      Author              Comments
------------------- ------------------- ------------------------------------------------------------
20210524            dÁlvarez            creación
20210617            dÁlvarez            lógica "-"
20210713            dÁlvarez            MD_SRV

***************************************************************************************************/

  SET DATEFIRST 1;

  TRUNCATE TABLE ods.SRV_TABLON;

  DROP INDEX ods.SRV_TABLON.IX1_SRV_TABLON;

  INSERT INTO ods.SRV_TABLON
  SELECT IIF(ID                    ='-',NULL,IIF(ID                     ='',NULL,ID                     ))
        ,IIF(NOMBRE                ='-',NULL,IIF(NOMBRE                 ='',NULL,UPPER(NOMBRE)          ))
        ,IIF(RAZONSOCIAL           ='-',NULL,IIF(RAZONSOCIAL            ='',NULL,UPPER(RAZONSOCIAL)     ))
        ,IIF(NOMBRETIENDA          ='-',NULL,IIF(NOMBRETIENDA           ='',NULL,UPPER(NOMBRETIENDA)    ))
        ,IIF(CODIGOMALL            ='-',NULL,IIF(CODIGOMALL             ='',NULL,RIGHT(CONCAT('00'  ,CODIGOMALL     ),2) ))
        ,IIF(CODIGOTIENDA          ='-',NULL,IIF(CODIGOTIENDA           ='',NULL,RIGHT(CONCAT('0000',CODIGOTIENDA   ),4) ))
        ,IIF(RUCEMISOR             ='-',NULL,IIF(RUCEMISOR              ='',NULL,RUCEMISOR              ))
        ,IIF(IDENTIFICADORTERMINAL ='-',NULL,IIF(IDENTIFICADORTERMINAL  ='',NULL,IDENTIFICADORTERMINAL  ))
        ,IIF(NUMEROTERMINAL        ='-',NULL,IIF(NUMEROTERMINAL         ='',NULL,NUMEROTERMINAL         ))
        ,IIF(SERIE                 ='-',NULL,IIF(SERIE                  ='',NULL,SERIE                  ))
        ,IIF(TIPOTRANSACCION       ='-',NULL,IIF(TIPOTRANSACCION        ='',NULL,RIGHT(CONCAT('00'  ,TIPOTRANSACCION),2) ))
        ,IIF(NUMEROTRANSACCION     ='-',NULL,IIF(NUMEROTRANSACCION      ='',NULL,NUMEROTRANSACCION      ))
        ,IIF(FECHA                 ='-',NULL,IIF(FECHA                  ='',NULL,LEFT(FECHA,10)         ))
        ,IIF(HORA                  ='-',NULL,IIF(HORA                   ='',NULL,HORA                   ))
        ,IIF(CAJERO                ='-',NULL,IIF(CAJERO                 ='',NULL,CAJERO                 ))
        ,IIF(VENDEDOR              ='-',NULL,IIF(VENDEDOR               ='',NULL,VENDEDOR               ))
        ,IIF(DNI                   ='-',NULL,IIF(DNI                    ='',NULL,DNI                    ))
        ,IIF(RUC                   ='-',NULL,IIF(RUC                    ='',NULL,RUC                    ))
        ,IIF(NOMBRECLIENTE         ='-',NULL,IIF(NOMBRECLIENTE          ='',NULL,UPPER(NOMBRECLIENTE)   ))
        ,IIF(DIRECCIONCLIENTE      ='-',NULL,IIF(DIRECCIONCLIENTE       ='',NULL,UPPER(DIRECCIONCLIENTE)))
        ,IIF(BONUS                 ='-',NULL,IIF(BONUS                  ='',NULL,BONUS))
        ,IIF(MONEDA                ='-',NULL,IIF(MONEDA                 ='',NULL,MONEDA                 ))
        ,IIF(MEDIOPAGO             ='-',NULL,IIF(MEDIOPAGO              ='',NULL,MEDIOPAGO              ))
        ,TOTALVALORVENTABRUTA
        ,DESCUENTOSGLOBAL
        ,MONTOTOTALIGV
        ,TOTALVALORVENTANETA
        ,IIF(ORDENITEM             ='-',NULL,IIF(ORDENITEM              ='',NULL,ORDENITEM              ))
        ,CANTIDADUNIDADESITEM
        ,IIF(CODIGOPRODUCTO        ='-',NULL,IIF(CODIGOPRODUCTO         ='',NULL,CODIGOPRODUCTO         ))
        ,IIF(DESCRIPCIONPRODUCTO   ='-',NULL,IIF(DESCRIPCIONPRODUCTO    ='',NULL,UPPER(DESCRIPCIONPRODUCTO)))
        ,PRECIOVENTAUNITARIOITEM
        ,CARGODESCUENTOITEM
        ,PRECIOTOTALITEM
        ,@strgFT
   FROM stg.SRV_TABLON;

  CREATE INDEX IX1_SRV_TABLON ON ods.SRV_TABLON(ID, ORDENITEM);

  INSERT INTO ods.H_SRV_TABLON
  SELECT *, @s_fld1
    FROM ods.SRV_TABLON;

  SET @strgTim = REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '');

  UPDATE ctl.CONTROL
    SET S_FLD7 = @strgTim
  WHERE PRCESO = @prceso
    AND OBJTNM = @objtnm
    AND FECHOR = @strgFT
    AND S_FLD1 = @s_fld1;

/* left join -> ods.SRV_TABLON_dlt_excptIZ
   lo cargado anteriormente y no en la nueva carga */
TRUNCATE TABLE ods.SRV_TABLON_dlt_excptIZ;

  INSERT INTO ods.SRV_TABLON_dlt_excptIZ
  SELECT t.*
    FROM (SELECT st.ID
                ,st.ORDENITEM
            FROM bds.SRV_TABLON st
          EXCEPT
          SELECT st.ID
                ,st.ORDENITEM
            FROM ods.SRV_TABLON st) AS t;

/* intersect -> ods.SRV_TABLON_dlt_intrsct
   lo que coincide */
TRUNCATE TABLE ods.SRV_TABLON_dlt_intrsct;

  INSERT INTO ods.SRV_TABLON_dlt_intrsct
  SELECT t.*
    FROM (SELECT st.ID
                ,st.ORDENITEM
            FROM ods.SRV_TABLON st
          INTERSECT
          SELECT st.ID
                ,st.ORDENITEM
            FROM bds.SRV_TABLON st
          ) AS t;

/* rigth join -> ods.SRV_TABLON_dlt_excptIZ
   lo no cargado anteriormente (los nuevos registros) */
TRUNCATE TABLE ods.SRV_TABLON_dlt_excptDE;

DROP INDEX ods.SRV_TABLON_dlt_excptDE.IX1_SRV_TABLON_dlt_excptDE;

  INSERT INTO ods.SRV_TABLON_dlt_excptDE
  SELECT t.*
    FROM (SELECT st.ID
                ,st.ORDENITEM
            FROM ods.SRV_TABLON st
          EXCEPT
          SELECT st.ID
                ,st.ORDENITEM
            FROM bds.SRV_TABLON st
          ) AS t;

CREATE INDEX IX1_SRV_TABLON_dlt_excptDE ON ods.SRV_TABLON_dlt_excptDE(ID, ORDENITEM);

INSERT INTO ods.H_SRV_TABLON_dlt
SELECT ID
       ,ORDENITEM
       ,'excptDE'
       ,@strgFT AS FHCARGA
       ,@s_fld1 AS ORCARGA
  FROM ods.SRV_TABLON_dlt_excptIZ
UNION ALL
SELECT ID
       ,ORDENITEM
       ,'intrsct'
       ,@strgFT AS FHCARGA
       ,@s_fld1 AS ORCARGA
  FROM ods.SRV_TABLON_dlt_intrsct
UNION ALL
SELECT ID
       ,ORDENITEM
       ,'excptDE'
       ,@strgFT AS FHCARGA
       ,@s_fld1 AS ORCARGA
  FROM ods.SRV_TABLON_dlt_excptDE;

  SET @strgTim = REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '');

  UPDATE ctl.CONTROL
    SET S_FLD6 = @strgTim
  WHERE PRCESO = @prceso
    AND OBJTNM = @objtnm
    AND FECHOR = @strgFT
    AND S_FLD1 = @s_fld1;

GO