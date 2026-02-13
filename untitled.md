## Para evitar que el kernel vuelva a “romperse” si el server se reinicia

En JupyterHub, es normal que el server se recicle. Para hacerlo reproducible, crea un script:

**En Terminal:**

cat > ~/bootstrap_inesagent_gpu.sh <<'EOF'
source /opt/conda/etc/profile.d/conda.sh
conda create -n inesagent_gpu python=3.11 -y || true
conda activate inesagent_gpu
conda install -y pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
python -m pip install -U --no-cache-dir transformers==4.45.2 accelerate "huggingface_hub>=0.34,<1.0" bitsandbytes sentencepiece safetensors requests tqdm pydantic python-docx ipykernel
python -m ipykernel install --user --name inesagent_gpu --display-name "Python (inesagent_gpu)"
EOF
chmod +x ~/bootstrap_inesagent_gpu.sh


**Así, si reinicia el server, ejecutas en bash:**

~/bootstrap_inesagent_gpu.sh


y listo.
