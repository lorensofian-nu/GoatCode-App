/**
 * GoatCode — Decoupled Gemini Asset Generation Pipeline
 *
 * This private CLI script connects to the official Gemini/Imagen image API
 * to generate illustrated learning assets, badges, and mascot variations.
 *
 * Rules:
 * 1. Reads GEMINI_API_KEY from local .env or environment.
 * 2. Never exposes credentials to Flutter Web or git.
 * 3. Supports live generation, mock test generation, and manifest auditing.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function loadEnv() {
  const envPath = path.resolve(__dirname, '../../.env');
  if (fs.existsSync(envPath)) {
    const lines = fs.readFileSync(envPath, 'utf8').split('\n');
    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const idx = trimmed.indexOf('=');
      if (idx !== -1) {
        const key = trimmed.substring(0, idx).trim();
        const val = trimmed.substring(idx + 1).trim().replace(/^["']|["']$/g, '');
        if (!process.env[key]) {
          process.env[key] = val;
        }
      }
    }
  }
}
loadEnv();

const PRESETS = {
  island: {
    name: 'Isla de Curso Catálogo (3D Isometric)',
    promptFile: 'prompts/island.txt',
    output: 'assets/generated/scenes/catalog_island.png',
    manifestId: 'bg_course_island',
    aspectRatio: '1:1',
    transparent: false,
  },
  badge_logic: {
    name: 'Insignia de Lógica de Programación',
    promptFile: 'prompts/badge_logic.txt',
    output: 'assets/generated/badges/badge_logic_starter.png',
    manifestId: 'badge_logic_starter',
    aspectRatio: '1:1',
    transparent: true,
  },
  badge_streak: {
    name: 'Insignia de Racha de Fuego Cósmico',
    promptFile: 'prompts/badge_streak.txt',
    output: 'assets/generated/badges/badge_streak_fire.png',
    manifestId: 'badge_streak_fire',
    aspectRatio: '1:1',
    transparent: true,
  },
  mascot_wizard: {
    name: 'Cabra Maga de Código (Skin nueva)',
    promptFile: 'prompts/mascot_wizard.txt',
    output: 'assets/mascot/goat_wizard.png',
    manifestId: 'mascot_wizard',
    aspectRatio: '1:1',
    transparent: true,
  },
};

function printUsage() {
  console.log(`
==============================================================
   GoatCode — Pipeline Privado de Assets (Gemini API)
==============================================================
Uso:
  node tools/asset_pipeline/generate_asset.js --preset <nombre> [opciones]
  node tools/asset_pipeline/generate_asset.js --prompt "..." --output "..." [opciones]

Presets disponibles:
  --preset island         -> Isla de Curso Catálogo (3D Isometric)
  --preset badge_logic    -> Insignia de Lógica de Programación
  --preset badge_streak   -> Insignia de Racha de Fuego Cósmico
  --preset mascot_wizard  -> Cabra Maga de Código (Skin nueva)

Opciones:
  --mock                  Modo de prueba offline: genera asset ilustrado sin consumir API.
  --list                  Muestra los presets y estado del manifest.
  --model <id>            Modelo de Gemini/Imagen a usar (default: env GEMINI_IMAGE_MODEL o imagen-3.0-generate-002)
  --help                  Muestra esta ayuda.
`);
}

function updateManifest(manifestId, outputPath, modelUsed) {
  const manifestPath = path.resolve(__dirname, '../../docs/06-asset-manifest.csv');
  if (!fs.existsSync(manifestPath)) return;

  const content = fs.readFileSync(manifestPath, 'utf8');
  const lines = content.split('\n');
  const updatedLines = lines.map((line) => {
    if (line.startsWith(manifestId + ',')) {
      const parts = line.split(',');
      if (parts.length >= 14) {
        parts[5] = modelUsed;
        parts[10] = outputPath.replace(/\\/g, '/');
        parts[12] = 'READY';
        parts[13] = `"Generado y validado en pipeline: ${new Date().toISOString().split('T')[0]}"`;
        return parts.join(',');
      }
    }
    return line;
  });

  fs.writeFileSync(manifestPath, updatedLines.join('\n'), 'utf8');
  console.log(`[Manifest] Actualizado docs/06-asset-manifest.csv para ID: ${manifestId}`);
}

async function generateWithGemini(prompt, model, apiKey) {
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:predict?key=${apiKey}`;
  
  const payload = {
    instances: [{ prompt: prompt }],
    parameters: {
      sampleCount: 1,
      aspectRatio: '1:1',
      outputMimeType: 'image/png',
    },
  };

  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Error API (${response.status} ${response.statusText}): ${errorText}`);
  }

  const data = await response.json();
  const base64Bytes = data?.predictions?.[0]?.bytesBase64Encoded;
  if (!base64Bytes) {
    throw new Error('La respuesta de la API no contiene bytesBase64Encoded válidos.');
  }

  return Buffer.from(base64Bytes, 'base64');
}

function generateMockAsset(outputPath, label, transparent) {
  const fullOut = path.resolve(__dirname, '../../', outputPath);
  const dir = path.dirname(fullOut);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  const psScript = `
Add-Type -AssemblyName System.Drawing;
$b = New-Object System.Drawing.Bitmap 512, 512;
$g = [System.Drawing.Graphics]::FromImage($b);
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias;

${transparent ? '$g.Clear([System.Drawing.Color]::Transparent);' : '$g.Clear([System.Drawing.Color]::FromArgb(255, 12, 10, 23));'}

$brushGlow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(180, 138, 79, 255));
$g.FillEllipse($brushGlow, 56, 56, 400, 400);

$brushCore = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 26, 22, 43));
$g.FillEllipse($brushCore, 76, 76, 360, 360);

$penCyan = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0, 229, 255)), 8;
$g.DrawEllipse($penCyan, 90, 90, 332, 332);

$font = New-Object System.Drawing.Font('Arial', 24, [System.Drawing.FontStyle]::Bold);
$brushText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255, 255));
$format = New-Object System.Drawing.StringFormat;
$format.Alignment = [System.Drawing.StringAlignment]::Center;
$format.LineAlignment = [System.Drawing.StringAlignment]::Center;

$rect = New-Object System.Drawing.RectangleF 90, 180, 332, 150;
$g.DrawString('${label}', $font, $brushText, $rect, $format);

$g.Dispose();
$b.Save('${fullOut.replace(/\\/g, '\\\\')}', [System.Drawing.Imaging.ImageFormat]::Png);
$b.Dispose();
`;

  execSync(`powershell -Command "${psScript.replace(/\n/g, ' ')}"`, { stdio: 'inherit' });
  console.log(`[Mock Asset] Generado exitosamente en: ${outputPath}`);
}

async function main() {
  const args = process.argv.slice(2);
  if (args.includes('--help') || args.length === 0) {
    printUsage();
    return;
  }

  if (args.includes('--list')) {
    console.log('\n--- Presets configurados en el Pipeline ---');
    for (const [key, val] of Object.entries(PRESETS)) {
      const exists = fs.existsSync(path.resolve(__dirname, '../../', val.output));
      console.log(` • [${key}]: ${val.name}\n   Destino: ${val.output} (${exists ? 'EXISTE' : 'PENDIENTE'})`);
    }
    return;
  }

  const isMock = args.includes('--mock');
  const presetIndex = args.indexOf('--preset');
  const promptIndex = args.indexOf('--prompt');
  const outputIndex = args.indexOf('--output');
  const modelIndex = args.indexOf('--model');

  let prompt = '';
  let outputPath = '';
  let manifestId = '';
  let transparent = true;

  if (presetIndex !== -1 && args[presetIndex + 1]) {
    const presetKey = args[presetIndex + 1];
    const preset = PRESETS[presetKey];
    if (!preset) {
      console.error(`Error: El preset '${presetKey}' no existe. Usa --list para ver los presets.`);
      process.exit(1);
    }
    const promptPath = path.resolve(__dirname, preset.promptFile);
    prompt = fs.readFileSync(promptPath, 'utf8').trim();
    outputPath = preset.output;
    manifestId = preset.manifestId;
    transparent = preset.transparent;
    console.log(`[Preset] Seleccionado: ${preset.name}`);
  } else if (promptIndex !== -1 && outputIndex !== -1) {
    prompt = args[promptIndex + 1];
    outputPath = args[outputIndex + 1];
    manifestId = path.basename(outputPath, path.extname(outputPath));
  } else {
    console.error('Error: Debes especificar --preset <nombre> o tanto --prompt como --output.');
    printUsage();
    process.exit(1);
  }

  const model = (modelIndex !== -1 && args[modelIndex + 1])
    ? args[modelIndex + 1]
    : (process.env.GEMINI_IMAGE_MODEL || 'imagen-3.0-generate-002');

  const apiKey = process.env.GEMINI_API_KEY;

  console.log(`[Pipeline] Modelo objetivo: ${model}`);
  console.log(`[Pipeline] Destino: ${outputPath}`);
  console.log(`[Pipeline] Prompt: "${prompt.substring(0, 80)}..."`);

  if (isMock) {
    console.log('[Pipeline] Ejecutando en MODO MOCK (offline)...');
    generateMockAsset(outputPath, manifestId, transparent);
    updateManifest(manifestId, outputPath, 'mock-renderer');
    console.log('✓ Pipeline completado en modo simulación.');
    return;
  }

  if (!apiKey || apiKey === 'replace-with-your-private-key') {
    console.warn(`
[AVISO] No se detectó una GEMINI_API_KEY configurada en tu archivo .env local.
Para generar assets reales con Gemini:
  1. Crea el archivo .env en la raíz del proyecto (ignorado por Git).
  2. Agrega tu clave privada: GEMINI_API_KEY=tu_api_key_aqui
  3. Ejecuta nuevamente este comando.

Para probar la integración y pipeline de forma offline ahora mismo, ejecuta:
  node tools/asset_pipeline/generate_asset.js --preset ${args[presetIndex + 1] || 'badge_logic'} --mock
`);
    return;
  }

  try {
    console.log('[Pipeline] Conectando con la API de Gemini Imagen...');
    const buffer = await generateWithGemini(prompt, model, apiKey);

    const fullOut = path.resolve(__dirname, '../../', outputPath);
    const dir = path.dirname(fullOut);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

    fs.writeFileSync(fullOut, buffer);
    console.log(`✓ Imagen guardada en: ${outputPath} (${(buffer.length / 1024).toFixed(1)} KB)`);

    if (transparent) {
      console.log('[Pipeline] Aplicando remoción de fondo transparente...');
      execSync(`powershell -Command "Add-Type -AssemblyName System.Drawing; [ImageProcessor]::RemoveBackground('${fullOut.replace(/\\/g, '\\\\')}', '${fullOut.replace(/\\/g, '\\\\')}')"`, { stdio: 'inherit' });
    }

    updateManifest(manifestId, outputPath, model);
    console.log('✓ Proceso de generación y registro completado exitosamente.');
  } catch (err) {
    console.error(`✗ Error durante la generación: ${err.message}`);
    process.exit(1);
  }
}

main();
