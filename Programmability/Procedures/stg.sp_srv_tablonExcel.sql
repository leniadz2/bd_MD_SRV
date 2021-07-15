SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [stg].[sp_srv_tablonExcel] @prceso NVARCHAR(50), @objtnm NVARCHAR(50), @strgFT NVARCHAR(14), @s_fld1 NVARCHAR(50), @s_fld2 NVARCHAR(14), @strgTim NVARCHAR(6)
AS
/***************************************************************************************************
Procedure:          stg.sp_srv_cargaExcel
Create Date:        20210520
Author:             dÁlvarez
Description:        carga el reporte cew_data (GVillacorta) del CSV
Call by:            bds.sp_srv
Affected table(s):  stg.SRV_TABLON
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
                    **fechahora inicio de proceso STG -> campo FECHOR
                    **hora fin de proceso STG         -> campo S_FLD9
Prerequisites:      usar tarea srv_resultados.dit con dbforge
****************************************************************************************************
SUMMARY OF CHANGES
Date(YYYYMMDD)      Author              Comments
------------------- ------------------- ------------------------------------------------------------
20210520            dÁlvarez            creación
20210713            dÁlvarez            MD_SRV

***************************************************************************************************/

  DECLARE @i_fld1 INT;

  SELECT @s_fld2 = MAX(FECHOR) FROM ctl.CONTROL WHERE PRCESO = @prceso AND OBJTNM = @objtnm;

  INSERT INTO ctl.CONTROL(PRCESO, OBJTNM, FECHOR, S_FLD1, S_FLD2, S_FLD9)
  VALUES(@prceso,@objtnm,@strgFT,@s_fld1,@s_fld2 ,@strgTim);


  TRUNCATE TABLE stg.SRV_TABLON;

  INSERT INTO stg.SRV_TABLON (ID,
                              NOMBRE,
                              RAZONSOCIAL,
                              NOMBRETIENDA,
                              CODIGOMALL,
                              CODIGOTIENDA,
                              RUCEMISOR,
                              IDENTIFICADORTERMINAL,
                              NUMEROTERMINAL,
                              SERIE,
                              TIPOTRANSACCION,
                              NUMEROTRANSACCION,
                              FECHA,
                              HORA,
                              CAJERO,
                              VENDEDOR,
                              DNI,
                              RUC,
                              NOMBRECLIENTE,
                              DIRECCIONCLIENTE,
                              BONUS,
                              MONEDA,
                              MEDIOPAGO,
                              TOTALVALORVENTABRUTA,
                              DESCUENTOSGLOBAL,
                              MONTOTOTALIGV,
                              TOTALVALORVENTANETA,
                              ORDENITEM,
                              CANTIDADUNIDADESITEM,
                              CODIGOPRODUCTO,
                              DESCRIPCIONPRODUCTO,
                              PRECIOVENTAUNITARIOITEM,
                              CARGODESCUENTOITEM,
                              PRECIOTOTALITEM)
    SELECT
      CAST(cd.ID AS VARCHAR(30)) AS c01
     ,CAST(cd.[Nombre] AS VARCHAR(50)) AS c02
     ,CAST(cd.[Razón social] AS VARCHAR(50)) AS c03
     ,CAST(cd.NombreTienda AS VARCHAR(50)) AS c04
     ,CAST(cd.CodigoMall AS VARCHAR(2)) AS c05
     ,CAST(cd.CodigoTienda AS VARCHAR(4)) AS c06
     ,CAST(cd.RucEmisor AS VARCHAR(11)) AS c07
     ,CAST(cd.IdentificadorTerminal AS VARCHAR(10)) AS c08
     ,CAST(cd.NumeroTerminal AS VARCHAR(10)) AS c09
     ,CAST(cd.Serie AS VARCHAR(10)) AS c10
     ,CAST(cd.TipoTransaccion AS VARCHAR(4)) AS c11
     ,CAST(cd.NumeroTransaccion AS VARCHAR(10)) AS c12
     ,CAST(cd.Fecha AS VARCHAR(20)) AS c13
     ,CAST(cd.Hora AS VARCHAR(20)) AS c14
     ,CAST(cd.Cajero AS VARCHAR(20)) AS c15
     ,CAST(cd.Vendedor AS VARCHAR(20)) AS c16
     ,CAST(cd.DNI AS VARCHAR(11)) AS c17
     ,CAST(cd.RUC AS VARCHAR(11)) AS c18
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.[NombreCliente] as varchar(100)), '&amp;','&'), CHAR(13),';'), CHAR(10),';'), CHAR(9),';'), '|',' '), '"','') as c19
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.[DireccionCliente] as varchar(200)), CHAR(13),';'), CHAR(10),';'), CHAR(9),';'), '|',' '), '"','') as c20
     ,cast(cd.[Bonus]                 as varchar(10))  as c21
     ,cast(cd.Moneda                  as varchar(10))  as c22
     ,cast(cd.MedioPago               as varchar(10))  as c23
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.TotalValorVentaBruta))         as c24
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.[DescuentosGlobal]))           as c25
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.MontoTotalIgv))                as c26
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.TotalValorVentaNeta))          as c27
     ,cast(cd.[OrdenItem]             as varchar(20))  as c28
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.CantidadUnidadesItem))         as c29
     ,cast(cd.CodigoProducto          as varchar(50))  as c30
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.DescripcionProducto as varchar(100)), CHAR(13),';'), CHAR(10),';'), CHAR(9),';'), '|',' '), '"','') as c31
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.PrecioVentaUnitarioItem))      as c32
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.CargoDescuentoItem))           as c33
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.PrecioTotalItem))              as c34
    FROM tmp.[srv_resultados$] cd;

  SELECT @i_fld1 = COUNT(*) FROM stg.SRV_TABLON;

  SET @strgTim = REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '');

  UPDATE ctl.CONTROL
    SET S_FLD8 = @strgTim,
        I_FLD1 = @i_fld1
  WHERE PRCESO = @prceso
    AND OBJTNM = @objtnm
    AND FECHOR = @strgFT
    AND S_FLD1 = @s_fld1;

GO