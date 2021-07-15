SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ctl].[sp_reproceso_srv_tablon] @strgFT NVARCHAR(14)
AS
  /***************************************************************************************************
  reproceso
  ****************************************************************************************************
  SUMMARY OF CHANGES
  Date(YYYYMMDD)      Author              Comments
  ------------------- ------------------- ------------------------------------------------------------

  
  ***************************************************************************************************/

--ods.sp_srv_carga

TRUNCATE TABLE stg.SRV_TABLON;

INSERT INTO stg.SRV_TABLON
  SELECT ID
        ,NOMBRE
        ,RAZONSOCIAL
        ,NOMBRETIENDA
        ,CODIGOMALL
        ,CODIGOTIENDA
        ,RUCEMISOR
        ,IDENTIFICADORTERMINAL
        ,NUMEROTERMINAL
        ,SERIE
        ,TIPOTRANSACCION
        ,NUMEROTRANSACCION
        ,FECHA
        ,HORA
        ,CAJERO
        ,VENDEDOR
        ,DNI
        ,RUC
        ,NOMBRECLIENTE
        ,DIRECCIONCLIENTE
        ,BONUS
        ,MONEDA
        ,MEDIOPAGO
        ,TOTALVALORVENTABRUTA
        ,DESCUENTOSGLOBAL
        ,MONTOTOTALIGV
        ,TOTALVALORVENTANETA
        ,ORDENITEM
        ,CANTIDADUNIDADESITEM
        ,CODIGOPRODUCTO
        ,DESCRIPCIONPRODUCTO
        ,PRECIOVENTAUNITARIOITEM
        ,CARGODESCUENTOITEM
        ,PRECIOTOTALITEM
  FROM ods.H_SRV_TABLON
  WHERE FHCARGA = @strgFT;

  TRUNCATE TABLE ods.SRV_TABLON;

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

TRUNCATE TABLE ods.SRV_TABLON_tmp;

  INSERT INTO ods.SRV_TABLON_tmp
  SELECT st.*
    FROM bds.SRV_TABLON st;

TRUNCATE TABLE ods.SRV_TABLON_dlt;

  INSERT INTO ods.SRV_TABLON_dlt
  SELECT t.*
    FROM (SELECT st.ID
                ,st.ORDENITEM
            FROM ods.SRV_TABLON_tmp st
          EXCEPT
          SELECT st.ID
                ,st.ORDENITEM
            FROM ods.SRV_TABLON st) AS t;

--bds.sp_srv_tablon

TRUNCATE TABLE bds.SRV_TABLON;

DROP INDEX bds.SRV_TABLON.IX1_SRV_TABLON;

--cargado anteriormente y no en la nueva carga
INSERT INTO bds.SRV_TABLON
SELECT stt.ID
      ,stt.NOMBRE
      ,stt.RAZONSOCIAL
      ,stt.NOMBRETIENDA
      ,stt.CODIGOMALL
      ,stt.CODIGOTIENDA
      ,stt.RUCEMISOR
      ,stt.IDENTIFICADORTERMINAL
      ,stt.NUMEROTERMINAL
      ,stt.SERIE
      ,stt.TIPOTRANSACCION
      ,stt.NUMEROTRANSACCION
      ,stt.FECHA
      ,stt.HORA
      ,stt.CAJERO
      ,stt.VENDEDOR
      ,stt.DNI
      ,stt.RUC
      ,stt.CE
      ,stt.DUIval
      ,stt.NOMBRECLIENTE
      ,stt.DIRECCIONCLIENTE
      ,stt.BONUS
      ,stt.MONEDA
      ,stt.MEDIOPAGO
      ,stt.TOTALVALORVENTABRUTA
      ,stt.DESCUENTOSGLOBAL
      ,stt.MONTOTOTALIGV
      ,stt.TOTALVALORVENTANETA
      ,stt.ORDENITEM
      ,stt.CANTIDADUNIDADESITEM
      ,stt.CODIGOPRODUCTO
      ,stt.DESCRIPCIONPRODUCTO
      ,stt.PRECIOVENTAUNITARIOITEM
      ,stt.CARGODESCUENTOITEM
      ,stt.PRECIOTOTALITEM
      ,stt.FHCARGA
  FROM ods.SRV_TABLON_tmp stt INNER JOIN ods.SRV_TABLON_dlt std
    ON stt.ID = std.ID AND stt.ORDENITEM = std.ORDENITEM;

--nueva carga
INSERT INTO bds.SRV_TABLON
SELECT st.ID
      ,st.NOMBRE
      ,st.RAZONSOCIAL
      ,st.NOMBRETIENDA
      ,st.CODIGOMALL
      ,st.CODIGOTIENDA
      ,st.RUCEMISOR
      ,st.IDENTIFICADORTERMINAL
      ,st.NUMEROTERMINAL
      ,st.SERIE
      ,st.TIPOTRANSACCION
      ,st.NUMEROTRANSACCION
      ,st.FECHA
      ,st.HORA
      ,st.CAJERO
      ,st.VENDEDOR
      ,IIF(LEN(st.DNI)=8,st.DNI,NULL)
      ,IIF(LEN(st.RUC)=11,st.RUC,NULL)
      ,IIF(LEN(st.DNI)=9,st.DNI,IIF(LEN(st.DNI)=10,st.DNI,NULL))
      ,CASE LEN(st.DNI)
         WHEN 8  THEN ods.fn_validaDNI(st.DNI)
         WHEN 9  THEN ods.fn_validaCE(st.DNI)
         WHEN 10 THEN ods.fn_validaCE(st.DNI)
         WHEN 11 THEN ods.fn_validaRUC(st.RUC)
         ELSE NULL END AS DUIval
      ,st.NOMBRECLIENTE
      ,st.DIRECCIONCLIENTE
      ,st.BONUS
      ,st.MONEDA
      ,st.MEDIOPAGO
      ,st.TOTALVALORVENTABRUTA
      ,st.DESCUENTOSGLOBAL
      ,st.MONTOTOTALIGV
      ,st.TOTALVALORVENTANETA
      ,st.ORDENITEM
      ,st.CANTIDADUNIDADESITEM
      ,st.CODIGOPRODUCTO
      ,st.DESCRIPCIONPRODUCTO
      ,st.PRECIOVENTAUNITARIOITEM
      ,st.CARGODESCUENTOITEM
      ,st.PRECIOTOTALITEM
      ,st.FHCARGA
  FROM ods.SRV_TABLON st;

CREATE INDEX IX1_SRV_TABLON
ON bds.SRV_TABLON(DNI);

  --CLIENTE-----------------------------

  TRUNCATE TABLE bds.SRV_CLI;

  INSERT INTO bds.SRV_CLI (DNI, RUC, CE, DUIval, NOMBRECLIENTE, DIRECCIONCLIENTE, BONUS)
  SELECT DISTINCT 
         DNI,
         RUC,
         CE,
         DUIval,
         NOMBRECLIENTE, 
         DIRECCIONCLIENTE, 
         BONUS
    FROM bds.SRV_TABLON st;

GO