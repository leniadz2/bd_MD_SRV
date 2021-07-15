SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [bds].[sp_srv_tablon] @prceso NVARCHAR(50), @objtnm NVARCHAR(50), @strgFT NVARCHAR(14), @s_fld1 NVARCHAR(50), @s_fld2 NVARCHAR(14), @strgTim NVARCHAR(6)
AS
/***************************************************************************************************
Procedure:          bds.sp_srv_tablon
Create Date:        20210601
Author:             dÁlvarez
Description:        carga la bds
Call by:            bds.sp_srv
Affected table(s):  bds.SRV_TABLON
                    ods.SRV_TABLON_regNews
Used By:            BI
Parameter(s):       none
Log:                ctl.CONTROL
                    **hora fin de proceso bds   -> campo S_FLD5
Prerequisites:      [ods].[sp_srv_carga]
****************************************************************************************************
SUMMARY OF CHANGES
Date(YYYYMMDD)      Author              Comments
------------------- ------------------- ------------------------------------------------------------
20210601            dÁlvarez            creación
20210617            dÁlvarez            se agrega RUC y CE
20210713            dÁlvarez            MD_SRV

***************************************************************************************************/

TRUNCATE TABLE ods.SRV_TABLON_regNews;

--/* lo no cargado anteriormente (los nuevos registros) */
INSERT INTO ods.SRV_TABLON_regNews
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
  FROM ods.SRV_TABLON st INNER JOIN ods.SRV_TABLON_dlt_excptDE stde
    ON st.ID = stde.ID AND st.ORDENITEM = stde.ORDENITEM;

INSERT INTO bds.SRV_TABLON
SELECT * FROM ods.SRV_TABLON_regNews;

  SET @strgTim = REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '');

  UPDATE ctl.CONTROL
    SET S_FLD5 = @strgTim
  WHERE PRCESO = @prceso
    AND OBJTNM = @objtnm
    AND FECHOR = @strgFT
    AND S_FLD1 = @s_fld1;

GO