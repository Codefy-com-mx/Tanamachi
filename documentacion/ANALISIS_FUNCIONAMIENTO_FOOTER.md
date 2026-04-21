# 🛠️ Análisis de Funcionamiento del Footer (Actualizado)

Este documento detalla la estructura implementada del footer en el proyecto Aguiar, adaptado a un diseño de 4 columnas en Desktop y en formato de acordeones interactivos para dispositivos móviles.

---

## 📂 Archivos Clave Modificados

| Tipo                   | Ruta                                       | Función                                                                                                                                                                                                                                    |
| :--------------------- | :----------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Template Principal** | `snipplets/footer/footer.tpl`              | Estructura HTML principal en formato Grid de 4 columnas, incluye estilos CSS integrados para desktop/mobile, lógica de renderizado del componente de Tiendanube y un bloque Javascript "VanillaJS" para la interactividad móvil sin caché. |
| **Snippet Menú**       | `snipplets/navigation/navigation-foot.tpl` | Snippet que renderiza las listas de enlaces. Modificado para aceptar handles dinámicos de menús a través de variables.                                                                                                                     |
| **Variables Settings** | `config/settings.txt`                      | Modificado para añadir soporte a múltiples menús (`footer_menu_2`), títulos configurables para cada columna del footer e independizar la configuración de la UI.                                                                           |
| **Valores Default**    | `config/defaults.txt`                      | Inicializado con valores por defecto acordes al diseño ("DISTRIBUIDORES", "CENTRO DE AYUDA", "SUSCRÍBETE A NUESTRO NEWSLETTER", etc.).                                                                                                     |

---

## 🏗️ Nueva Estructura del Template (`footer.tpl`)

El footer ha transicionado de ser una única columna central a un **Grid de 4 Columnas** (`.row > .col-md-3`).

### 🖥️ Comportamiento Desktop (≥ 768px)

Las cuatro columnas siempre están expandidas a la vista:

1.  **Columna 1:** Logo de la marca, enlaces de contacto, conectores a redes sociales y datos de copyright (ocultos en esta vista localizados bajo la col).
2.  **Columna 2 (Menú 1):** Título + Llamado a `navigation-foot.tpl` usando el handle predeterminado de Tiendanube.
3.  **Columna 3 (Menú 2):** Título + Llamado a `navigation-foot.tpl` pasando explícitamente el nuevo handle dinámico (`footer_menu_2`).
4.  **Columna 4 (Newsletter):** Título + Llamado a `snipplets/newsletter.tpl`.

### 📱 Comportamiento Móvil (< 768px) - "El Acordeón"

Para ahorrar espacio vertical en dispositivos móviles, se ha implementado un patrón de Acordeón exclusivo:

- Los títulos de las columnas se vuelven _"Toggles"_ interactivos (`.js-footer-accordion-toggle`).
- El contenido de cada columna permanece oculto por defecto con `display: none` gracias a clases CSS en media queries móviles.
- Solo se permite **un acordeón abierto a la vez** para maximizar la legibilidad en pantallas pequeñas.

---

## 🚀 Solución a Errores de JS y Caché (Importante)

Durante el desarrollo se detectó que el JS general alojado en `static/js/store.js.tpl` a menudo sufría de un agudo retardo de empaquetamiento (caché nativa de la infraestructura de Tiendanube). Esto impedía probar y ejecutar funcionalmente el clic en títulos móviles de manera inmediata.

**Solución aplicada:**
Para asegurar un funcionamiento 100% confiable y libre de caché en todo momento, la lógica de interacción móvil se extrajo de `store.js.tpl` a un entorno seguro de VanillaJS inyectado con un `<script>` tag directamente al final del archivo `footer.tpl`.

```javascript
document.addEventListener("DOMContentLoaded", function () {
  var toggles = document.querySelectorAll(".js-footer-accordion-toggle");
  toggles.forEach(function (toggle) {
    toggle.addEventListener("click", function (e) {
      // Se encapsula en verificación innerWidth para prevenir colisiones en Desktop
      if (window.innerWidth < 768) {
        e.preventDefault();
        // ... lógica para cerrar todos los bloques
        // ... lógica para abrir el clickeado y cambiar ícono (+/-)
      }
    });
  });
});
```

---

## ⚠️ Componentes Legales (No Borrar)

Dentro de `footer.tpl` se insertaron y respetaron los componentes estándar de la plataforma Tiendanube que no deben eliminarse:

- `has_languages`: Variable y visualización para mostrar el widget de multi idioma en tiendas regionales.
- `{{ new_powered_by_link }}`: Firma obligatoria y por defecto del branding.
- `claim-info`: El componente `{{ component('claim-info',...) }}` que pinta el botón de Arrepentimiento/Botón de baja.
- El duplicado extra custom de _Copyright_ fue eliminado en favor de las variables unificadas preexistentes.
- **Texto Custom (Columna 1)**: Se añadió un campo `footer_about_text` en `settings.txt` para cargar texto o HTML libre debajo del logo.

---

## ⚙️ Modificación al Snippet del Menú (Guía de Referencia)

Originalmente `snipplets/navigation/navigation-foot.tpl` leía estrictamente `settings.footer_menu` para popular sus listas de enlaces.

**Para permitir que reciba un menú diferente según la columna:**
Se aplicó un _filtro default_ de Twig en su inicialización que prioriza el objeto mandado por el parent a menos de que esté vacío (módulo de herencia robusta).

```twig
{% set resolved_handle = menu_handle | default(settings.footer_menu) %}
<ul class="list py-2 font-small">
	{% for item in menus[resolved_handle] %}
        ...
```

---

## 📧 Sistema de Newsletter

El componente de newsletter (`snipplets/newsletter.tpl`) es una pieza de funcionalidad nativa protegida por Tiendanube.

### Funcionamiento Técnico
- **Seguridad (Winnie-Pooh)**: Utiliza un campo "honeypot" para atrapar bots y prevenir SPAM. Es crítico **no eliminar** el bloque con clase `.winnie-pooh`.
- **Registro de Clientes**: Envía datos a través de peticiones POST que registran automáticamente al usuario en la sección de "Clientes" del administrador.
- **Retroalimentación**: Utiliza el objeto `contact` para mostrar alertas de éxito o error sin recargar la página necesariamente en temas modernos.

### Gestión de Estilos
Los estilos se distribuyen en tres niveles:
1. **Atómicos (`style-async.scss`)**: Posicionamiento del botón respecto al input (generalmente `absolute` a la derecha).
2. **Visuales (`style-colors.scss`)**: Colores vinculados a variables como `--newsletter-background` y `--newsletter-foreground`.
3. **Específicos (`footer.tpl`)**: Cualquier ajuste hecho bajo el contenedor `.newsletter-wrapper` para no afectar otras secciones de la tienda.

### 🆕 Rediseño de Newsletter (Footer)
Se ha implementado una versión extendida (`newsletter_full: true`) que añade:
- **Doble Entrada**: Campo independiente para "Nombre" y "Email".
- **Disposición Vertical**: Elementos unos sobre otros ocupando el 100% del ancho.
- **Checkbox de Consentimiento**: Para cumplimiento de marketing.
- **Estilos Premium**: Inputs con fondo suave (`#e9e9e9`), bordes redondeados (8px) y botón destacado con efecto hover.

---

## 📱 Compatibilidad con iOS (iPhone/iPad)

Se detectó y neutralizó un comportamiento nativo del tema que afectaba a dispositivos Apple:
- **Problema**: iOS aplicaba un zoom automático y un escalado (`scale(0.75)`) que deformaba el ancho de los inputs en el footer.
- **Solución**: En `footer.tpl` se inyectó CSS para anular el `transform`, forzar `width: 100%` y establecer un `font-size: 16px` (mínimo requerido por iOS para no activar el zoom nativo), asegurando una visualización consistente.

---

## 🎨 Identidad y Refinamiento Visual

### Firma de Créditos (Codefy)
Se integró el identificador de **Codefy** junto al link de Tiendanube:
- **Formato**: SVG inyectado directamente (inline) para soportar `fill: currentColor` y carga ultra rápida.
- **Alineación**: Ambos logos están centrados horizontalmente en el bloque inferior de créditos.
- **Enlace**: Apunta a `https://www.codefy.com.mx/` con apertura en pestaña nueva.

### Tipografía y Alineación de Menús
- **Títulos de Columna**: Unificados a **16px** con peso de **500** y transformación `uppercase` para una jerarquía clara.
- **Alineación Vertical**: Se eliminaron los márgenes y rellenos (`padding-left: 0`, `margin-left: 0`) heredados en la lista de menús para que el texto de los enlaces se alinee perfectamente con la primera letra de los títulos de cada columna.
