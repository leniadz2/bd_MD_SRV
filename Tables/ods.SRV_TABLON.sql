CREATE TABLE [ods].[SRV_TABLON] (
  [ID] [varchar](30) NULL,
  [NOMBRE] [varchar](50) NULL,
  [RAZONSOCIAL] [varchar](50) NULL,
  [NOMBRETIENDA] [varchar](50) NULL,
  [CODIGOMALL] [varchar](2) NULL,
  [CODIGOTIENDA] [varchar](4) NULL,
  [RUCEMISOR] [varchar](11) NULL,
  [IDENTIFICADORTERMINAL] [varchar](10) NULL,
  [NUMEROTERMINAL] [varchar](10) NULL,
  [SERIE] [varchar](10) NULL,
  [TIPOTRANSACCION] [varchar](4) NULL,
  [NUMEROTRANSACCION] [varchar](10) NULL,
  [FECHA] [varchar](20) NULL,
  [HORA] [varchar](20) NULL,
  [CAJERO] [varchar](20) NULL,
  [VENDEDOR] [varchar](20) NULL,
  [DNI] [varchar](11) NULL,
  [RUC] [varchar](11) NULL,
  [NOMBRECLIENTE] [varchar](100) NULL,
  [DIRECCIONCLIENTE] [varchar](200) NULL,
  [BONUS] [varchar](20) NULL,
  [MONEDA] [varchar](10) NULL,
  [MEDIOPAGO] [varchar](10) NULL,
  [TOTALVALORVENTABRUTA] [decimal](18, 2) NULL,
  [DESCUENTOSGLOBAL] [decimal](18, 2) NULL,
  [MONTOTOTALIGV] [decimal](18, 2) NULL,
  [TOTALVALORVENTANETA] [decimal](18, 2) NULL,
  [ORDENITEM] [varchar](20) NULL,
  [CANTIDADUNIDADESITEM] [decimal](18, 2) NULL,
  [CODIGOPRODUCTO] [varchar](50) NULL,
  [DESCRIPCIONPRODUCTO] [varchar](100) NULL,
  [PRECIOVENTAUNITARIOITEM] [decimal](18, 2) NULL,
  [CARGODESCUENTOITEM] [decimal](18, 2) NULL,
  [PRECIOTOTALITEM] [decimal](18, 2) NULL,
  [FHCARGA] [varchar](14) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX1_SRV_TABLON]
  ON [ods].[SRV_TABLON] ([ID], [ORDENITEM])
  ON [PRIMARY]
GO