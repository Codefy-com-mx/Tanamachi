# Guía: Formularios de Contacto en Tiendanube

## 📋 Resumen

Este documento explica cómo funcionan los formularios de contacto en el proyecto Scatola para Tiendanube, incluyendo su estructura, componentes y cómo crear nuevos formularios.

---

## ⚠️ INFORMACIÓN CRÍTICA: Identificadores de Formulario

### 🔑 Cambio Más Importante para que Funcionen los Formularios

**Si un formulario de contacto no guarda mensajes en el panel de Tiendanube, el problema más común es el uso de identificadores incorrectos.**

### Identificadores OBLIGATORIOS

Para que Tiendanube procese correctamente un formulario de contacto, **DEBES usar estos valores exactos:**

```twig
form_id: 'contact-form',      // ⚠️ OBLIGATORIO
data_store: 'contact-form'    // ⚠️ OBLIGATORIO
```

### ¿Por qué es crítico?

Tiendanube parece identificar los formularios de contacto por el `form_id` y `data_store`. Si usas identificadores diferentes (ej: `home-formulario`, `mi-formulario`), el sistema puede que no lo procese como un formulario de contacto válido y los mensajes no aparecerán en el panel de administración.

### Ejemplo Real

**❌ NO funciona:**
```twig
form_id: 'home-formulario',
data_store: 'home-formulario'
```

**✅ SÍ funciona:**
```twig
form_id: 'contact-form',
data_store: 'contact-form'
```

**Caso de estudio completo:** Ver sección "📖 Caso de Estudio: Formulario en Home (Codefy)" más abajo.

---

## 🎯 Archivos Principales

### Página de Contacto Principal
- **`templates/contact.tpl`** - Template principal de la página de contacto
- **`snipplets/contact-links.tpl`** - Componente de enlaces de contacto (WhatsApp, teléfono, email)

### Componentes de Formularios
- **`snipplets/forms/form.tpl`** - Template base para todos los formularios
- **`snipplets/forms/form-input.tpl`** - Template reutilizable para inputs y textareas
- **`snipplets/forms/form-select.tpl`** - Template para select/dropdown (si existe)

---

## 🏗️ Estructura del Formulario de Contacto

### 1. Endpoint de Envío
Todos los formularios de contacto en Tiendanube usan el endpoint:
```
/winnie-pooh
```

Este es el endpoint estándar de Tiendanube para procesar formularios de contacto. El sistema lo procesa automáticamente y envía un email al administrador de la tienda.

### 2. Tipo de Formulario
Los formularios se diferencian por el campo `type`:
- `type: "contact"` - Formulario de contacto general
- `type: "newsletter"` - Suscripción al newsletter
- `type: "order_cancellation"` - Cancelación de pedido

### 3. Protección Anti-Spam (Honeypot)
Todos los formularios incluyen un campo oculto llamado `winnie-pooh` que actúa como honeypot para prevenir spam:

```twig
<div class="winnie-pooh hidden">
    <label for="winnie-pooh">{{ "No completar este campo" | translate }}:</label>
    <input type="text" id="winnie-pooh" name="winnie-pooh">
</div>
```

Si este campo es completado, el formulario es rechazado (es spam).

---

## 📝 Ejemplo Completo: Formulario de Contacto

### Ubicación: `templates/contact.tpl`

