# Observaciones y Limitaciones del Dataset

## 1. Despachos sin finalizar (No resueltos)
- **Ubicación**: Página 3 del dashboard (Gestión - Líderes) - NO VISIBLE
- **Descripción**: Contiene ~53 despachos sin FECHA_RES (aún abiertos teóricamente)
- **Impacto**: Acumulan 800+ días en DG, lo que no refleja la realidad operativa
- **Causa**: El dataset se congeló en octubre 2023, el proyecto quedo en pausa, y luego se migro hacia una nueva plataforma.

## 2. Colaboradores NULL
- **Ubicación**: Tablas de Performance y Gestión (Página 4)
- **Descripción**: Algunos ADECIR tienen COLABORADOR = "null"
- **Impacto**: Distorsiona métricas por colaborador, ~487 despachos sin asignar
- **Causa**: Datos incompletos en el export del CRM
- **Recomendación**: Investigar si es un campo obligatorio que debería tener valor
