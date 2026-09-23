from fastapi import FastAPI
from pydantic import BaseModel
import os

# Inicializamos la API
app = FastAPI(title="Mi Primer Agente SRE, llamado Prometeo")

# Definimos cómo debe llegar la información (Cuerpo de la petición)
class Alerta(BaseModel):
    mensaje_error: str

# Ruta principal de prueba
@app.get("/")
def read_root():
    return {"status": "El agente está vivo y respirando."}

# Ruta donde el agente procesa el error
@app.post("/analizar-alerta")
def analizar_alerta(alerta: Alerta):
    # Aquí es donde conectaremos la API key real más adelante.
    # Por ahora, simularemos que la IA piensa y responde.
    
    simulacion_ia = f"He analizado el error '{alerta.mensaje_error}'. Sugiero revisar los logs del contenedor y reiniciar el pod."
    
    return {
        "agente": "SRE-Prometeo-V1",
        "analisis": simulacion_ia
    }