```twig
{% embed "snipplets/forms/form.tpl" with{
    form_id: 'contact-form',
    form_custom_class: 'js-winnie-pooh-form',
    form_action: '/winnie-pooh',
    submit_custom_class: 'btn-block',
    submit_name: 'contact',
    submit_text: 'Enviar' | translate,
    data_store: 'contact-form'
} %}
    {% block form_body %}
        
        {# Honeypot anti-spam #}
        <div class="winnie-pooh hidden">
            <label for="winnie-pooh">{{ "No completar este campo" | translate }}:</label>
            <input type="text" id="winnie-pooh" name="winnie-pooh">
        </div>
        
        {# Tipo de formulario #}
        <input type="hidden" name="type" value="contact" />
        
        {# ID de producto (si viene de una página de producto) #}
        <input type="hidden" value="{{ product.id }}" name="product"/>
        
        {# Campo Nombre #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'name',
            type_text: true,
            input_name: 'name',
            input_id: 'name',
            input_label_text: 'Nombre' | translate,
            input_placeholder: 'ej.: María Perez' | translate
        } %}
        {% endembed %}
        
        {# Campo Email #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'email',
            type_email: true,
            input_name: 'email',
            input_id: 'email',
            input_label_text: 'Email' | translate,
            input_placeholder: 'ej.: tuemail@email.com' | translate
        } %}
        {% endembed %}
        
        {# Campo Teléfono #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'phone',
            type_tel: true,
            input_name: 'phone',
            input_id: 'phone',
            input_label_text: 'Teléfono' | translate,
            input_placeholder: 'ej.: 1123445567' | translate
        } %}
        {% endembed %}
        
        {# Campo Mensaje (textarea) #}
        {% embed "snipplets/forms/form-input.tpl" with{
            text_area: true,
            input_for: 'message',
            input_name: 'message',
            input_id: 'message',
            input_rows: '7',
            input_label_text: 'Mensaje' | translate,
            input_placeholder: 'ej.: Tu mensaje' | translate
        } %}
        {% endembed %}
        
    {% endblock %}
{% endembed %}
```

---

## 🔧 Componentes de Formularios

### `snipplets/forms/form.tpl` - Template Base

**Parámetros principales:**
- `form_id` - ID único del formulario
- `form_action` - URL de envío (normalmente `/winnie-pooh`)
- `form_custom_class` - Clases CSS personalizadas
- `submit_text` - Texto del botón de envío
- `submit_name` - Nombre del botón de envío
- `data_store` - Atributo data-store para tracking

**Ejemplo:**
```twig
{% embed "snipplets/forms/form.tpl" with{
    form_id: 'mi-formulario',
    form_action: '/winnie-pooh',
    submit_text: 'Enviar' | translate,
    submit_name: 'contact'
} %}
    {% block form_body %}
        {# Aquí van los campos del formulario #}
    {% endblock %}
{% endembed %}
```

### `snipplets/forms/form-input.tpl` - Inputs y Textareas

**Tipos de input disponibles:**
- `type_text: true` - Input de texto
- `type_email: true` - Input de email
- `type_tel: true` - Input de teléfono
- `type_number: true` - Input numérico
- `type_password: true` - Input de contraseña
- `text_area: true` - Textarea

**Parámetros principales:**
- `input_id` - ID del input
- `input_name` - Nombre del campo (name attribute)
- `input_label_text` - Texto del label
- `input_placeholder` - Placeholder
- `input_value` - Valor por defecto
- `input_rows` - Filas del textarea
- `input_required` - Campo requerido
- `input_custom_class` - Clases CSS personalizadas

**Ejemplos:**

**Input de texto:**
```twig
{% embed "snipplets/forms/form-input.tpl" with{
    type_text: true,
    input_name: 'nombre',
    input_id: 'nombre',
    input_label_text: 'Nombre' | translate,
    input_placeholder: 'Tu nombre' | translate
} %}
{% endembed %}
```

**Textarea:**
```twig
{% embed "snipplets/forms/form-input.tpl" with{
    text_area: true,
    input_name: 'mensaje',
    input_id: 'mensaje',
    input_rows: '5',
    input_label_text: 'Mensaje' | translate,
    input_placeholder: 'Tu mensaje' | translate
} %}
{% endembed %}
```

**Input de email:**
```twig
{% embed "snipplets/forms/form-input.tpl" with{
    type_email: true,
    input_name: 'email',
    input_id: 'email',
    input_label_text: 'Email' | translate,
    input_placeholder: 'tu@email.com' | translate,
    input_required: true
} %}
{% endembed %}
```

---

## 📧 Manejo de Respuestas del Formulario

