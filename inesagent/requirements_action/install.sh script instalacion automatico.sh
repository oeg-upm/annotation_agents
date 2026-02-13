#!/bin/bash
# install.sh - Instalación automática completa
set -e

echo "🚀 INSTALADOR AUTOMÁTICO LLAMA 3"
echo "================================="

ENV_PATH="/home/jovyan/.conda/envs/inesagent_gpu"
CONDA_EXE="/opt/conda/bin/conda"
REQ_FILE="requirements.txt"

# 1. Verificar conda
if [ ! -f "$CONDA_EXE" ]; then
    echo "❌ Conda no encontrado en $CONDA_EXE"
    exit 1
fi

# 2. Verificar/Crear entorno
if [ ! -d "$ENV_PATH" ]; then
    echo "📦 Creando entorno en $ENV_PATH"
    $CONDA_EXE create -p $ENV_PATH python=3.11 -y
fi

# 3. Instalar dependencias
echo "📥 Instalando desde $REQ_FILE"
if [ -f "$REQ_FILE" ]; then
    $CONDA_EXE run -p $ENV_PATH python -m pip install -r $REQ_FILE
else
    echo "⚠️  $REQ_FILE no encontrado, instalando paquetes básicos..."
    $CONDA_EXE run -p $ENV_PATH python -m pip install \
        torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 \
        --index-url https://download.pytorch.org/whl/cu121
    $CONDA_EXE run -p $ENV_PATH python -m pip install \
        bitsandbytes==0.43.4 accelerate==1.7.0 transformers==4.52.3 \
        pandas==2.0.3 numpy==1.24.4 nltk==3.9.2 ipykernel==6.29.4
fi

# 4. Registrar kernel Jupyter
echo "🔧 Registrando kernel Jupyter..."
$CONDA_EXE run -p $ENV_PATH python -m ipykernel install \
    --user --name="inesagent_gpu" --display-name="Llama 3 GPU"

# 5. Descargar datos NLTK
echo "📚 Descargando datos NLTK..."
$CONDA_EXE run -p $ENV_PATH python -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab')"

echo ""
echo "✅ INSTALACIÓN COMPLETADA"
echo "=========================="
echo "Entorno: $ENV_PATH"
echo "Kernel: 'Llama 3 GPU' en Jupyter"
echo ""
echo "📋 Para verificar:"
echo "   conda activate $ENV_PATH"
echo "   python -c \"import torch; print(f'PyTorch: {torch.__version__}')\""