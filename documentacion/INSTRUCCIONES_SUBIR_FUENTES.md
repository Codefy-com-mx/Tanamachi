# INSTRUCCIONES PARA SUBIR ARCHIVOS DE FUENTE

## PROBLEMA ACTUAL
Error 403 (Forbidden) - Los archivos no están accesibles en el servidor

## SOLUCIÓN: SUBIR ARCHIVOS AL SERVIDOR

### Opción 1: Usando SFTP (Recomendado)

1. **Conecta al servidor FTP:**
   - Host: ftp.tiendanube.com
   - Usuario: scatola5
   - Puerto: 21

2. **Navega a la carpeta del tema:**
   - Busca la carpeta `static/`
   - Si no existe `static/fonts/`, créala

3. **Sube los archivos:**
   - `static/fonts/RocketClouds.woff2`
   - `static/fonts/RocketClouds.woff`

### Opción 2: Desde el Panel de Tiendanube

1. Ve a: **Diseño → Editor de código → Archivos**
2. Navega a `static/`
3. Crea la carpeta `fonts/` si no existe
4. Sube los archivos:
   - `RocketClouds.woff2`
   - `RocketClouds.woff`

### Opción 3: Usando VS Code SFTP

1. Haz clic derecho en la carpeta `static/fonts/`
2. Selecciona "Upload Folder"
3. Espera a que se suban los archivos

## VERIFICACIÓN

Después de subir, verifica que los archivos estén accesibles:

1. Abre DevTools (F12)
2. Ve a Network → Filtra por "woff"
3. Recarga la página
4. Los archivos deberían mostrar Status 200 (OK) en lugar de 403

## ESTRUCTURA CORRECTA EN EL SERVIDOR

```
/
└── static/
    └── fonts/
        ├── RocketClouds.woff2  ← Debe estar aquí
        └── RocketClouds.woff   ← Debe estar aquí
```

## NOTA IMPORTANTE

Si después de subir los archivos sigue apareciendo 403:
- Verifica los permisos de los archivos (deben ser 644 o 755)
- Verifica que la ruta sea exactamente `static/fonts/` (no `static/fonts` o `static/fonts/`)
- Limpia la caché del navegador y del servidor