### Variables de Respuesta
Tiendanube proporciona una variable `contact` que contiene información sobre el envío:

```twig
{% if contact %}
    {% if contact.success %}
        <div class="alert alert-success">
            {{ "¡Gracias por contactarnos!" | translate }}
        </div>
    {% else %}
        <div class="alert alert-danger">
            {{ "Hubo un error al enviar el formulario." | translate }}
        </div>
    {% endif %}
{% endif %}
```

### Verificar Tipo de Formulario
```twig
{% if contact and contact.type == 'newsletter' %}
    {# Mensaje específico para newsletter #}
{% elseif contact and contact.type == 'contact' %}
    {# Mensaje específico para contacto #}
{% endif %}
```

---

## 🔗 Enlaces de Contacto

### Componente: `snipplets/contact-links.tpl`

Este componente muestra los datos de contacto de la tienda (WhatsApp, teléfono, email, dirección).

**Uso básico:**
```twig
{% include "snipplets/contact-links.tpl" %}
```

**Con iconos:**
```twig
{% include "snipplets/contact-links.tpl" with {with_icons: true} %}
```

**Como botones:**
```twig
{% include "snipplets/contact-links.tpl" with {btn_link: true} %}
```

**Solo teléfono y email:**
```twig
{% include "snipplets/contact-links.tpl" with {
    with_icons: true,
    phone_and_mail_only: true
} %}
```

**Datos disponibles:**
- `store.whatsapp` - Link de WhatsApp
- `store.phone` - Teléfono
- `store.email` - Email
- `store.address` - Dirección
- `store.blog` - Link del blog
- `store.contact_intro` - Texto introductorio personalizado

---

## 🆕 Cómo Crear un Nuevo Formulario de Contacto

### ⚠️ ADVERTENCIA IMPORTANTE
Para que Tiendanube procese correctamente los formularios de contacto y los mensajes aparezcan en el panel de administración, **debes usar exactamente estos identificadores:**
- `form_id: 'contact-form'`
- `data_store: 'contact-form'`

**NO uses identificadores personalizados** como `mi-formulario` o `home-formulario` si quieres que funcione correctamente.

### Paso 1: Crear el Template
Crea un nuevo archivo en `snipplets/` o `templates/`:

```twig
{# snipplets/mi-formulario.tpl #}

{% embed "snipplets/forms/form.tpl" with{
    form_id: 'contact-form',        // ⚠️ OBLIGATORIO: Debe ser 'contact-form'
    form_custom_class: 'js-winnie-pooh-form',
    form_action: '/winnie-pooh',
    submit_custom_class: 'btn-block',
    submit_name: 'contact',
    submit_text: 'Enviar' | translate,
    data_store: 'contact-form'      // ⚠️ OBLIGATORIO: Debe ser 'contact-form'
} %}
    {% block form_body %}
        
        {# Honeypot #}
        <div class="winnie-pooh hidden">
            <label for="winnie-pooh">{{ "No completar este campo" | translate }}:</label>
            <input type="text" id="winnie-pooh" name="winnie-pooh">
        </div>
        
        {# Tipo de formulario #}
        <input type="hidden" name="type" value="contact" />
        
        {# Tus campos personalizados aquí #}
        {% embed "snipplets/forms/form-input.tpl" with{
            type_text: true,
            input_name: 'nombre',
            input_id: 'nombre',
            input_label_text: 'Nombre' | translate,
            input_required: true
        } %}
        {% endembed %}
        
        {# Más campos... #}
        
    {% endblock %}
{% endembed %}
```

### Paso 2: Incluir el Formulario
En tu template de página:

```twig
{% include "snipplets/mi-formulario.tpl" %}
```

O en una página completa:

```twig
<section class="mi-seccion">
    <div class="container">
        <h2>Contáctanos</h2>
        {% include "snipplets/mi-formulario.tpl" %}
    </div>
</section>
```

---

## 📋 Formularios Existentes en el Proyecto

