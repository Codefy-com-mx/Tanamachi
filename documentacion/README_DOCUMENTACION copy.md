# 📚 Documentación del Tema Scatola - Tiendanube

## 🎯 Propósito de esta documentación

Esta documentación ha sido creada para facilitar el desarrollo y mantenimiento del tema **Scatola** en Tiendanube, así como para ayudar a tu equipo a comprender la estructura y mejores prácticas de desarrollo de temas en esta plataforma.

---

## 📖 Guías disponibles

### 1. [GUIA_MIGRACION_CARRUSEL.md](./GUIA_MIGRACION_CARRUSEL.md)
**📦 Migración de Sección: Carrusel de Secciones Personalizado**

Esta guía te muestra paso a paso cómo migrar o implementar la sección de "Carrusel de Secciones Personalizado" en cualquier tema de Tiendanube.

**Contenido:**
- ✅ Checklist completo de archivos a modificar/crear
- 🔧 Configuración detallada en `settings.txt` y `defaults.txt`
- 📚 Integración con `layout.tpl` y `home-section-switch.tpl`
- 🎨 Snippet completo del carrusel con Embla Carousel
- 🐛 Problemas comunes y sus soluciones
- 🎯 Consejos pro y mejores prácticas

**Ideal para:**
- Migrar el carrusel a otro tema
- Entender cómo crear una sección completa desde cero
- Aprender sobre integración de librerías externas (Embla Carousel)

---

### 2. [GUIA_ESTRUCTURA_TIENDANUBE.md](./GUIA_ESTRUCTURA_TIENDANUBE.md)
**🏗️ Estructura Completa de Temas en Tiendanube**

La guía definitiva para entender la arquitectura de un tema de Tiendanube desde cero.

**Contenido:**
- 🏗️ Arquitectura general del tema
- 📁 Estructura de directorios (`config/`, `layouts/`, `templates/`, `snipplets/`, `static/`)
- 🔧 Todos los tipos de campos en `settings.txt` (checkbox, dropdown, gallery, etc.)
- 🎨 Motor de templates Twig: variables, condicionales, loops, filtros
- 🖼️ Manejo completo de imágenes (IMAGE, GALLERY)
- 📱 Responsive design y breakpoints
- 🔄 Sistema de secciones del home
- 🎨 Variables CSS del tema
- 🔍 Debug y testing
- ⚡ Performance y optimización
- 🐛 Errores comunes y soluciones

**Ideal para:**
- Nuevos desarrolladores en el equipo
- Referencia rápida durante el desarrollo
- Entender cómo funcionan los temas de Tiendanube

---

### 3. [CONTEXTO_CURSOR_TIENDANUBE.md](./CONTEXTO_CURSOR_TIENDANUBE.md)
**🤖 Prompt de Contexto para Cursor AI**

Un prompt optimizado para usar en Cursor (o cualquier AI assistant) que contiene todo el contexto del proyecto y lecciones aprendidas.

**Contenido:**
- 📋 Prompt completo listo para copiar y pegar
- 🧠 Conocimientos clave adquiridos durante el desarrollo
- 🐛 Problemas resueltos con sus soluciones detalladas
- ✅ Mejores prácticas validadas
- ⚠️ Recordatorios importantes de sintaxis
- 💡 Ejemplos de uso del prompt

**Ideal para:**
- Iniciar sesiones de desarrollo con Cursor
- Transferir conocimiento al AI assistant
- Mantener consistencia en el desarrollo
- Evitar repetir errores del pasado

---

### 4. [GUIA_CENTRAR_MENU_DESKTOP.md](./GUIA_CENTRAR_MENU_DESKTOP.md)
**🎯 Centrar Menú de Navegación en Desktop**

Documentación sobre cómo se implementó el centrado del menú de navegación en desktop y cómo aplicar este cambio en futuras páginas o temas.

**Contenido:**
- 🔍 Explicación de la implementación actual
- 📍 Ubicación exacta del código (archivo y línea)
- 🚀 Tres opciones para aplicar el cambio en futuras páginas
- 🎨 Estilos CSS relacionados
- ✅ Checklist paso a paso
- 🐛 Problemas comunes y soluciones
- 🔧 Variables y configuraciones necesarias

**Ideal para:**
- Aplicar el centrado del menú en nuevas páginas
- Entender cómo funciona el sistema de navegación
- Migrar esta funcionalidad a otros temas
- Resolver problemas de alineación del menú

---

## 🚀 Cómo usar esta documentación

### Para desarrolladores nuevos:

1. **Empieza con:** `GUIA_ESTRUCTURA_TIENDANUBE.md`
   - Lee la arquitectura general
   - Familiarízate con la estructura de archivos
   - Entiende cómo funciona Twig

2. **Continúa con:** `GUIA_MIGRACION_CARRUSEL.md`
   - Ve un ejemplo real y completo
   - Sigue el paso a paso para entender el flujo
   - Practica creando tu propia sección

3. **Finalmente:** `CONTEXTO_CURSOR_TIENDANUBE.md`
   - Úsalo cuando trabajes con AI assistants
   - Consulta los problemas resueltos cuando te atasques

