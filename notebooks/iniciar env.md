## Cuando reinicias el server, la shell nueva no tiene inicializado conda
No uses conda init (en hubs a veces no funciona bien). Usa siempre este patrón (Eso siempre funciona, sin necesidad de reiniciar shells ni conda init):

    source /opt/conda/etc/profile.d/conda.sh
    conda activate /home/jovyan/.conda/envs/inesagent_gpu


Registrar kernel (persistente) SIN romperse

Una vez activado:

    conda activate inesagent_gpu
    python -m pip install ipykernel
    python -m ipykernel install --user --name inesagent_gpu --display-name "Python (inesagent_gpu)"

**Esto devuelve: `Installed kernelspec inesagent_gpu in /home/jovyan/.local/share/jupyter/kernels/inesagent_gpu`**

Y verifica que el kernelspec apunta al python correcto:

    cat /home/jovyan/.local/share/jupyter/kernels/inesagent_gpu/kernel.json

Debe contener algo como:

    /home/jovyan/.conda/envs/inesagent_gpu/bin/python


## Por qué “se te borra todo” al hacer Stop my server

Porque estabas instalando envs en /opt/conda/envs/... (efímero).
Ahora lo haremos en /home/jovyan/.conda/envs/... (persistente).
El cache en /opt/conda/pkgs puede limpiarse y no pasa nada: el env queda

## Checklist rápido (para confirmar que ya quedó fijo)

Ejecuta estos 3 comandos (tras recrear):

    ls -la /home/jovyan/.conda/envs/inesagent_gpu/bin/python
    source /opt/conda/etc/profile.d/conda.sh
    conda info --envs

Si el python existe en HOME y el env aparece ahí → listo.

## La regla de oro en tu setup:

✅ Para instalar cosas en el env, siempre así:

    /opt/conda/bin/conda run -p /home/jovyan/.conda/envs/inesagent_gpu python -m pip install <paquete>

y evita:

    pip install ...

a secas (porque puede usar el pip equivocado y escribir en ~/.local o en system).

**Seguir instalando SIEMPRE con conda run -p ENV python -m pip ….**

## 03/02/2026

Recomendación para que no vuelva a pasar

En tu README del proyecto deja estos tres comandos como “reset rápido”:

    source /opt/conda/etc/profile.d/conda.sh
    conda activate /home/jovyan/.conda/envs/inesagent_gpu
    python -m ipykernel install --user --name inesagent_gpu --display-name "inesagent_gpu (NFS /home/jovyan)"


Y dentro del notebook, siempre verifica una vez:

    import sys
    sys.executable


Debe devolver /home/jovyan/.conda/envs/inesagent_gpu/bin/python.

1) Situación actual (ya estable y correcta)

Ahora mismo tienes:

✅ Entorno conda real y persistente
/home/jovyan/.conda/envs/inesagent_gpu
✅ Kernel Jupyter correctamente registrado
inesagent_gpu (NFS /home/jovyan)
✅ Jupyter ve el kernel y lo lista
(jupyter kernelspec list lo confirma)
✅ Disco persistente
/home/jovyan está en NFS → no se borra

7) Recomendación final (muy importante para tu proyecto)

Para el resto del proyecto NO vuelvas a crear venvs “rápidos”, tu estándar a partir de ahora es:

    conda activate /home/jovyan/.conda/envs/inesagent_gpu

y todo: notebooks, scripts, experimentos, instalaciones, van ahí.

Si algún día necesitas otro entorno (p. ej. pruebas), lo creas también en /home/jovyan/.conda/envs y con kernel propio.

## Reinstalar el kernelspec (si el menú sigue en “No kernel”)

Si tras lo anterior Jupyter sigue sin listar bien el kernel, lo regeneramos limpio:

    source /opt/conda/etc/profile.d/conda.sh
    conda activate /home/jovyan/.conda/envs/inesagent_gpu

    jupyter kernelspec uninstall -f inesagent_gpu || true
    python -m ipykernel install --user --name inesagent_gpu --display-name "inesagent_gpu (NFS /home/jovyan)"