### 1. Formulario de Contacto Principal
- **Archivo:** `templates/contact.tpl`
- **URL:** `/contacto` (se crea en Tiendanube Admin)
- **Campos:** Nombre, Email, Teléfono, Mensaje
- **Tipo:** `contact`
- **Form ID:** `contact-form`
- **Data Store:** `contact-form`

### 2. Formulario de Contacto en Home (Codefy)
- **Archivo:** `snipplets/home/home-formulario.tpl`
- **Sección:** Formulario (Codefy) en la home
- **Campos:** Nombre, Email, Teléfono (Whatsapp), Mensaje
- **Tipo:** `contact`
- **Form ID:** `contact-form` ⚠️ **CRÍTICO: Debe ser el mismo que el formulario principal**
- **Data Store:** `contact-form` ⚠️ **CRÍTICO: Debe ser el mismo que el formulario principal**
- **Nota:** Este formulario fue creado basándose en `contact.tpl` para asegurar compatibilidad total

### 3. Newsletter (Home)
- **Archivo:** `snipplets/home/home-newsletter.tpl`
- **Campos:** Email
- **Tipo:** `newsletter`

### 4. Newsletter (Popup)
- **Archivo:** `snipplets/home/home-popup.tpl`
- **Campos:** Email
- **Tipo:** `newsletter`

### 5. Newsletter (Footer/Sidebar)
- **Archivo:** `snipplets/newsletter.tpl`
- **Campos:** Email
- **Tipo:** `newsletter`

### 6. Cancelación de Pedido
- **Archivo:** `templates/contact.tpl` (con variante)
- **Campos:** Nombre, Email, Número de orden
- **Tipo:** `order_cancellation`

---

## 🎨 Estilos CSS

Los formularios usan las clases Bootstrap del tema:

- `.form-group` - Contenedor de cada campo
- `.form-label` - Label del campo
- `.form-control` - Input/textarea
- `.form-control-area` - Textarea
- `.btn` - Botones
- `.btn-block` - Botón de ancho completo
- `.alert` - Mensajes de éxito/error

**Clases personalizadas:**
- `.winnie-pooh` - Campo honeypot (oculto)
- `.js-winnie-pooh-form` - Clase JS para el formulario
- `.contact-page` - Página de contacto

---

## ⚙️ Configuración en Tiendanube Admin

### Datos de Contacto
Los datos de contacto se configuran en:
**Tiendanube Admin → Configuración → Datos de contacto**

Incluye:
- Email
- Teléfono
- WhatsApp
- Dirección
- Blog

### Texto Introductorio
Puedes configurar `store.contact_intro` desde el admin de Tiendanube para mostrar un texto personalizado en la página de contacto.

---

## 🔒 Seguridad

1. **Honeypot (`winnie-pooh`)**: Campo oculto que previene spam automatizado
2. **Validación del lado del servidor**: Tiendanube valida todos los campos
3. **Sanitización**: Los datos se sanitizan automáticamente

---

## 📱 Responsive

Los formularios son responsive por defecto usando las clases Bootstrap del tema. El contenedor usa:
```twig
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            {# Formulario aquí #}
        </div>
    </div>
</div>
```

---

## 🐛 Debugging

### Verificar si el formulario se envió:
```twig
{% if contact %}
    <pre>{{ contact | json_encode }}</pre>
{% endif %}
```

### Verificar variables disponibles:
```twig
<pre>
Product: {{ product | json_encode }}
Store: {{ store | json_encode }}
Contact: {{ contact | json_encode }}
</pre>
```

---

## ⚠️ Problemas Comunes y Soluciones

### Problema: El formulario no guarda mensajes en el panel de administración

**Síntomas:**
- El formulario se envía sin errores
- No aparece ningún error en el navegador
- El mensaje NO aparece en el panel de Tiendanube

**Causa más común:**
El `form_id` y `data_store` no coinciden con los identificadores que Tiendanube espera para procesar formularios de contacto.

**Solución:**
Usar exactamente los mismos identificadores que el formulario de contacto principal:

