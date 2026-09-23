# 1. Usamos una versión de Python ligera como sistema base
FROM python:3.11-slim

# 2. Creamos una carpeta llamada /app dentro del contenedor
WORKDIR /app

# 3. Copiamos nuestro archivo de dependencias a esa carpeta
COPY requirements.txt .

# 4. Instalamos las librerías dentro del contenedor
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiamos el resto de nuestro código (main.py)
COPY . .

# 6. Le decimos al contenedor que va a usar el puerto 8000
EXPOSE 8000

# 7. El comando que se ejecutará cuando la caja se encienda
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]