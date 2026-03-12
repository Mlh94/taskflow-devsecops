# Image obligatoire
FROM python:3.11-slim-bookworm

# Optimisation Python : pas de fichiers .pyc et logs synchrones
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Sécurité : Création d'un utilisateur non-root (taskflowuser)
RUN useradd -m -r taskflowuser

WORKDIR /app

# Optimisation du cache : Installation des dépendances avant la copie du code
COPY --chown=taskflowuser:taskflowuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du code source avec permissions correctes
COPY --chown=taskflowuser:taskflowuser . .

# Passage sur l'utilisateur restreint
USER taskflowuser

EXPOSE 5000

# Lancement via Gunicorn avec 2 workers (Meilleure pratique PRO)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
