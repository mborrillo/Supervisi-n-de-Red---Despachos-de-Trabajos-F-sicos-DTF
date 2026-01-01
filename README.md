# Supervisión de Red - Despachos de Trabajos Físicos (DTF)

Proyecto de analítica operacional sobre despachos de trabajos físicos (DTF) en una operación de red, usando un snapshot de datos exportado desde un CRM y visualizado en Looker Studio.

## Objetivo del proyecto

- Medir el cumplimiento del SLA de 4 días en la gestión de DTF finalizados.
- Analizar la productividad de colaboradores y líderes.
- Entender el desempeño por región operativa (AOP), tipo de operación y otros atributos (producto, área responsable, etc.).

> Nota: El dataset es una foto histórica; la sección de “gestión en curso” dejó de tener sentido al dejar de actualizarse, por lo que el foco del proyecto está en despachos finalizados y performance histórica.

## Arquitectura de datos

- Origen: Export .csv desde el CRM a Google Sheets.
- Snapshot: `data/dtf_raw.csv` contiene una foto histórica de los DTF.
- Transformaciones:
  - Implementadas en `sql/model_dtf.sql` (compatible con DuckDB/SQLite).
  - Cálculo de días de gestión y clasificación de SLA.
  - Agrupaciones por región operativa (AOP.RESP) y tipo de operación.
- Visualización:
  - Dashboard en Looker Studio (estructura documentada en `dashboard/diseño_dashboard.md`).
  - Páginas activas: Performance por líderes/colaboradores, SLA por AOP, vistas ejecutivas.

## Dashboard en Looker Studio

Accede al dashboard interactivo aquí:
📊 [Supervisión de Red - DTF - AE](https://lookerstudio.google.com/reporting/06351cd3-79b2-42ec-b394-0b04e2e68107)

**Nota**: El dashboard contiene 4 páginas:
1. **Inicio**: Contexto y objetivos del proyecto.
2. **Tablero General**: Visión ejecutiva de despachos, timeline, mapa geográfico.
3. **Performance - Líderes**: KPIs de SLA (EN OBJETIVO / FUERA OBJETIVO) para despachos finalizados.
4. **Glosario**: Breve detalle con la explicación de los conceptos más importantes.


## Campos principales del dataset

Algunos campos clave de `dtf_raw.csv`:

- `ADECIR`: Identificador del despacho.
- `FECHA_ENVIO`: Fecha de envío del DTF.
- `FECHA_RES`: Fecha de resolución del DTF (si está finalizado).
- `COLABORADOR`: Colaborador que gestiona el DTF (enmascarado en este repo).
- `LOCALIDAD`, `Provincia`, `AOP Responsable`: Información geográfica/organizativa.
- `ESTADO.DESPACHO`: Estado del despacho.
- `Tipo de Movimiento`: Tipo de operación (ALTA, BAJA, cambios varios).
- `Cliente`, `idCliente`: Identificador y nombre comercial (no trazables a personas físicas reales).

Ver el glosario completo en `docs/glosario.md`.

## Métricas y transformaciones

En `sql/model_dtf.sql` se definen:

- `AOP.RESP`: Región operativa derivada de la provincia.
- `DIAS_GESTION`: Diferencia en días entre hoy y `FECHA_ENVIO` (para despachos aún abiertos).
- `DIAS_FINALIZADOS`: Diferencia en días entre `FECHA_RES` y `FECHA_ENVIO` (para despachos finalizados).
- `TIEMPOS_DG`: Clasificación EN OBJETIVO / FUERA OBJETIVO para DTF finalizados (SLA 4 días).
- `TIEMPOS_DP`: Clasificación EN OBJETIVO / FUERA OBJETIVO para DTF abiertos (concepto histórico).
- `Operacion`: Agrupación de tipos de movimiento (ALTA, BAJA, CAMBIO VEL/TECNICO, OTROS).

## Cómo reproducir el modelo con DuckDB

1. Instalar DuckDB: ```bash pip install duckdb

2. Ejecutar el script SQL: duckdb dtf.duckdb -c ".read sql/model_dtf.sql" 

Aqui se crea una vista/tablas modeladas que podrás conectar a tu herramienta de BI, en este caso Looker Studio.

## Estado del dashboard

- **Performance - Líderes / Colaboradores**: productividad, SLA y volumen por persona/equipo.
- **SLA por AOP y dimensiones**: cumplimiento por región operativa, tipo de operación, etc.
- **Vista ejecutiva**: KPIs agregados del periodo.
- **DTF Gestión Líderes**: se mantiene solo como referencia histórica (pérdida de vigencia al no actualizarse el dataset).

Privacidad y anonimización
Colaboradores: se enmascaran con nombres de fantasía, para proteger la privaciadad, pero a su vez manteniendo el enfoque en la productividad real del período.
No se incluye ninguna información sensible de personas físicas.
