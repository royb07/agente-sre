import os
import json
from datetime import datetime
import psutil
import boto3
from fastapi import FastAPI

app = FastAPI(title="Agente SRE - Inspector System")

# Configuración de conexión hacia la Nube (MinIO / S3)
S3_ENDPOINT = os.getenv("S3_ENDPOINT", "http://localhost:9005")
AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY", "test")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_KEY", "testpassword")
BUCKET_NAME = os.getenv("BUCKET_NAME", "prometeo-datos-bucket")

def obtener_cliente_s3():
    return boto3.client(
        "s3",
        endpoint_url=S3_ENDPOINT,
        aws_access_key_id=AWS_ACCESS_KEY,
        aws_secret_access_key=AWS_SECRET_KEY,
        region_name="us-east-1"
    )

@app.get("/")
def home():
    return {"status": "ok", "agent": "Prometeo SRE Agent", "version": "2.0"}

@app.post("/ejecutar-diagnostico")
def ejecutar_diagnostico():
    # 1. Recopilar métricas reales del contenedor/sistema
    timestamp = datetime.utcnow().isoformat()
    reporte = {
        "timestamp": timestamp,
        "agente": "prometeo-sre-v2",
        "metricas": {
            "cpu_usage_percent": psutil.cpu_percent(interval=1),
            "memory_usage_percent": psutil.virtual_memory().percent,
            "disk_usage_percent": psutil.disk_usage('/').percent
        },
        "estado": "HEALTHY"
    }
    
    # 2. Guardar el reporte como archivo JSON en el bucket S3
    nombre_archivo = f"reportes/diagnostico_{datetime.now().strftime('%Y%m%m_%H%M%S')}.json"
    s3_client = obtener_cliente_s3()
    
    s3_client.put_object(
        Bucket=BUCKET_NAME,
        Key=nombre_archivo,
        Body=json.dumps(reporte, indent=2),
        ContentType="application/json"
    )
    
    return {
        "mensaje": "Diagnóstico ejecutado y guardado en la nube exitosamente",
        "archivo_guardado": nombre_archivo,
        "datos": reporte
    }