```twig
{% embed "snipplets/forms/form.tpl" with{
    form_id: 'contact-form',        // ⚠️ CRÍTICO: Debe ser 'contact-form'
    form_custom_class: 'js-winnie-pooh-form',
    form_action: '/winnie-pooh',
    submit_custom_class: 'btn-block',
    submit_name: 'contact',
    submit_text: 'Enviar' | translate,
    data_store: 'contact-form'      // ⚠️ CRÍTICO: Debe ser 'contact-form'
} %}
```

**¿Por qué funciona?**
Tiendanube parece identificar los formularios de contacto por el `form_id` y `data_store`. Si usas identificadores diferentes (ej: `home-formulario`, `mi-formulario`), el sistema puede que no lo procese como un formulario de contacto válido y no guarde el mensaje en el panel de administración.

### Problema: Campos con IDs diferentes al formulario principal

**Solución:**
Usar exactamente los mismos IDs que el formulario de contacto principal:
- `name` para el campo nombre
- `email` para el campo email
- `phone` para el campo teléfono
- `message` para el campo mensaje

### Checklist de verificación para formularios nuevos:

- [ ] El `form_id` es `'contact-form'`
- [ ] El `data_store` es `'contact-form'`
- [ ] El `form_action` es `'/winnie-pooh'`
- [ ] Incluye el campo honeypot `winnie-pooh`
- [ ] Incluye el campo oculto `type="contact"`
- [ ] Los IDs de los campos coinciden con `contact.tpl` (`name`, `email`, `phone`, `message`)
- [ ] No hay campos ocultos adicionales que no existan en el formulario principal
- [ ] La estructura es idéntica a `templates/contact.tpl`

---

## 📖 Caso de Estudio: Formulario en Home (Codefy)

### Contexto
Se creó un formulario de contacto en la sección "Formulario (Codefy)" de la home (`snipplets/home/home-formulario.tpl`).

### Problema Encontrado
El formulario se enviaba correctamente desde el punto de vista técnico (POST request exitoso), pero los mensajes no aparecían en el panel de administración de Tiendanube.

### Proceso de Debugging

1. **Primer intento:** Se creó el formulario con `form_id: 'home-formulario'` y `data_store: 'home-formulario'`
   - ❌ No funcionó: Los mensajes no aparecían en el panel

2. **Segundo intento:** Se alinearon los IDs de campos para que coincidieran con `contact.tpl`
   - ❌ No funcionó completamente

3. **Tercer intento:** Se removieron campos ocultos adicionales
   - ❌ No funcionó completamente

4. **Solución final:** Se cambió el `form_id` y `data_store` a `'contact-form'` (idénticos al formulario principal)
   - ✅ **Funcionó correctamente**

### Cambio Crítico que Resolvió el Problema

**ANTES:**
```twig
form_id: 'home-formulario',
data_store: 'home-formulario'
```

**DESPUÉS:**
```twig
form_id: 'contact-form',
data_store: 'contact-form'
```

### Lecciones Aprendidas

1. **Identificadores críticos:** El `form_id` y `data_store` deben ser `'contact-form'` para que Tiendanube procese correctamente el formulario
2. **Estructura idéntica:** Cuanto más idéntica sea la estructura al formulario principal, mejor funcionará
3. **IDs de campos:** Los IDs de los campos deben coincidir exactamente con el formulario de referencia
4. **No agregar campos ocultos innecesarios:** Solo incluir los campos que existen en el formulario principal (honeypot y `type`)

### Código Final del Formulario de Home

