# Plan Maestro: Implementación Global de Fuentes

Este documento detalla la estrategia para integrar dos nuevas tipografías personalizadas en todo el proyecto de forma centralizada y eficiente.

## 1. Objetivos
*   **Fuente para Títulos:** Aplicar una tipografía específica a todos los encabezados y títulos de secciones.
*   **Fuente para Cuerpo:** Definir una tipografía base para todos los textos descriptivos, párrafos y elementos informativos.
*   **Integración Global:** Evitar la edición archivo por archivo, utilizando el sistema de tokens del tema.

## 2. Metodología Técnica

### A. Carga de Fuentes
Dependiendo del formato proporcionado, se realizará una de las siguientes acciones:
*   **Google Fonts:** Inserción del link de importación en el `<head>` mediante `layouts/layout.tpl`.
*   **Archivos Locales (.woff2, .ttf):** Carga en la carpeta `/static/fonts` y declaración mediante `@font-face` en un archivo CSS base (ej. `style-critical.scss`).

### B. Sobreescritura de Tokens Maestros
El núcleo del cambio se realizará en `static/css/style-tokens.tpl`. Se modificarán las variables CSS raíz para forzar el uso de las nuevas fuentes:

```css
:root {
  --heading-font: 'NombreNuevaFuenteTitulos', serif;
  --body-font: 'NombreNuevaFuenteCuerpo', sans-serif;
}
```

### C. Limpieza de Estilos Ad-hoc
Se realizará un escaneo en archivos de secciones personalizadas (como `style-new-section.scss`) para identificar y eliminar fuentes "hardcoded" (como `jsMath`, `Jomolhari`, etc.) que podrían romper la uniformidad visual. El objetivo es que estos elementos hereden automáticamente los valores de `--heading-font` o `--body-font`.

## 3. Beneficios de este Enfoque
*   **Mantenibilidad:** Un solo lugar para cambiar la fuente en el futuro.
*   **Rendimiento:** Carga optimizada al evitar múltiples declaraciones redundantes.
*   **Consistencia:** Asegura que no queden "huérfanos" con tipografías antiguas perdidos en el código.

## 4. Configuración Aplicada

Se implementaron las siguientes tipografías mediante carga optimizada de Google Fonts:
*   **Encabezados (`--heading-font`):** Source Serif 4
*   **Cuerpo (`--body-font`):** Crimson Pro

### Ajuste Especial: Textos Base en Itálica
Por requerimiento del diseño, la fuente *Crimson Pro* utilizada para los textos generales debe mostrarse siempre en su variante itálica de forma predeterminada. 

Para lograr este efecto a nivel global (sin editar el HTML sección por sección), se ajustó el archivo de estilos principal (`static/css/style-colors.scss`):
1.  **Etiqueta Body:** Se le aplicó la propiedad `font-style: italic;`. Esto obliga a todo el texto del proyecto que herede `--body-font` a inclinarse.
2.  **Etiquetas de Encabezados (H1-H6):** Se les aplicó un escudo preventivo usando `font-style: normal;`. Esto asegura que los títulos (que usan *Source Serif 4*) mantengan su postura sólida y recta, creando el contraste deseado contra los párrafos itálicos.

### Justificación Meticulosa de la Edición de `style-colors.scss`

La elección de este archivo no fue accidental, sino basada en un análisis de la arquitectura de entrega de estilos del tema:

1.  **Jerarquía de Cascada (CSS Cascade):**
    En este proyecto, `style-colors.scss` se procesa y se inyecta de forma **inline** o prioritaria en el `<head>` (visto en `layout.tpl`). Editar el selector `body` aquí asegura que cualquier otro estilo cargado posteriormente (como `style-async.scss` o `style-new-section.scss`) respete la base itálica sin necesidad de usar `!important` en cada rincón del código, manteniendo un CSS limpio y optimizado.

2.  **Impacto Cero en la Lógica Funcional:**
    Las propiedades modificadas (`font-family` y `font-style`) son puramente **declarativas y visuales**. No afectan propiedades de flujo o estructura (como `display`, `position`, `width` o `z-index`). Por lo tanto, el comportamiento de los scripts de AJAX, el carrito de compras, los acordeones de productos o el checkout permanece **intacto y seguro**. El navegador simplemente cambia el dibujo de la letra, no la posición o interacción de los objetos.

3.  **Prevención de "Code Smell" (Duplicación):**
    Si hubiéramos aplicado este cambio en archivos de secciones individuales, habríamos creado cientos de reglas redundantes. Al hacerlo en `style-colors.scss`, aprovechamos el sistema de **Herencia Nativa del DOM**: los elementos hijos heredan el estilo del padre automáticamente. Esto reduce el tamaño final de los archivos CSS, mejorando ligeramente la velocidad de carga de la tienda.

4.  **Control Preservado para Excepciones:**
    La edición se hizo de tal forma que no bloquea la personalización. Al definir `font-style: normal` explícitamente para los encabezados (`h1`-`h6`), creamos una regla de **especificidad** superior. Esto garantiza que el cambio "global" no se convierta en una limitación, permitiendo que el diseño mantenga su jerarquía visual (Cuerpo = Itálico / Títulos = Rectos).

**Conclusión de Seguridad:** El cambio es 100% seguro para la estabilidad de la tienda, ya que opera exclusivamente en la capa de presentación tipográfica sin interferir con las capas de lógica o estructura del proyecto.

---
*Documento creado como guía de respaldo para el equipo de desarrollo.*
