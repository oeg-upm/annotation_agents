Diagrama de flujo textual del pipeline completo
1. Corpus original
   ├─ corpus_unannotated.jsonl
   │   → documentos sin anotar (fuente para train/val/test)
   └─ corpus_annotated.json / jsonl
       → corpus gold con anotaciones (spans + offsets)

2. Guías de anotación
   ├─ guidelines.docx
   │   → guía completa original
   └─ guidelines_MVP_defs.docx
       → versión reducida y normalizada:
         - solo P1 (Objeto), P2 (Precio), P4 (Duración), P9 (Resolución)
         - incluye criterios explícitos y ejemplos entre corchetes

3. Extracción de conocimiento desde la guía
   ├─ subtype_quotes.json
   │   → mapeo subtipo → ejemplo literal
   │   → soporte para alineación semántica y control de leakage
   └─ (lectura estructurada de criterios por etiqueta/subtipo)

4. Construcción de memoria (few-shot)
   ├─ memory_selected_AUTO.json
   │   → selección automática inicial (aleatoria)
   │   → validación del pipeline y del formato
   ├─ memory_selected_CURATED.json
   │   → selección curada:
   │     - P1/P2: por criterio y subtipo
   │     - P4/P9: por variedad formal
   │     - posibles casos marcados como fallback
   └─ memory_selected_CURATED_v2.json
       → versión refinada:
         - realineamiento robusto con ejemplos de la guía
         - minimización de fallbacks
         - versión final para prompting

5. Control de leakage
   ├─ blocked_doc_uids_by_memory.json
   │   → doc_uids usados en memoria/few-shot
   │   → excluidos de val/test/prompt_regression
   └─ (las guías no se usan directamente como datos de evaluación)

6. Splits de datos (NB02)
   ├─ train.jsonl
   ├─ val.jsonl
   ├─ test.jsonl
   └─ prompt_regression.jsonl
       → splits limpios, sin documentos vistos en memoria

7. Experimentos de prompting (NB04)
   ├─ Exp 1: sin guías (solo nombres de etiquetas)
   ├─ Exp 2: con criterios + memoria curada
   └─ Exp 3: con criterios + memoria + few-shot ampliado

8. Evaluación (NB05)
   ├─ Exact match
   ├─ Overlap (span-level)
   ├─ Métricas por etiqueta
   └─ Análisis de errores cualitativo