```twig
{% embed "snipplets/forms/form.tpl" with{
    form_id: 'contact-form',        // ⚠️ CRÍTICO
    form_custom_class: 'js-winnie-pooh-form formulario-form',
    form_action: '/winnie-pooh',
    submit_custom_class: 'btn-block',
    submit_name: 'contact',
    submit_text: settings.formulario_button_text | default('Enviar') | translate,
    data_store: 'contact-form'      // ⚠️ CRÍTICO
} %}
    {% block form_body %}
        
        {# Honeypot anti-spam #}
        <div class="winnie-pooh hidden">
            <label for="winnie-pooh">{{ "No completar este campo" | translate }}:</label>
            <input type="text" id="winnie-pooh" name="winnie-pooh">
        </div>
        
        {# Tipo de formulario #}
        <input type="hidden" name="type" value="contact" />
        
        {# Campo Nombre - MISMOS IDs que contact.tpl #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'name',
            type_text: true,
            input_name: 'name',
            input_id: 'name',
            input_label_text: 'Nombre' | translate,
            input_placeholder: 'Nombre' | translate
        } %}
        {% endembed %}
        
        {# Campo Email - MISMOS IDs que contact.tpl #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'email',
            type_email: true,
            input_name: 'email',
            input_id: 'email',
            input_label_text: 'Correo electrónico' | translate,
            input_placeholder: 'Correo electrónico' | translate
        } %}
        {% endembed %}
        
        {# Campo Teléfono - MISMOS IDs que contact.tpl #}
        {% embed "snipplets/forms/form-input.tpl" with{
            input_for: 'phone',
            type_tel: true,
            input_name: 'phone',
            input_id: 'phone',
            input_label_text: 'Whatsapp' | translate,
            input_placeholder: 'Whatsapp' | translate
        } %}
        {% endembed %}
        
        {# Campo Mensaje - MISMOS IDs que contact.tpl #}
        {% embed "snipplets/forms/form-input.tpl" with{
            text_area: true,
            input_for: 'message',
            input_name: 'message',
            input_id: 'message',
            input_rows: '7',
            input_label_text: 'Mensaje' | translate,
            input_placeholder: 'Mensaje' | translate
        } %}
        {% endembed %}
        
    {% endblock %}
{% endembed %}
```

### Archivo Completo
Ver: `snipplets/home/home-formulario.tpl`

---

## 📚 Referencias

- **Template de contacto:** `templates/contact.tpl`
- **Formulario base:** `snipplets/forms/form.tpl`
- **Input template:** `snipplets/forms/form-input.tpl`
- **Enlaces de contacto:** `snipplets/contact-links.tpl`
- **Documentación Tiendanube:** https://ayuda.tiendanube.com/

---

## 💡 Consejos

1. **Siempre incluye el honeypot** en todos los formularios
2. **Usa `| translate`** para todos los textos traducibles
3. **Valida campos requeridos** usando `input_required: true`
4. **Mantén consistencia** usando los componentes de formulario del tema
5. **Testa en diferentes dispositivos** para asegurar que sea responsive

---

---

## 🔑 Puntos Clave para Crear Formularios de Contacto Exitosos

### 1. Identificadores Obligatorios
Siempre usa estos valores exactos para formularios de contacto:
- `form_id: 'contact-form'`
- `data_store: 'contact-form'`
- `form_action: '/winnie-pooh'`

### 2. Estructura Mínima Requerida
Todo formulario de contacto debe incluir:
- Campo honeypot `winnie-pooh` (oculto)
- Campo oculto `type="contact"`
- Campos: `name`, `email`, `phone`, `message` (con esos IDs exactos)

### 3. Mejor Práctica
Usa `templates/contact.tpl` como plantilla de referencia. Si vas a crear un nuevo formulario:
1. Copia la estructura exacta
2. Cambia solo los placeholders y labels
3. Mantén los IDs, nombres y estructura idénticos

### 4. Cuando NO Funciona
Si el formulario se envía pero no aparece en el panel:
- ✅ Verifica que `form_id` sea `'contact-form'`
- ✅ Verifica que `data_store` sea `'contact-form'`
- ✅ Verifica que los IDs de campos coincidan (`name`, `email`, `phone`, `message`)
- ✅ Verifica que la estructura sea idéntica a `contact.tpl`

---

**Última actualización:** Diciembre 2024
**Autor:** Documentación del proyecto Scatola
**Versión:** 2.0 (Actualizada con caso de estudio del formulario en Home)

