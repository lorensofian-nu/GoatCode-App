# Private Gemini asset pipeline — specification & runner

Este pipeline permite generar e integrar ilustraciones, insignias de logros y personajes utilizando la API oficial de Google Gemini / Imagen manteniendo una estricta frontera de seguridad.

## Límite de seguridad (Security Boundary)

```text
Script local privado (tools/asset_pipeline/generate_asset.js)
  -> Lee GEMINI_API_KEY desde .env local o variables de entorno (ignorado por Git)
  -> Llama a la API oficial de Google Gemini / Imagen
  -> Aplica recorte y transparencia alfa automática
  -> Guarda el archivo validado en assets/generated/ o assets/mascot/
  -> Actualiza automáticamente docs/06-asset-manifest.csv

Flutter Web -> Consume ÚNICAMENTE assets estáticos locales verificados.
```

> [!CAUTION]
> **Nunca expongas tu API Key:** Jamás incluyas la clave en el código Dart, bundles de producción web o commits de Git.

---

## Configuración rápida

Crea un archivo `.env` en la raíz del repositorio (basado en `.env.example`):

```env
GEMINI_API_KEY=tu_clave_de_google_ai_studio
GEMINI_IMAGE_MODEL=imagen-3.0-generate-002
```

---

## Comandos del Pipeline

### 1. Listar presets disponibles y su estado
```bash
node tools/asset_pipeline/generate_asset.js --list
```

### 2. Generar con Gemini API (requiere GEMINI_API_KEY en .env)
```bash
# Generar una insignia de logro
node tools/asset_pipeline/generate_asset.js --preset badge_logic

# Generar la isla 3D del catálogo
node tools/asset_pipeline/generate_asset.js --preset island

# Generar la skin de Cabra Maga
node tools/asset_pipeline/generate_asset.js --preset mascot_wizard
```

### 3. Modo de prueba Mock (Offline, sin costo ni API Key)
```bash
node tools/asset_pipeline/generate_asset.js --preset badge_streak --mock
```

### 4. Generación personalizada mediante prompt libre
```bash
node tools/asset_pipeline/generate_asset.js --prompt "3D cosmic potion bottle with bubbling cyan code liquid" --output "assets/generated/elements/potion.png"
```

