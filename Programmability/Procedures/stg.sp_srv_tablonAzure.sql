SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [stg].[sp_srv_tablonAzure] @prceso NVARCHAR(50), @objtnm NVARCHAR(50), @strgFT NVARCHAR(14), @s_fld1 NVARCHAR(50), @s_fld2 NVARCHAR(14), @strgTim NVARCHAR(6)
AS
/***************************************************************************************************
Procedure:          [stg].[sp_srv_cargaAzure]
Create Date:        20210520
Author:             dÁlvarez
Description:        carga el reporte cew_data (GVillacorta) de Azure.
Call by:            none
Affected table(s):  [stg].SRV_TABLON
Used By:            BI
Parameter(s):       none
Log:                ctl.CONTROL
Prerequisites:      Azure debe estar encendido (ccordinar con GVillacorta)
                    **NOTA**
                      Previamente se debe cargar en BD_SRV una importación de tabla con el dbForge
                      desde azure
                    **
****************************************************************************************************
SUMMARY OF CHANGES
Date(YYYYMMDD)      Author              Comments
------------------- ------------------- ------------------------------------------------------------
20210520            dÁlvarez            creación

***************************************************************************************************/

  DECLARE @strgTable NVARCHAR(17);
  DECLARE @sqlCommand varchar(5000)

  SELECT @s_fld2 = MAX(FECHOR) FROM ctl.CONTROL WHERE PRCESO = @prceso AND OBJTNM = @objtnm;

  INSERT INTO ctl.CONTROL(PRCESO, OBJTNM, FECHOR, S_FLD1, S_FLD2, S_FLD9)
  VALUES(@prceso,@objtnm,@strgFT,@s_fld1,@s_fld2 ,@strgTim);


  SELECT @strgTable = MAX(TABLE_NAME)
  FROM BD_SRV.INFORMATION_SCHEMA.TABLES
  WHERE TABLE_CATALOG = 'BD_SRV'
  AND TABLE_SCHEMA = 'tmp'
  AND TABLE_NAME LIKE '2%cew_Data';

  --en caso que la tabla tenga la fecha del día (no necesario)
  --SET @strgTable = CONCAT(@strgFec, '_cew_data');
  
  TRUNCATE TABLE stg.SRV_TABLON;

  SET @sqlCommand = 'INSERT INTO stg.SRV_TABLON (
  ID,
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
      cast(cd.ID                     as varchar(30))   as c01
     ,cast(cd.SupPartyName           as varchar(50))   as c02
     ,cast(cd.SupPartyRegName        as varchar(50))   as c03
     ,cast(cd.NombreTienda           as varchar(50))   as c04
     ,cast(cd.CodigoMall             as varchar(2))    as c05
     ,cast(cd.CodigoTienda           as varchar(4))    as c06
     ,cast(cd.RucEmisor              as varchar(11))   as c07
     ,cast(cd.IdentificadorTerminal  as varchar(10))   as c08
     ,cast(cd.NumeroTerminal         as varchar(10))   as c09
     ,cast(cd.Serie                  as varchar(10))   as c10
     ,cast(cd.TipoTransaccion        as varchar(4))    as c11
     ,cast(cd.NumeroTransaccion      as varchar(10))   as c12
     ,cast(cd.Fecha                  as varchar(20))   as c13
     ,cast(cd.Hora                   as varchar(20))   as c14
     ,cast(cd.Cajero                 as varchar(20))   as c15
     ,cast(cd.Vendedor               as varchar(20))   as c16
     ,cast(cd.DNI                    as varchar(11))   as c17
     ,cast(cd.RUC                    as varchar(11))   as c18
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.CusPartyRegName as varchar(100)), ''&amp;'',''&''), CHAR(13),'';''), CHAR(10),'';''), CHAR(9),'';''), ''|'','' ''), ''"'','''') as c19
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.Direccion as varchar(200)), CHAR(13),'';''), CHAR(10),'';''), CHAR(9),'';''), ''|'','' ''), ''"'','''') as c20
     ,NULL                                             as c21
     ,cast(cd.Moneda                  as varchar(10))  as c22
     ,cast(cd.MedioPago               as varchar(10))  as c23
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.TotalValorVentaBruta))         as c24
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.CargosDescuentosGlobal))       as c25
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.MontoTotalIgv))                as c26
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.TotalValorVentaNeta))          as c27
     ,cast(cd.Orden                   as varchar(20))  as c28
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.CantidadUnidadesItem))         as c29
     ,cast(cd.CodigoProducto          as varchar(50))  as c30
     ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast(cd.DescripcionProducto as varchar(100)), CHAR(13),'';''), CHAR(10),'';''), CHAR(9),'';''), ''|'','' ''), ''"'','''') as c31
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.PrecioVentaUnitarioItem))      as c32
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.CargoDescuentoItem))           as c33
     ,CONVERT(DECIMAL(18,2),CONVERT(float,cd.PrecioTotalItem))              as c34
    FROM [BD_SRV].tmp.['+@strgTable+'] cd';

  EXEC (@sqlCommand);
GO