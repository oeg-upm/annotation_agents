#!/usr/bin/env python
# verify.py - Verifica todas las dependencias
import pkg_resources
import sys

REQUIREMENTS = {
    'torch': '2.5.1',
    'transformers': '4.52.3',
    'accelerate': '1.7.0',
    'bitsandbytes': '0.43.0',
    'pandas': '2.0.3',
    'numpy': '1.24.4',
    'nltk': '3.9.2',
    'langchain': '0.3.25',
    'ipykernel': '6.29.4',
    'scikit-learn': '1.2.2',
    'scipy': '1.10.1',
    'sentencepiece': '0.2.0',
    'protobuf': '4.25.3',
}

def check_dependencies():
    print("🔍 VERIFICANDO DEPENDENCIAS")
    print("=" * 50)
    
    all_ok = True
    for pkg, req_version in REQUIREMENTS.items():
        try:
            installed = pkg_resources.get_distribution(pkg).version
            if pkg_resources.parse_version(installed) >= pkg_resources.parse_version(req_version):
                status = "✅ OK"
            else:
                status = "⚠️  VIEJO"
                all_ok = False
            print(f"{pkg:20} | {req_version:10} | {installed:10} | {status}")
        except pkg_resources.DistributionNotFound:
            print(f"{pkg:20} | {req_version:10} | {'-':10} | ❌ FALTANTE")
            all_ok = False
    
    print("=" * 50)
    
    # Verificar CUDA
    try:
        import torch
        if torch.cuda.is_available():
            print(f"\n🎯 CUDA DISPONIBLE: {torch.cuda.get_device_name(0)}")
            print(f"   Versión: {torch.version.cuda}")
        else:
            print("\n⚠️  CUDA NO DISPONIBLE - Ejecutando en CPU")
    except:
        pass
    
    return all_ok

if __name__ == "__main__":
    if check_dependencies():
        print("\n✅ Todas las dependencias están instaladas correctamente")
        sys.exit(0)
    else:
        print("\n❌ Algunas dependencias faltan o están desactualizadas")
        print("   Ejecuta: /opt/conda/bin/conda run -p /home/jovyan/.conda/envs/inesagent_gpu python -m pip install -r requirements.txt")
        sys.exit(1)