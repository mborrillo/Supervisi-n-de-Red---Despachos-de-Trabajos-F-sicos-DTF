```sql
-- Crear tabla base desde el CSV
CREATE OR REPLACE TABLE dtf_raw AS
SELECT *
FROM read_csv_auto('data/dtf_raw.csv', HEADER TRUE);

-- Vista con transformaciones de negocio
CREATE OR REPLACE VIEW dtf_model AS
SELECT
  ADECIR,
  FECHA_ENVIO,
  FECHA_RES,
  COLABORADOR,
  LOCALIDAD,
  Provincia,
  "ESTADO.DESPACHO" AS ESTADO_DESPACHO,
  "Tipo de Movimiento" AS Tipo_de_Movimiento,
  Cliente,
  idCliente,

  -- AOP.RESP (simplificado, puedes completar todos los casos)
  CASE
    WHEN Provincia IN ('BUENOS AIRES','Buenos Aires','Buenos aires',
                       'CAPITAL FEDERAL','Capital Federal','CF',
                       'PILAR','GRAN BUENOS AIRES','GRAN BUENOS AIRES EXTRA AMBA')
      THEN 'AMBA(TEAMTEL)'
    WHEN Provincia IN ('NEUQUEN','CHUBUT','RIO NEGRO','SANTA CRUZ','TIERRA DEL FUEGO')
      THEN 'AOP SUR'
    WHEN Provincia IN ('SALTA','TUCUMAN','CATAMARCA','JUJUY','FORMOSA','SANTIADO DEL ESTERO')
      THEN 'AOP NOA'
    WHEN Provincia IN ('CHACO','ENTRE RIOS','CORRIENTES','MISIONES')
      THEN 'AOP NEA'
    WHEN Provincia IN ('SAN JUAN','LA RIOJA','MENDOZA')
      THEN 'AOP CUYO'
    WHEN Provincia IN ('SAN LUIS','CORDOBA','SANTA FE','LA PAMPA')
      THEN 'AOP CENTRO'
    ELSE NULL
  END AS AOP_RESP,

  -- Días de gestión y finalización
  CASE
    WHEN FECHA_ENVIO IS NOT NULL AND FECHA_RES IS NULL
      THEN datediff('day', FECHA_ENVIO, current_date)
    ELSE NULL
  END AS DIAS_GESTION,

  CASE
    WHEN FECHA_ENVIO IS NOT NULL AND FECHA_RES IS NOT NULL
      THEN datediff('day', FECHA_ENVIO, FECHA_RES)
    ELSE NULL
  END AS DIAS_FINALIZADOS,

  -- TIEMPOS.DG (Solo finalizados)
  CASE
    WHEN FECHA_RES IS NOT NULL AND datediff('day', FECHA_ENVIO, FECHA_RES) <= 4
      THEN 'EN OBJETIVO'
    WHEN FECHA_RES IS NOT NULL AND datediff('day', FECHA_ENVIO, FECHA_RES) > 4
      THEN 'FUERA OBJETIVO'
    ELSE NULL
  END AS TIEMPOS_DG,

  -- TIEMPOS.DP (concepto histórico para abiertos)
  CASE
    WHEN FECHA_RES IS NULL AND datediff('day', FECHA_ENVIO, current_date) < 5
      THEN 'EN OBJETIVO'
    WHEN FECHA_RES IS NULL AND datediff('day', FECHA_ENVIO, current_date) > 4
      THEN 'FUERA OBJETIVO'
    ELSE NULL
  END AS TIEMPOS_DP,

  -- Operacion
  CASE
    WHEN "Tipo de Movimiento" = 'ALTA' THEN 'ALTA'
    WHEN "Tipo de Movimiento" IN ('CBIOVEL','CBIOTEC','CBIOTECVEL',
                                  'CBIOTECDOM','CBIODOM','CBIOSITIO','CBIVELDOM')
      THEN 'CAMBIO VEL/TECNICO'
    WHEN "Tipo de Movimiento" IN ('BAJA PARCIAL','BAJA')
      THEN 'BAJA'
    ELSE 'OTROS'
  END AS Operacion

FROM dtf_raw;
