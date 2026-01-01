### Estructura del proyecto.

dtf-supervision-red/
├─ data/
│  ├─ dtf_raw.csv              # Export del Sheet NUEVO.REGISTRO (con colaboradores ya enmascarados)
│  ├─ localidades_norm.csv     # Si usas tablas auxiliares
│  └─ otras_tablas.csv
├─ sql/
│  └─ model_dtf.sql            # Transformaciones (AOP.RESP, tiempos, operación, etc.)
├─ notebooks/                  # Opcional, para exploración
│  └─ exploracion_dtf.ipynb
├─ dashboard/
│  ├─ diseño_dashboard.md      # Explicación de páginas y gráficos
│  └─ capturas/                # Screenshots de Looker Studio
├─ docs/
│  └─ glosario.md              # Definición de métricas y campos
├─ scripts/
│  └─ prepare_data_duckdb.py   # Alternativa en Python (si quieres)
├─ .gitignore
└─ README.md