4. **Referencia específica:** `GUIA_CENTRAR_MENU_DESKTOP.md`
   - Cuando necesites centrar el menú en nuevas páginas
   - Para entender la estructura del header y navegación

### Para desarrolladores experimentados:

- **Referencia rápida:** `GUIA_ESTRUCTURA_TIENDANUBE.md`
- **Migración de componentes:** `GUIA_MIGRACION_CARRUSEL.md`
- **Desarrollo con AI:** `CONTEXTO_CURSOR_TIENDANUBE.md`
- **Ajustes de navegación:** `GUIA_CENTRAR_MENU_DESKTOP.md`

### Para líderes de equipo:

- Asigna la lectura de `GUIA_ESTRUCTURA_TIENDANUBE.md` a nuevos miembros
- Usa `CONTEXTO_CURSOR_TIENDANUBE.md` como base de conocimiento del equipo
- Actualiza las guías cuando se descubran nuevas soluciones

---

## 🎓 Sección de ejemplo: Carrusel de Secciones Personalizado

Este tema incluye una sección completamente funcional y personalizable:

### Características:
- ✅ Carrusel responsive con Embla Carousel
- ✅ 20+ opciones configurables desde el admin
- ✅ Soporte para imágenes, títulos y enlaces
- ✅ Autoplay configurable
- ✅ Loop infinito
- ✅ Navegación con flechas y dots
- ✅ Aspecto de imagen configurable (square, portrait, landscape, wide)
- ✅ Containers responsive (full, full_left, minimal, normal, wide)
- ✅ Mobile First design

### Archivos involucrados:
```
config/
├── settings.txt          [Líneas ~1110-1250]
└── defaults.txt          [Líneas 126-146]

layouts/
└── layout.tpl            [<head> - Carga de Embla Carousel]

snipplets/
├── home/
│   ├── home-section-switch.tpl  [Case para carrusel_secciones]
│   └── home-carrusel-secciones.tpl  [Snippet completo]
```

---

## 🐛 Troubleshooting

### Si algo no funciona:

1. **Consulta:** `GUIA_MIGRACION_CARRUSEL.md` - Sección "Problemas Comunes y Soluciones"
2. **Revisa:** `GUIA_ESTRUCTURA_TIENDANUBE.md` - Sección "Errores Comunes"
3. **Usa:** `CONTEXTO_CURSOR_TIENDANUBE.md` - Sección "PROBLEMAS RESUELTOS Y SOLUCIONES"

### Recursos adicionales:

- **Documentación oficial de Tiendanube:** https://github.com/TiendaNube/api-docs
- **Documentación de Twig:** https://twig.symfony.com/doc/
- **Embla Carousel:** https://www.embla-carousel.com/

---

## 🔄 Mantenimiento de la documentación

Esta documentación debe actualizarse cuando:

- ✅ Se resuelva un nuevo problema
- ✅ Se descubra una mejor práctica
- ✅ Se agregue una nueva funcionalidad importante
- ✅ Se encuentre un error en la documentación
- ✅ Cambien las APIs o estructura de Tiendanube

### Cómo actualizar:

1. Edita el archivo `.md` correspondiente
2. Agrega la fecha de actualización
3. Notifica al equipo del cambio
4. Si actualizas el contexto, úsalo en tu próxima sesión de Cursor

---

## 📊 Estadísticas del proyecto

**Sección de Carrusel Personalizado:**
- Líneas de código: ~570
- Opciones configurables: 20+
- Archivos modificados: 5
- Tiempo de desarrollo: ~8 horas
- Problemas resueltos: 8 mayores

**Aprendizajes:**
- 🧠 8 problemas técnicos resueltos y documentados
- 📚 Estructura completa de temas Tiendanube
- 🎯 15+ mejores prácticas identificadas
- ⚡ 5 optimizaciones de performance implementadas

---

## 👥 Contribuciones

Si encuentras errores o tienes sugerencias para mejorar la documentación:

1. Crea un issue describiendo el problema o sugerencia
2. O directamente edita el archivo `.md` y crea un pull request
3. Incluye ejemplos si es posible

---

## 📜 Licencia y uso

Esta documentación es parte del tema **Scatola** y está destinada para uso interno del equipo de desarrollo.

---

## 🎉 Agradecimientos

Documentación creada durante el desarrollo colaborativo con Cursor AI, documentando todos los aprendizajes, problemas resueltos y mejores prácticas descubiertas en el proceso.

---

**Última actualización:** Octubre 2025

**Mantenedor:** Tu equipo de desarrollo

**Versión:** 1.0.0

---

## 🚀 Quick Start

```bash
# 1. Leer documentación base
cat GUIA_ESTRUCTURA_TIENDANUBE.md

# 2. Ver ejemplo completo
cat GUIA_MIGRACION_CARRUSEL.md

# 3. Copiar contexto para Cursor
cat CONTEXTO_CURSOR_TIENDANUBE.md

# 4. Ver guía de centrado de menú
cat GUIA_CENTRAR_MENU_DESKTOP.md

# 5. ¡Empezar a desarrollar! 🎨
```

---

**💡 Tip:** Mantén estos archivos a mano durante el desarrollo. Son tu referencia rápida para cualquier duda sobre la estructura de Tiendanube.

